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
    @State private var loginFailed: Bool = false
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
                     .padding(.bottom,30)
                     
                
                TextField("Username", text: $txtusername)
                    .font(.system(size:30))
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $txtPassword)
                    .font(.system(size:30))
                    .padding(.bottom, 20)
                
                if loginFailed {
                    Text("Failed to login. Please check your credentials.")
                        .foregroundColor(.red)
                        .padding()
                }
                
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
        }
    }
    
    func loginUser() {
        let usersRef = Firestore.firestore().collection("User")
        usersRef.whereField("username", isEqualTo: txtusername).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                self.loginFailed = true
            } else if let document = querySnapshot?.documents.first, let email = document.data()["email"] as? String {
                Auth.auth().signIn(withEmail: email, password: txtPassword) { authResult, error in
                    if let error = error {
                        print("Error signing in: \(error.localizedDescription)")
                        self.loginFailed = true
                    } else {
                        print("User logged in successfully")
                        self.loginFailed = false
                        self.appVariables.isLoggedIn = true
                        self.shouldNavigateToHome = true
                    }
                }
            } else {
                print("No such user found")
                self.loginFailed = true
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(isLoggedIn: .constant(false))
            .environmentObject(AppVariables())
    }
}
