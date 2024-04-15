//  FriendsViewModel.swift


import Foundation
import Firebase

struct User: Identifiable {
    var id: String
    var username: String
    var friends: [String] = []
    var friendRequests: [FriendRequest] = []
}


struct FriendRequest: Identifiable {
    var id: String
    var from: String
    var to: String
    var status: RequestStatus
}

enum RequestStatus: String {
    case pending = "Pending"
    case accepted = "Accepted"
    case rejected = "Rejected"
}

class FriendsViewModel: ObservableObject {
    @Published var friends: [String] = []
    @Published var friendRequests: [FriendRequest] = []
    
    private var db = Firestore.firestore()
    private var userSession: User? 
    
    func fetchFriends() {
        guard let user = userSession else { return }
        
        db.collection("User").document(user.id).collection("friends").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                self.friends = snapshot.documents.map { $0["username"] as? String ?? "" }
            }
        }
    }
    
    func sendFriendRequest(to username: String) {
        guard let sender = userSession else { return }
        
        let usersRef = db.collection("User")
        usersRef.whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                print("User not found")
                return
            }
            
            let receiverId = snapshot.documents.first!.documentID
            let request = FriendRequest(id: UUID().uuidString, from: sender.username, to: username, status: .pending)
            
            usersRef.document(receiverId).collection("friendRequests").document(request.id).setData([
                "from": sender.username,
                "to": username,
                "status": "Pending"
            ])
        }
    }
    
    func respondToRequest(_ request: FriendRequest, accept: Bool) {
        guard let user = userSession else { return }
        
        db.collection("User").document(user.id).collection("friendRequests").document(request.id).updateData([
            "status": accept ? "Accepted" : "Rejected"
        ]) { error in
            if accept {
                self.addFriend(for: request.from)
            } else {
                // Optionally handle rejection notification to the sender
            }
        }
    }
    
    private func addFriend(for username: String) {
        guard let user = userSession else { return }
        
        db.collection("User").document(user.id).collection("friends").addDocument(data: ["username": username])
        db.collection("User").whereField("username", isEqualTo: username).getDocuments { snapshot, _ in
            if let docId = snapshot?.documents.first?.documentID {
                self.db.collection("User").document(docId).collection("friends").addDocument(data: ["username": user.username])
            }
        }
    }
}
