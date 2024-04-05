//
//  FriendRequestsViewModel.swift
//  DateSpark
//
//  Created by Shannon Russell on 4/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FriendRequestsViewModel: ObservableObject {
    @Published var friendRequests: [FriendRequest] = []
    let db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }
    
    init() {
        fetchFriendRequests()
    }
    
    func fetchFriendRequests() {
        guard let userId = userId else { return }

        db.collection("Users").document(userId).collection("friendRequests")
            .whereField("status", isEqualTo: "pending")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching friend requests: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self?.friendRequests = documents.map { doc in
                    FriendRequest(id: doc.documentID,
                                  uniqueIdentifier: doc["uniqueIdentifier"] as? String ?? "",
                                  status: "pending")
                }
            }
    }
    
    func updateFriendRequest(requestId: String, status: String) {
        guard let userId = userId else { return }
        
        let requestRef = db.collection("Users").document(userId).collection("friendRequests").document(requestId)
        requestRef.updateData(["status": status]) { error in
            if let error = error {
                print("Error updating request: \(error.localizedDescription)")
            } else {
                self.fetchFriendRequests()
                if status == "confirmed" {
                    self.addFriend(for: requestId)
                }
            }
        }
    }
    
    func addFriend(for friendId: String) {
        guard let userId = userId else { return }
        
        // This assumes a structure where each user's document in 'Users' collection has a 'friends' subcollection
        let userFriendsRef = db.collection("Users").document(userId).collection("friends").document(friendId)
        let friendFriendsRef = db.collection("Users").document(friendId).collection("friends").document(userId)
        
        userFriendsRef.setData(["uniqueIdentifier": friendId]) { error in
            if let error = error {
                print("Error adding friend: \(error.localizedDescription)")
            } else {
                friendFriendsRef.setData(["uniqueIdentifier": userId])
            }
        }
    }
}
