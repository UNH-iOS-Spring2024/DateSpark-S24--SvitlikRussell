//DateSpark-S24-Svitlik-Russell

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack{
            Text("Profile")
                .padding(25)
            
            Image("PlaceholderImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 4))
                .shadow(radius: 10)
            
            Spacer()
            
            HStack{
                Text("First Name: ") //Pull from firebase Current placeholder
                Text("Last Name") //Pull from firebase Current placeholder
            }
            HStack{
                Text("Email: ")
                Text ("XYZ") //Pull from firebase Current placeholder
            }
            HStack{
                Text("User ID: ")
                Text ("XYZ") //Pull from firebase Current placeholder
            }
//            Text("Themes")
            
            Spacer()
            
            HStack{
                Spacer()
                Text("Joined: ")
                Text ("XYZ")
                    .underline() //Pull from firebase Current placeholder
                
                Spacer()
                Button(action: {
                    Login()
                }) {
                    Text("Sign Out")
                        .padding()
                        .border(Color.blue, width: 2)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ProfileView()
}
