//  FriendsView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FriendsView: View {
    let db = Firestore.firestore()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = FriendRequestsViewModel()
    
    @State private var showingAddFriendView = false
    @State private var friends: [Friend] = []
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Friend Requests")) {
                    ForEach(viewModel.friendRequests.filter { $0.status == "confirmed" }, id: \.id) { friendRequest in
                        Text(friendRequest.receiverUsername) // Assuming the receiver is the friend
                    }
                }
                Section(header: Text("Friends")) {
                    ForEach(friends, id: \.id) { friend in
                        Text(friend.uniqueIdentifier)
                    }
                }
            }
            .navigationTitle("Friends")
            .toolbar{
                Button(action:{showingAddFriendView = true}){
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddFriendView, onDismiss: fetchFriendsList) {
                AddFriendView(completion: {
                    showingAddFriendView = false
                    fetchFriendsList()
                })
            }
        }
        .onAppear(perform: fetchFriendsList)
    }
    
    func fetchFriendsList() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("User").document(userId).collection("friends")
            .getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents else {                     print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.friends = documents.map { doc -> Friend in
                    let username = doc.data()["username"] as? String ?? "Unknown"
                    return Friend(id: doc.documentID, uniqueIdentifier: username)
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
