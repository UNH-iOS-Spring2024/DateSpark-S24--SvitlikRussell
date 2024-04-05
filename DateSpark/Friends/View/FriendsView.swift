//  FriendsView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FriendsView: View {
    let db = Firestore.firestore()
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddFriendView = false
    @State private var friends: [Friend] = []
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Friend Requests")) {
                    NavigationLink("View Friend Requests", destination: FriendRequestView())
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
                guard let documents = snapshot?.documents else { return }
                self.friends = documents.map { doc -> Friend in
                    let uniqueIdentifier = doc.data()["uniqueIdentifier"] as? String ?? ""
                    return Friend(id: doc.documentID, uniqueIdentifier: uniqueIdentifier)
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
