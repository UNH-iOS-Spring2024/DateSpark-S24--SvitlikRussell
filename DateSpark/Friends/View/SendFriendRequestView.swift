//  SendFriendRequestView.swift

import SwiftUI

struct SendFriendRequestView: View {
    @ObservedObject var viewModel: FriendsViewModel
    @State private var username = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter friend's username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Send Friend Request") {
                viewModel.sendFriendRequest(to: username) { message in
                    alertMessage = message
                    showAlert = true
                }
            }
            .disabled(username.isEmpty)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Friend Request"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}


struct SendFriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        SendFriendRequestView(viewModel: viewModel)
    }
}
