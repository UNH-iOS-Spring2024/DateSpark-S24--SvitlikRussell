//Sarah Svitlik & Shannon Russell
import SwiftUI
import FirebaseFirestore

struct SignUp: View {
    @Environment(\.presentationMode) var presentationMode
    let db = Firestore.firestore()
    
    @State var txtFirstName: String = ""
    @State var txtLastName: String = ""
    @State var txtPrefName: String = ""
    @State var txtEmail: String = ""
    @State var txtPassword: String = ""
    @State private var shouldNavigateToHome = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Date Spark")
                    .font(.system(size: 40))
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

                Button(action: {
                    if txtPassword != "" {
                        userToFirebase()
                    }
                }) {
                    Text("Sign Up!")
                        .font(.system(size: 28))
                }
                NavigationLink(destination: HomeView(), isActive: $shouldNavigateToHome) { EmptyView() }
                
                NavigationLink(destination: Login()) {
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
        let data = ["firstName" : txtFirstName,
                    "lastName" : txtLastName,
                    "prefName" : txtPrefName,
                    "email" : txtEmail,
                    "password" : txtPassword ] as [String : Any]
        
        var ref: DocumentReference? = nil
        ref = db.collection("User").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                DispatchQueue.main.async {
                    self.shouldNavigateToHome = true // Trigger navigation to HomeView
                }
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
