//  SendFriendRequestView.swift

import SwiftUI

struct SendFriendRequestView: View {
    @ObservedObject var viewModel: FriendsViewModel
    @State private var username = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var searchResults: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter friend's username", text: $username)
                .onChange(of: username){ newValue in
                    viewModel.searchUsers(query: newValue){ users in
                        self.searchResults = users
                    }
                }                
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .padding()
            
            List(searchResults, id: \.self) { user in
                HStack {
                    Text(user)
                    Spacer()
                    if viewModel.isFriend(user: user) {
                        Image(systemName: "person.2")
                    } else if viewModel.hasSentRequest(user: user) {
                        Image(systemName: "ellipsis.circle")
                    } else {
                        Button(action: {
                            self.username = user
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            
            Button("Send Friend Request") {
                if viewModel.hasSentRequest(user: username) {
                    alertMessage = "A friend request to \(username) is already pending."
                    showAlert = true
                } else if viewModel.isFriend(user: username) {
                    alertMessage = "You are already friends with \(username)."
                    showAlert = true
                } else {
                    viewModel.sendFriendRequest(to: username) { message in
                        alertMessage = message
                        showAlert = true
                    }
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
