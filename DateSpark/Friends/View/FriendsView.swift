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
            List(friends, id:\.id ){ friend in
                Text(friend.uniqueIdentifier)
            }
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
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
