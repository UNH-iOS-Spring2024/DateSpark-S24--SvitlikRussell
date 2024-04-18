//  ProfileView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI

struct ProfileView: View {
    let db = Firestore.firestore()
    @EnvironmentObject var appVariables: AppVariables
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var profileImageUrl: URL?
    @State private var isSignedOut = false
    @State private var showingSignOutConfirmation = false
    @State private var userProfile = UserProfile(
        firstName: "",
        lastName: "",
        username: "",
        email:"",
        joinedDate: "")
    
    private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
    private func signOut() {
        do {
            try Auth.auth().signOut()
            appVariables.isSignedOut = true
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
            
            Text(userProfile.username)
                .font(.largeTitle)
                .padding(.top, 20)
            
            Image(uiImage: inputImage ?? UIImage(named: "PlaceholderImage")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 4))
                .shadow(radius: 10)
                .onTapGesture { showImagePicker = true }
                .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                    PHPickerViewController.View(image: $inputImage)

                }
            
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
                showingSignOutConfirmation = true
                signOut()
    
            }
            .padding()
            .border(Color.blue, width: 2)
            .confirmationDialog("Are you sure you want to sign out?", isPresented: $showingSignOutConfirmation){
                Button("Sign Out", role: .destructive){
                    signOut()
                }
                Button("Cancel", role: .cancel){ }
            }
            .navigationTitle("Profile")
            .onAppear{ fetchUserProfile() }
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
                
                if let imageUrlString = data["profileImageUrl"] as? String, let imageUrl = URL(string: imageUrlString) {
                    self.profileImageUrl = imageUrl
                    URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                        if let data = data {
                            self.inputImage = UIImage(data: data)
                        }
                    }.resume()
                }
                self.userProfile = UserProfile(
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    username: data["username"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joinedDate: joinedDate
                    )
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        uploadImage(image: inputImage)
    }
    
    func uploadImage (image: UIImage){
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let userProfileRef = storageRef.child("profileImages/\(Auth.auth().currentUser?.uid ?? "unknownUser").jpg")
        
        userProfileRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else { return }
            
            userProfileRef.downloadURL { url, error in
                guard let downloadURL = url else { return}
                
                updateProfileImageUrl(downloadURL)
                self.profileImageUrl = downloadURL
            }
        }
    }
    
    func updateProfileImageUrl(_ url: URL) {
        let userEmail = Auth.auth().currentUser?.email ?? ""
        db.collection("User").whereField("email", isEqualTo: userEmail).getDocuments { (querySnapshot, err) in
            guard let document = querySnapshot?.documents.first else { return }
            let userRef = db.collection("User").document(document.documentID)
            userRef.updateData(["profileImageUrl": url.absoluteString])
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AppVariables())
    }
}
