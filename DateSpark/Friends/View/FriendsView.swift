//  FriendsView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FriendsView: View {
    let db = Firestore.firestore()
    
    @State private var showingAddFriendPopover = false
    @State private var showAlert = false
    @State private var friendEmail = ""
    @State private var alertMessage = ""
    @State private var friendRequests: [String] = []

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Friend Requests")) {
                    ForEach(friendRequests, id: \.self) { request in
                        FriendRequestView(requestEmail: request)
                    }
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                Button(action: {
                    showingAddFriendPopover = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .popover(isPresented: $showingAddFriendPopover) {
                VStack {
                    Text("Enter friend's email:")
                    TextField("Email", text: $friendEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    Button("Add") {
                        checkEmailAndSendRequest(email: friendEmail)
//                        friendEmail = "" // Reset the input field after attempt
//                        showingAddFriendPopover = false // Dismiss the popover
                    }
                    .padding()
                }
                .padding()
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text("Friend Request"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            fetchFriendRequests()
        }
    }

    func checkEmailAndSendRequest(email: String) {
        db.collection("User").whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                self.alertMessage = "Error: \(error.localizedDescription)"
                self.showAlert = true
            } else if snapshot!.documents.isEmpty {
                self.alertMessage = "No user found with that email."
                self.showAlert = true
            } else {
                let userId = Auth.auth().currentUser?.uid ?? ""
                let friendUserId = snapshot!.documents.first!.documentID
                let friendRequestRef = db.collection("User").document(userId).collection("friendRequests").document(friendUserId)
                
                friendRequestRef.setData(["email": email, "status": "pending"]) { error in
                if let error = error {
                    self.alertMessage = "Failed to send friend request: \(error.localizedDescription)"
                } else {
                    self.alertMessage = "Friend request sent to \(email)"
                }
                self.showAlert = true
            }
            }
            
        }
        self.friendEmail = ""
        self.showingAddFriendPopover = false
    }
    
    func fetchFriendRequests() {
       guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let friendRequestsRef = db.collection("User").document(userId).collection("friendRequests")
        friendRequestsRef.getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                // Assuming the friend request documents contain an "email" field
                self.friendRequests = documents.compactMap { $0.data()["email"] as? String }
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
