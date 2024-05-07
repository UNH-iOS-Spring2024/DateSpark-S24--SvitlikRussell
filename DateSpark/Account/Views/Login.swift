// Login.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Login: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appVariables: AppVariables

    @State var txtusername: String = ""
    @State var txtPassword: String = ""
    @State private var shouldNavigateToHome: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @Binding var isLoggedIn: Bool
    let titleFont = Font.largeTitle.lowercaseSmallCaps()
    let headingFont = Font.title.lowercaseSmallCaps()

    var body: some View {
        NavigationStack {
            VStack {
                     HStack {
                         Text("✨Sign in!✨")
                             .font(titleFont)
                             .bold()
                             .padding(.horizontal, 20)
                     
                         Spacer()
                     
                         Image("Logo")
                             .resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 75, height: 100)
                             .padding(.horizontal, 20)

                     }
                     .padding(.top, 170)
                 
             
                TextField("Username", text: $txtusername)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .autocapitalization(.none)
                SecureField("Password", text: $txtPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.bottom,20)


                Button("Sign In!"){
                    loginUser()
                }
                
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding()
                .background(CustomColors.lightPink)
                .cornerRadius(15)
                .disabled(txtusername.isEmpty || txtPassword.isEmpty)
                
                if shouldNavigateToHome {
                    NavigationLink(destination: HomeView(), isActive: $shouldNavigateToHome) { EmptyView() }
                }
                Spacer()
                NavigationLink(destination: SignUp()) {
                    Text("Don't have an account? Sign Up")
                        .font(.system(size: 20))
                        .foregroundColor(CustomColors.darkRed)

                }
             }
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .autocorrectionDisabled(true)
            .padding()
            .background(CustomColors.lightPink.opacity(0.2))
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func loginUser() {
        let usersRef = Firestore.firestore().collection("User")
        usersRef.whereField("username", isEqualTo: txtusername).getDocuments { (querySnapshot, err) in
            if let err = err {
                showAlert(message: "Error occurred while fetching user data. Please try again later.")
            } else if let document = querySnapshot?.documents.first, let email = document.data()["email"] as? String {
                Auth.auth().signIn(withEmail: email, password: txtPassword) { authResult, error in
                    if let error = error {
                         showAlert(message: "Incorrect username/ password. Please try again.")
                    } else {
                         appVariables.isLoggedIn = true
                        shouldNavigateToHome = true
                    }
                }
            } else {
                 showAlert(message: "No user found. Please check and try again.")
            }
        }
    }


    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(isLoggedIn: .constant(false))
            .environmentObject(AppVariables())
    }
}
