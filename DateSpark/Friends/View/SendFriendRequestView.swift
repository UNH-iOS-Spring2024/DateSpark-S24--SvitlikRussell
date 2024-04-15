//  SendFriendRequestView.swift

import SwiftUI

struct SendFriendRequestView: View {
    @ObservedObject var viewModel: FriendsViewModel
    @State private var username = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter friend's username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Send Friend Request") {
                viewModel.sendFriendRequest(to: username)
            }
            .disabled(username.isEmpty)
        }
        .padding()
    }
}


struct SendFriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        SendFriendRequestView(viewModel: viewModel)
    }
}
