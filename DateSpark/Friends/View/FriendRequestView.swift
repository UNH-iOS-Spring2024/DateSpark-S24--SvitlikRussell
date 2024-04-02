//  FriendRequestsView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FriendRequestView: View {
    let db = Firestore.firestore()
    var requestEmail: String
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            Text(requestEmail)
            Spacer()
            Button("Confirm") {
                updateFriendRequest(status: "confirmed")
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button("Deny") {
                updateFriendRequest(status: "denied")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
    }
    
    func updateFriendRequest(status: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("User").document(userId).collection("friendRequests")
           .whereField("email", isEqualTo: requestEmail)
           .getDocuments { snapshot, error in
               guard let documents = snapshot?.documents, !documents.isEmpty else { return }
               
       let requestDocId = documents.first!.documentID
       
       db.collection("User").document(userId).collection("friendRequests").document(requestDocId).updateData([
           "status": status,
       ]) { error in
           if let error = error {
               print("Error updating request: \(error.localizedDescription)")
           } else {
               print("Request \(status)")
               self.presentationMode.wrappedValue.dismiss()
           }
        }
    }
}

}
struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestView(requestEmail: "srussell@gmail.com")// Basic test
       
    }
}
