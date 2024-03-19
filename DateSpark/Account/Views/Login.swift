//Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseAuth

struct Login: View {
    @State var txtEmail: String = ""
    @State var txtPassword: String = ""
    @State private var shouldNavigateToHome: Bool = false
    @State private var loginFailed: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome Back to")
                Text("Date Spark")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom,10)
                Text("Sign In to Your Account")
                    .font(.system(size: 20))
                    .padding(.bottom, 20)
                
                TextField("Email", text: $txtEmail)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $txtPassword) //SecureField hides the text
                    .padding()
                
                if loginFailed {
                    Text("Failed to login. Please check your credentials.")
                        .foregroundColor(.red)
                }
                
                Button(action: loginUser) {
                    Text("Login")
                        .font(.system(size: 20))
                }
                
                // Navigate to SignUp_View
                NavigationLink(destination: SignUp(), label: {
                    Text("Don't have an account? Sign Up")
                })
                .padding()
                
                NavigationLink(destination: HomeView(), isActive: $shouldNavigateToHome) { EmptyView() }

            }
            .multilineTextAlignment(.center)
            .padding()
            
        }
    }
    
    func loginUser() {//NOT REALLY FUNCTIONAL RN
        Auth.auth().signIn(withEmail: txtEmail, password: txtPassword) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.loginFailed = true
            } else {
                // Navigate into Homepage
                print("User logged in successfully")
                self.loginFailed = false
                self.shouldNavigateToHome = true
                
            }
        }
    }
}



#Preview {
    Login()
}
