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
    @State private var feedbackAlert = false
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Enter the username", text: $uniqueIdentifier)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Add Friend"){
                addFriendRequest()
            }.padding()
        }
        .padding()
        .alert(isPresented: $feedbackAlert){
            Alert(
                title: Text("Friend Request"),
                message: Text(feedbackMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func addFriendRequest(){
        guard let currentUserID = Auth.auth().currentUser?.uid else{
            feedbackMessage = "You need to be logged in to send a friend request."
            return
        }
        
        db.collection("User").whereField("uniqueNameIdentifier", isEqualTo: uniqueIdentifier).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                feedbackMessage = "Failed to find user."
                feedbackAlert = true
            } else {
                if let document = querySnapshot?.documents.first {
                    sendFriendRequest(toUserID: document.documentID, fromUserId: currentUserID)
                } else {
                    feedbackMessage = "No user found."
                    feedbackAlert = true
                }
            }
        }
    }
    
    func sendFriendRequest(toUserID: String, fromUserId: String){
        let friendRequestRef = db.collection("Users").document(toUserID).collection("friendRequests").document(fromUserId)
        friendRequestRef.setData(["status": "pending"]) { error in
            if let error = error {
                print("Error sending friend request: \(error.localizedDescription)")
                feedbackMessage = "Failed to send friend request."
            } else {
                feedbackMessage = "Friend request sent to \(uniqueIdentifier)!"
            }
            feedbackAlert = true
            completion()
        }
        
    }
    
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView(completion: {})
    }
}
