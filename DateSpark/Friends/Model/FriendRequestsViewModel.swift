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

    func fetchFriendRequests() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("User").document(userId).collection("friendRequests")
            .whereField("status", isEqualTo: "pending")
            .getDocuments {  snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching friend requests: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.friendRequests = documents.map { doc in
                    FriendRequest(id: doc.documentID, uniqueIdentifier: doc["uniqueIdentifier"] as? String ?? "", status: "pending")
                }
            }
    }

    func updateFriendRequest(requestId: String, status: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let requestRef = db.collection("User").document(userId).collection("friendRequests").document(requestId)
        requestRef.updateData(["status": status]) { [weak self] error in
            if let error = error {
                print("Error updating request: \(error.localizedDescription)")
                return
            }
            self?.fetchFriendRequests()
        }
    }
}
