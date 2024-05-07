// SignUp.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

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
    let headingFont = Font.title.lowercaseSmallCaps()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
//                    Spacer()
                    VStack (spacing: 5) {
                        Text("✨Welcome!✨")
                            .font(titleFont)
                            .bold()
                            .foregroundColor(CustomColors.beige)
                        
                        Text("Create An Account")
                            .font(headingFont)
                            .bold()
                            .foregroundColor(CustomColors.beige)
                    }
                    Spacer()
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 100)
                }
                .padding()
                
                TextField("First Name", text: $txtFirstName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                TextField("Last Name", text: $txtLastName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                TextField("Username", text: $txtusername)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .autocapitalization(.none)
                TextField("Email", text: $txtEmail)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .autocapitalization(.none)
                SecureField("Password", text: $txtPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)

                Button("Sign Up!"){
                    checkUsername()
                }
                .disabled(txtEmail.isEmpty || txtPassword.isEmpty || txtusername.isEmpty)
                
                if shouldNavigateToHome {
                    NavigationLink(destination: HomeView(), isActive: $shouldNavigateToHome) { EmptyView() }
                }
                Spacer()
                NavigationLink(destination: Login(isLoggedIn: .constant(false))) {
                    Text("Already have an account? Login")
                        .font(.system(size: 20))
                        .foregroundColor(CustomColors.darkRed)

                }
                .padding(30)
            }
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .autocorrectionDisabled(true)
            .padding()
            .background(CustomColors.lightPink.opacity(0.2))
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
    
    func checkUsername() {
        db.collection("User").whereField("username", isEqualTo: txtusername).getDocuments { (snapshot, error) in
            if let error = error {
                self.alertMessage = "Error checking username: \(error.localizedDescription)"
                self.showAlert = true
            } else if snapshot?.isEmpty ?? true {
                userToFirebase()
            } else {
                self.alertMessage = "Username already taken, please use a different username."
                self.showAlert = true
            }
        }
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
