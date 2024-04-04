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
    @State var txtPrefName: String = ""
    @State var txtEmail: String = ""
    @State var txtPassword: String = ""
    @State private var shouldNavigateToHome = false
    @State private var errorMessage : String? = nil
 
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Date Spark")
                    .font(.system(size: 30))
                    .bold()
                
                Text("Create An Account")
                    .font(.system(size: 30))
                    .bold()
                
                TextField("First Name", text: $txtFirstName)
                TextField("Last Name", text: $txtLastName)
                TextField("Preferred Name", text: $txtPrefName)
                TextField("Email", text: $txtEmail)
                    .autocapitalization(.none)
                SecureField("Password", text: $txtPassword)

                if let errorMessage = errorMessage{
                    Text (errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    if txtPassword != "" {
                        userToFirebase()
                    }
                }) {
                    Text("Sign Up!")
                        .font(.system(size: 25))
                }
                .disabled(txtEmail.isEmpty || txtPassword.isEmpty)
                
                NavigationLink(destination: HomeView(), isActive: $shouldNavigateToHome) { EmptyView() }
                
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
        }
 
    }
    
    func resetTextFields(){
        txtFirstName = ""
        txtLastName = ""
        txtPrefName = ""
        txtEmail = ""
        txtPassword = ""
    }
    
    func userToFirebase(){
        Auth.auth().createUser(withEmail: txtEmail, password: txtPassword ) { authResult, error in
            if let error = error{
                self.errorMessage = "Error creating user: \(error.localizedDescription)"
                return
            }
            let uniqueNameIdentifier = "@\(txtLastName).\(txtPrefName)\(txtFirstName)"
            let userData = ["firstName" : txtFirstName,
                            "lastName" : txtLastName,
                            "prefName" : txtPrefName,
                            "email" : txtEmail,
                            "uniqueNameIdentifier" : uniqueNameIdentifier]
            if let userId = authResult?.user.uid{
                self.db.collection("User").document(userId).setData(userData){err in
                    if let err = err{
                    self.errorMessage = "Error adding user details: \(err.localizedDescription)"
                } else {
                    print("User details added with ID: \(userId)")
                    DispatchQueue.main.async{
                        self.resetTextFields()
                        self.appVariables.isLoggedIn = true
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
