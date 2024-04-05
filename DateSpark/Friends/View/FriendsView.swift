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
    @State private var friendRequests: [FriendRequest] = []
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Friend Requests")){
                    ForEach(friendRequests){ request in
                        FriendRequestView(friendRequest: request)
                    }
                }
                Section(header: Text("Friends")){
                    ForEach( friends, id:\.id ){ friend in
                        Text(friend.uniqueIdentifier)
                    }
                }
            }
//            List(friends, id:\.id ){ friend in
//                Text(friend.uniqueIdentifier)
//            }
            .navigationTitle("Friend")
            .toolbar{
                Button(action: {
                    showingAddFriendView = true
                }){
                    Image(systemName: "plus" )
                }
            }
            .sheet(isPresented: $showingAddFriendView, onDismiss: friendsList) {
                AddFriendView(completion: {
                    showingAddFriendView = false
                    fetchFriendRequests()
                    friendsList()
                })
            }
        }
        .onAppear{ friendsList() }
    }
    
    func friendsList(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userRef = db.collection("Users").document(userId)
        userRef.collection("friends").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No friends found")
                return
            }
            
            self.friends = documents.map { doc -> Friend in
                let uniqueIdentifier = doc.data()["uniqueIdentifier"] as? String ?? ""
                return Friend(id: doc.documentID, uniqueIdentifier: uniqueIdentifier)
            }
        }
    }
    func fetchFriendRequests() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("Users").document(userId).collection("friendRequests")
            .whereField("status", isEqualTo: "pending")
            .getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching friend requests: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.friendRequests = snapshot.documents.map { doc in
                    // Assuming each document correctly maps to a FriendRequest
                    FriendRequest(id: doc.documentID, uniqueIdentifier: doc.data()["uniqueIdentifier"] as? String ?? "", status: doc.data()["status"] as? String ?? "")
                }
            }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
