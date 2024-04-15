//  FriendsListViewModel.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import Foundation
import FirebaseFirestore

class FriendsListViewModel: ObservableObject {
    @Published var friends: [String] = []
    private var db = Firestore.firestore()
    private let currentUser = "currentUsername" // This should be dynamic based on user session.

    func fetchFriends() {
        db.collection("User").document(currentUser).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let data = document.data()
            self.friends = data?["friends"] as? [String] ?? []
        }
    }

    func sendFriendRequest(to username: String, completion: @escaping (Bool, String) -> Void) {
        let userRef = db.collection("User").document(username)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                userRef.updateData([
                    "friendRequests": FieldValue.arrayUnion([self.currentUser])
                ]) { err in
                    if let err = err {
                        completion(false, "Error updating document: \(err)")
                    } else {
                        completion(true, "Request sent successfully.")
                    }
                }
            } else {
                completion(false, "Username not found.")
            }
        }
    }

    func respondToFriendRequest(from username: String, accept: Bool) {
        let currentUserRef = db.collection("User").document(currentUser)
        let requesterRef = db.collection("User").document(username)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            transaction.updateData([
                "friendRequests": FieldValue.arrayRemove([username])
            ], forDocument: currentUserRef)

            if accept {
                transaction.updateData([
                    "friends": FieldValue.arrayUnion([username])
                ], forDocument: currentUserRef)
                transaction.updateData([
                    "friends": FieldValue.arrayUnion([self.currentUser])
                ], forDocument: requesterRef)
            } else {
                // Optionally send a notification or message to the requester
            }
            return nil
        }) { _, error in
            if let error = error {
                print("Transaction failed: \(error)")
            }
        }
    }
}
