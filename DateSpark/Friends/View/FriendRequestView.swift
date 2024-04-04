//  FriendRequestsView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FriendRequestView: View {
    let db = Firestore.firestore()
    let request: FriendRequest
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            Text(request.email)
            Spacer()
            Button("Confirm") {
                updateFriendRequest(status: "confirmed", for: request.id)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button("Deny") {
                updateFriendRequest(status: "denied", for: request.id)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
    }
    
    func updateFriendRequest(status: String, for requestId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let friendRequestRef = Firestore.firestore().collection("Users").document(userId).collection("friendRequests").document(requestId)
                friendRequestRef.updateData(["status": status]) { error in
                    if let error = error {
                        print("Error updating request: \(error.localizedDescription)")
                    } else {
                        print("Request \(status)")

        }
    }
}

}
struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestView(request: FriendRequest(id: "testID", email: "shannon@gmail.com", status: "pending"))
    }
}
