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
                HStack{
                    Image("Logo") // Change when I upload logo with no background
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 50)
                    Spacer()
                }
                .padding()
                
                Text("Sign In")
                    .font(.system(size: 30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                Text("Welcome Back")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom,10)
                
                
                TextField("Email", text: $txtEmail)
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
    
    func loginUser() {
        Auth.auth().signIn(withEmail: txtEmail, password: txtPassword) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.loginFailed = true
            } else {
                print("User logged in successfully")
                self.loginFailed = false
                self.shouldNavigateToHome = true
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
