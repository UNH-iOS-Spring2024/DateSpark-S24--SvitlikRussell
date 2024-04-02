//  ProfileView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    let db = Firestore.firestore()
    @State private var isSignedOut = false
    @State private var showingSignOutConfirmation = false
    @State private var userProfile = UserProfile(
        firstName: "",
        lastName: "",
        prefName: "",
        email:"",
        userID: "" ,
        joinedDate: "" )
    
    
    private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }

    private func attemptSignOut() {
        showingSignOutConfirmation = true
        print("Attempting to sign out...")
        }
    private func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedOut = true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }



    
    var body: some View {
        VStack{
            HStack{
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Spacer()
            }
            .padding(.leading)
            
            Text(userProfile.prefName)
                .font(.largeTitle)
                .padding(.top, 20)
            
            Image("PlaceholderImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 4))
                .shadow(radius: 10)
            
            Spacer()
            Group{
                HStack{
                    Text("First Name: ")
                    Text (userProfile.firstName)
                }
                HStack{
                    Text("Last Name: ")
                    Text (userProfile.lastName)
                }
                HStack{
                    Text("Email: ")
                    Text (userProfile.email)
                }
                HStack {
                    Text("User ID: ")
                    Text(userProfile.userID)
                        .onTapGesture {
                            UIPasteboard.general.string = userProfile.userID
                        }
                    if !userProfile.userID.isEmpty {
                        Image(systemName: "doc.on.doc")
                            .onTapGesture {
                                UIPasteboard.general.string = userProfile.userID
                            }
                    }
                }
                HStack{
                    Spacer()
                    Text("Joined: ")
                    Text (userProfile.joinedDate)
                        .underline()
                    Spacer()
                }
            }
            Spacer()
            
            Button("Sign Out"){
                attemptSignOut()


            }
                .padding()
                .border(Color.blue, width: 2)
                .confirmationDialog("Are you sure you want to sign out?", isPresented: $showingSignOutConfirmation, actions:{
                    Button("Sign Out", role: .destructive){
                        signOut()
                        print("Sign Out Button")
                
                    }
                    Button("Cancel", role: .cancel){
                        print("Sign Out Button Cancelled")
                    }
                })
        NavigationLink(destination: Login(isLoggedIn: .constant(false)), isActive: $isSignedOut){
            EmptyView() } // Redirect to Login Page, currently not working
        
            
            

                    
            
            
        }
        
        .onAppear{
            fetchUserProfile()
        }
    }
    
    func fetchUserProfile(){
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        
        db.collection("User").whereField("email", isEqualTo: userEmail).getDocuments {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                let data = document.data()
                let joinedTimestamp = data["joinedDate"] as? Timestamp ?? Timestamp()
                let joinedDate = formatDate(joinedTimestamp.dateValue())
                
                self.userProfile = UserProfile(
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    prefName: data["prefName"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    userID: document.documentID,
                    joinedDate: joinedDate
                    )
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
