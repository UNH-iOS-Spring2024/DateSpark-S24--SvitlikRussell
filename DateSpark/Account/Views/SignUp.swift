//Sarah Svitlik & Shannon Russell
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SignUp: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appVariables: AppVariables

    let db = Firestore.firestore()
    
    @State var txtFirstName: String = ""
    @State var txtLastName: String = ""
    @State var txtusername: String = ""
    @State var txtEmail: String = ""
    @State var txtPassword: String = ""
    @State private var shouldNavigateToHome = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    let titleFont = Font.largeTitle.lowercaseSmallCaps()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome!")
                    .font(titleFont)
                    .bold()
                
                Text("Create An Account")
                    .font(titleFont)
                    .bold()
                
                TextField("First Name", text: $txtFirstName)
                TextField("Last Name", text: $txtLastName)
                TextField("Username", text: $txtusername)
                    .autocapitalization(.none)
                TextField("Email", text: $txtEmail)
                    .autocapitalization(.none)
                SecureField("Password", text: $txtPassword)

                Button("Sign Up!"){
                    userToFirebase()
                }
                .disabled(txtEmail.isEmpty || txtPassword.isEmpty)
                
                if shouldNavigateToHome {                    NavigationLink(destination: HomeView(), isActive: $shouldNavigateToHome) { EmptyView() }
                }
                
                NavigationLink(destination: Login(isLoggedIn: .constant(false))) {
                    Text("Already have an account? Login")
                        .font(.system(size: 20))
                }
                .padding(30)
            }
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .autocorrectionDisabled(true)
            .padding()
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Sign Up Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func resetTextFields(){
        txtFirstName = ""
        txtLastName = ""
        txtusername = ""
        txtEmail = ""
        txtPassword = ""
    }
    
    func userToFirebase(){
        Auth.auth().createUser(withEmail: txtEmail, password: txtPassword ) { authResult, error in
            if let error = error {
                self.alertMessage = "Failed to create user: \(error.localizedDescription)"
                self.showAlert = true
                return
            }
            let userData = [
                "firstName" : txtFirstName,
                "lastName" : txtLastName,
                "username" : txtusername,
                "email" : txtEmail
                ]
            if let userId = authResult?.user.uid{
                self.db.collection("User").document(userId).setData(userData){err in
                    if let err = err{
                        self.alertMessage = "Error adding user details: \(err.localizedDescription)"
                        self.showAlert = true
                    } else {
                        print("User details added with ID: \(userId)")
                        DispatchQueue.main.async {
                            self.resetTextFields()
                            self.appVariables.isLoggedIn = true
                            self.shouldNavigateToHome = true
                        }
                    }
                }
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
            .environmentObject(AppVariables())
    }
}
