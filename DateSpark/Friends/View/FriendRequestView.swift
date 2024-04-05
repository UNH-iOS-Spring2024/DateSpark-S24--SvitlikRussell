//  FriendRequestView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FriendRequestView: View {
    let db = Firestore.firestore()
    
    @State private var friendRequests: [FriendRequest] = []
    let friendRequest: FriendRequest

    var body: some View {
        List{
            ForEach(friendRequests){request in
                HStack{
                    Text(request.uniqueIdentifier)
                    Spacer()
                    Button("Confirm") {
                        updateFriendRequest(requestId: request.id, status: "confirmed")
                    }
                    Button("Deny") {
                        updateFriendRequest(requestId: request.id, status: "denied")
                    }
                }
            }
        }
        .onAppear(perform: fetchFriendRequests)
    }
    
    func fetchFriendRequests() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("Users").document(userId).collection("friendRequests")
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching friend requests: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.friendRequests = documents.map { doc in
                    FriendRequest(id: doc.documentID, uniqueIdentifier: doc["uniqueIdentifier"] as? String ?? "", status: doc["status"] as? String ?? "pending")
                }
            }
    }

    func updateFriendRequest(requestId: String, status: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let requestRef = db.collection("Users").document(userId).collection("friendRequests").document(requestId)
        requestRef.updateData(["status": status]) { error in
            if let error = error {
                print("Error updating request: \(error.localizedDescription)")
                return
            }
            if status == "confirmed" {
                addFriend(for: requestId)
            }
            fetchFriendRequests()
        }
    }

    func addFriend(for friendId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        // Assuming there's a 'friends' subcollection to store friend relationships
        let userRef = db.collection("Users").document(userId)
        let friendRef = db.collection("Users").document(friendId)

        // Add friendId to the current user's 'friends' collection
        userRef.collection("friends").document(friendId).setData(["uniqueIdentifier": friendId]) { error in
            if let error = error {
                print("Error adding friend: \(error.localizedDescription)")
                return
            }
            // Optionally, add userId to the friend's 'friends' collection for bidirectional friendship
            friendRef.collection("friends").document(userId).setData(["uniqueIdentifier": userId])
        }
    }
}

struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let mockFriendRequest = FriendRequest(id: "mockID", uniqueIdentifier: "MockUniqueIdentifier123", status: "pending")
        FriendRequestView(friendRequest: mockFriendRequest)
    }
}
