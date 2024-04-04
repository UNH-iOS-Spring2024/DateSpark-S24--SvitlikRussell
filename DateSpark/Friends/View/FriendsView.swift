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
    @State private var friendRequests: [FriendRequest] = []

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Friend Requests")) {
                    ForEach(friendRequests) { request in
                        FriendRequestView(request: request)
                            .onAppear{ fetchFriendRequests() }
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
        db.collection("Users").whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents, !documents.isEmpty, let doc = documents.first else {
                self.alertMessage = "No user found with that email."
                self.showAlert = true
                return
            }
            
            let userId = Auth.auth().currentUser?.uid ?? ""
            let friendUserId = doc.documentID
            
            guard userId != friendUserId else {
                self.alertMessage = "You can't add yourself as a friend."
                self.showAlert = true
                return
            }

            let friendRequestRef = self.db.collection("Users").document(friendUserId).collection("friendRequests").document(userId)
            
            friendRequestRef.setData(["email": Auth.auth().currentUser?.email ?? "", "status": "pending"]) { error in
                if let error = error {
                    self.alertMessage = "Failed to send friend request: \(error.localizedDescription)"
                } else {
                    self.alertMessage = "Friend request sent to \(email)"
                }
                self.showAlert = true
                self.friendEmail = ""
                self.showingAddFriendPopover = false
            }
        }
    }
    
    func fetchFriendRequests() {
       guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let friendRequestsRef = db.collection("Users").document(userId).collection("friendRequests")
        friendRequestsRef.whereField("status", isEqualTo: "pending").getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                self.friendRequests = documents.map { doc in
                    FriendRequest(id: doc.documentID, email: doc.data()["email"] as? String ?? "", status: doc.data()["status"] as? String ?? "")
                }
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
