//Sarah Svitlik & Shannon Russell

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
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack{
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                }
                
                Text("Sign in!")
                    .font(titleFont)
                    .bold()
                    .padding(.bottom, 30)
                
                TextField("Username", text: $txtusername)
                    .font(.system(size:30))
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $txtPassword)
                    .font(.system(size:30))
                    .padding(.bottom, 20)
                
                Button(action: loginUser) {
                    Text("Login")
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                }
                
                NavigationLink(destination: SignUp(), label: {
                    Text("Don't have an account? Sign Up")
                })
                .padding(.bottom, 30)

                NavigationLink(destination: HomeView(), isActive: $shouldNavigateToHome) { EmptyView() }
            }
            .multilineTextAlignment(.center)
            .padding()
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
                print("Error getting documents: \(err)")
                showAlert(message: "Error occurred while fetching user data. Please try again later.")
            } else if let document = querySnapshot?.documents.first, let email = document.data()["email"] as? String {
                Auth.auth().signIn(withEmail: email, password: txtPassword) { authResult, error in
                    if let error = error {
                        print("Error signing in: \(error.localizedDescription)")
                        showAlert(message: "Incorrect username/ password. Please try again.")
                    } else {
                        print("User logged in successfully")
                        appVariables.isLoggedIn = true
                        shouldNavigateToHome = true
                    }
                }
            } else {
                print("No such user found")
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
