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
//    @Published var friends: [String] = []
    @Published var friends: [String] = ["Alice", "Bob", "Carol"]

    @Published var friendRequests: [FriendRequest] = []
    
    private var db = Firestore.firestore()
    private var userSession: User? 
    
    init() {
            loadMockFriendRequests()
        }
    
    func sendFriendRequest(to username: String, completion: @escaping (String) -> Void) {
        guard let sender = userSession, sender.username != username else {
            completion("You cannot add yourself as a friend.")
            return
        }
        let usersRef = db.collection("User")
        usersRef.whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                completion("User not found.")
                return
            }
            
            if let receiverDoc = snapshot.documents.first, receiverDoc.documentID != sender.id {
                let request = FriendRequest(id: UUID().uuidString, from: sender.username, to: username, status: .pending)
                
                usersRef.document(receiverDoc.documentID).collection("friendRequests").document(request.id).setData([
                    "from": sender.username,
                    "to": username,
                    "status": "Pending"
                ]) { err in
                    if let err = err {
                        completion("Error sending request: \(err.localizedDescription)")
                    } else {
                        completion("Friend request sent successfully to \(username).")
                    }
                }
            }
        }
    }
    
    
    func searchUsers(query: String, completion: @escaping ([String]) -> Void){
         db.collection("User")
            .whereField("username", isGreaterThanOrEqualTo: query)
            .whereField("username", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else{
                    completion([])
                    return
                }
                let names = documents.map { $0["username"] as? String ?? ""}
                completion(names)
            }
    }
    
    func loadMockFriendRequests() {
            friendRequests = [
                FriendRequest(id: "1", from: "Alice", to: "User123", status: .pending),
                FriendRequest(id: "2", from: "Bob", to: "User123", status: .pending),
                FriendRequest(id: "3", from: "Carol", to: "User123", status: .pending)
            ]
        }
    
    func fetchFriends() {
        guard let user = userSession else { return }
        
        db.collection("User").document(user.id).collection("friends").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                self.friends = snapshot.documents.map { $0["username"] as? String ?? "" }
            }
        }
    }
    
    func respondToRequest(_ request: FriendRequest, accept: Bool) {
        guard let user = userSession else { return }
        
        // Update Firestore data
        db.collection("User").document(user.id).collection("friendRequests").document(request.id).updateData([
            "status": accept ? "Accepted" : "Rejected"
        ]) { [weak self] error in
            if let self = self, error == nil {
                // Immediately update local data
                if accept {
                    self.addFriend(for: request.from)
                }
                self.removeRequest(request)
            }
        }
    }
    func removeRequest(_ request: FriendRequest) {
        // Remove the request from the local array
        friendRequests.removeAll { $0.id == request.id }
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
