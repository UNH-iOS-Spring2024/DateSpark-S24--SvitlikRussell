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
    let storage = Storage.storage()
    
    
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
            ZStack(alignment: .bottomTrailing){
                Image(uiImage: inputImage ?? UIImage(named: "PlaceholderImage")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 4))
                    .shadow(radius: 10)
                Button(action: {
                    self.showImagePicker = true
                }) {
                    Image(systemName: "pencil.tip")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .offset(x: -10, y: -10)
            }
            .onTapGesture { showImagePicker = true }
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                PHPickerViewController.View(image: $inputImage)
            }
            
            VStack(alignment: .center, spacing: 4) {
                Text("\(userProfile.firstName) \(userProfile.lastName)")
                    .font(.system(size: 24))
                    .padding(20)
                Text(userProfile.email)
                    .foregroundColor(.gray)
                    .font(.system(size: 24))
            }
            .font(.system(size: 24))
            .padding(.vertical)
            Spacer()
            HStack {
                Text("Joined: \(userProfile.joinedDate)")
                    .multilineTextAlignment(.leading)
                
                Spacer()
            
                Button("Sign Out") {
                    showingSignOutConfirmation = true
                    signOut()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .confirmationDialog("Are you sure you want to sign out?", isPresented: $showingSignOutConfirmation) {
                    Button("Sign Out", role: .destructive) { signOut() }
                    Button("Cancel", role: .cancel) { }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Profile")
            .onAppear{ fetchUserProfile() }
        }
    }
    
    func fetchUserProfile() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        db.collection("User").whereField("email", isEqualTo: userEmail).getDocuments { (querySnapshot, error) in
            guard let document = querySnapshot?.documents.first, let data = document.data() as? [String: Any] else { return }
            updateProfile(data: data)
        }
    }
    
    func updateProfile(data: [String: Any]) {
        let joinedDate = (data["joinedDate"] as? Timestamp)?.dateValue() ?? Date()
        let newProfile = UserProfile(
            firstName: data["firstName"] as? String ?? "",
            lastName: data["lastName"] as? String ?? "",
            username: data["username"] as? String ?? "",
            email: data["email"] as? String ?? "",
            joinedDate: formatDate(joinedDate)
        )

        DispatchQueue.main.async {
            self.userProfile = newProfile
        }
        
        if let imageUrlString = data["profileImageUrl"] as? String, let imageUrl = URL(string: imageUrlString) {
            self.profileImageUrl = imageUrl
            downloadImage(url: imageUrl)
        }
    }
    
    func downloadImage(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.inputImage = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        uploadImage(image: inputImage)
    }
    
    func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5),
              let userID = Auth.auth().currentUser?.uid else { return }
        let storageRef = storage.reference().child("profileImages/\(userID).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            guard error == nil else { return }
            storageRef.downloadURL { url, _ in
                guard let downloadURL = url else { return }
                self.profileImageUrl = downloadURL
                self.updateProfileImageUrl(downloadURL)
            }
        }
    }
    
    func updateProfileImageUrl(_ url: URL) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("User").document(userID).updateData(["profileImageUrl": url.absoluteString])
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AppVariables())
    }
}
