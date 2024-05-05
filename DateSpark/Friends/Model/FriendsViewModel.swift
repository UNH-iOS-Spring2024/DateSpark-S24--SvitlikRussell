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
    @Published var newFriendRequestReceived: Bool = false
    private var db = Firestore.firestore()
    private var userSession: User?
    
    init() { fetchCurrentUser() }
    
    func fetchCurrentUser(){
        Auth.auth().addStateDidChangeListener{[weak self] (auth,user) in
            if let userID = user?.uid {
                self?.db.collection("User").document(userID).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let username = document.data()?["username"] as? String ?? "Unknown"
                        self?.userSession = User(id: userID, username: username)
                        self?.fetchFriends()
                        self?.fetchFriendRequests()
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    func sendFriendRequest(to username: String, completion: @escaping (String) -> Void) {
        guard let sender = userSession, sender.username != username else {
            completion("You cannot add yourself as a friend, silly.")
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
    
    func receiveFriendRequest() {
        self.newFriendRequestReceived = true
    }
    
    func fetchFriends() {
        guard let user = userSession else { return }
        db.collection("User").document(user.id).collection("friends").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                self.friends = snapshot.documents.map { $0["username"] as? String ?? "" }
            }
        }
    }
    
    func fetchFriendRequests() {
        guard let user = userSession else { return }
        db.collection("User").document(user.id).collection("friendRequests").whereField("status", isEqualTo: "Pending").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                self.friendRequests = snapshot.documents.map { doc -> FriendRequest in
                    let id = doc.documentID
                    let from = doc["from"] as? String ?? ""
                    let to = doc["to"] as? String ?? ""
                    return FriendRequest(id: id, from: from, to: to, status: .pending)
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
    

    func respondToRequest(_ request: FriendRequest, accept: Bool) {
        guard let user = userSession else { return }
        let requestRef = db.collection("User").document(user.id).collection("friendRequests").document(request.id)
        if accept {
            requestRef.updateData(["status": "Accepted"]) { [weak self] error in
                guard let self = self else { return }
                if error == nil {
                    self.addFriend(for: request.from, to: request.to)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.removeRequest(request)
                    }
                }
            }
        } else {
            requestRef.delete { [weak self] error in
                guard let self = self else { return }
                if error == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.removeRequest(request)
                    }
                }
            }
        }
    }


    func removeRequest(_ request: FriendRequest) {
        friendRequests.removeAll { $0.id == request.id } // Remove the request in app once accepted/denied
    }
    
    private func addFriend(for senderUsername: String, to receiverUsername: String) {
        let usersRef = db.collection("User")
        usersRef.whereField("username", isEqualTo: senderUsername).getDocuments { [weak self] snapshot, _ in
            guard let self = self, let senderId = snapshot?.documents.first?.documentID else { return }
            usersRef.document(senderId).collection("friends").addDocument(data: ["username": receiverUsername])
            usersRef.whereField("username", isEqualTo: receiverUsername).getDocuments { snapshot, _ in
                if let receiverId = snapshot?.documents.first?.documentID {
                    usersRef.document(receiverId).collection("friends").addDocument(data: ["username": senderUsername])
                    self.fetchFriends() // Fetch the updated friends list
                }
            }
        }
    }
}
