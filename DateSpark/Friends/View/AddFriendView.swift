//  FriendRequestsView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AddFriendView: View {
    let db = Firestore.firestore()
    let completion: () -> Void
    @State private var uniqueIdentifier = ""
    @State private var feedbackMessage: String = ""
    @State private var showingFeedbackAlert = false

    var body: some View {
        VStack {
            TextField("Enter the user name", text: $uniqueIdentifier)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Add Friend") {
                addFriendRequest()
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $showingFeedbackAlert) {
            Alert(title: Text("Add Friend"), message: Text(feedbackMessage), dismissButton: .default(Text("OK"), action: completion))
        }
    }
    
    func addFriendRequest() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return }
        
        db.collection("User").whereField("uniqueIdentifier", isEqualTo: uniqueIdentifier).getDocuments { (querySnapshot, error) in
            if let error = error {
                feedbackMessage = "Failed to find user: \(error.localizedDescription)"
                showingFeedbackAlert = true
            } else if let document = querySnapshot?.documents.first, let friendUserID = document.documentID as String? {
                sendFriendRequest(toUserID: friendUserID, fromUserId: currentUserID)
            } else {
                feedbackMessage = "No user found."
                showingFeedbackAlert = true
            }
        }
    }
    
    func sendFriendRequest(toUserID: String, fromUserId: String) {
        guard toUserID != fromUserId else {
            feedbackMessage = "You cannot add yourself as a friend, silly."
            showingFeedbackAlert = true
            return
        }

        let friendRequestRef = db.collection("User").document(toUserID).collection("friendRequests").document(fromUserId)
        
        friendRequestRef.getDocument {(document, error) in
            if let document = document, document.exists {
                feedbackMessage = "Friend request already sent."
                showingFeedbackAlert = true
            } else {
                friendRequestRef.setData(["status": "pending", "uniqueIdentifier": uniqueIdentifier ?? ""]) { error in
                    if let error = error {
                        feedbackMessage = "Failed to send friend request: \(error.localizedDescription)"
                    } else {
                        feedbackMessage = "Friend request sent successfully!"
                    }
                    showingFeedbackAlert = true
                }
            }
        }
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView(completion: {})
    }
}
