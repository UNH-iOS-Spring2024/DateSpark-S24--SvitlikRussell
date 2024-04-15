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
    private let db = Firestore.firestore()
    private var currentUser: String {
        return Auth.auth().currentUser?.displayName ?? "currentUser" // Replace "defaultUsername" with appropriate fallback
    }
    
    func sendFriendRequest(to username: String){
        guard username != currentUser else{
            print("Cannot send yourself a friend request.")
            return
        }
        
        let newRequest = [
            "senderUsername": currentUser,
            "receiverUsername": username,
            "status": "pending"
        ]
        //        let newRequest = FriendRequest(id: UUID().uuidString, senderUsername: currentUser, receiverUsername: username, status: "pending")
        db.collection("friendRequests").addDocument(data: newRequest){ error in
            if let error = error {
                print("Error sending friend request: \(error.localizedDescription)")
            } else {
                print("Friend request successfully sent.")
            }
        }
    }
    
//    func fetchFriendRequests() {
//        db.collection("friendRequests")
//            .whereField("receiverUsername", isEqualTo: currentUser)
//            .whereFireld("status", isEqualTo: "pending")
//            .addSnapshotListener { [weak self] querySnapshot, error in
//                if let error = error {
//                    print("Error fetching friend requests: \(error.localizedDescription)")
//                    return
//                }
//                self?.friendRequests = querySnapshot?.documents.compactMap { document in
//                    guard let sender = document.data()["senderUsername"] as? String,
//                          let receiver = document.data()["receiverUsername"] as? String,
//                          let status = document.data()["status"] as? String else {
//                        return nil
//                    }
//                    return FriendRequest(id: document.documentID, senderUsername: sender, receiverUsername: receiver, status: status)
//                } ?? []
//            }
//    }
    
    func fetchPendingFriendRequests() {
        db.collection("friendRequests")
            .whereField("receiverUsername", isEqualTo: currentUser)
            .whereField("status", isEqualTo: "pending")
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    print("Error fetching friend requests: \(error.localizedDescription)")
                    return
                }
                
                self?.friendRequests = querySnapshot?.documents.compactMap { document in
                    guard let sender = document.data()["senderUsername"] as? String,
                          let receiver = document.data()["receiverUsername"] as? String,
                          let status = document.data()["status"] as? String else {
                        return nil
                    }
                    return FriendRequest(id: document.documentID, senderUsername: sender, receiverUsername: receiver, status: status)
                } ?? []
            }
        
        func updateFriendRequest(id: String, newStatus: String, completion: @escaping () -> Void) {
            db.collection("friendRequests").document(id).updateData(["status": newStatus]) { error in
                if let error = error {
                    print("Error updating friend request: \(error.localizedDescription)")
                } else {
                    print("Friend request status updated to \(newStatus).")
                }
                completion()
            }
        }
    }
}
