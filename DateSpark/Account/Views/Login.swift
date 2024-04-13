//Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseAuth

struct Login: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appVariables: AppVariables

    @State var txtEmail: String = ""
    @State var txtPassword: String = ""
    @State private var shouldNavigateToHome: Bool = false
    @State private var loginFailed: Bool = false
    @State private var errorMessage: String? = nil
    @Binding var isLoggedIn: Bool
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
    
        NavigationStack {
            VStack {
                HStack{
                    Image("Logo")
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
                
                    .alert(isPresented: self.$showingAlert) {
                        Alert (
                            title: Text (alertTitle),
                            message: Text(alertMessage),
                        
                            dismissButton: .cancel(Text("Close"), action : {
                                
                            }))
                    }
                
                Button(action: loginUser) {
                    Text("Login")
                        .font(.system(size: 20))
                }
                
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
                self.alertTitle = "Error"
                self.alertMessage = "Failed to login: \(error.localizedDescription)"
                self.showingAlert = true
            } else {
                print("User logged in successfully")
                self.loginFailed = false
                self.appVariables.isLoggedIn = true
                self.shouldNavigateToHome = true
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
