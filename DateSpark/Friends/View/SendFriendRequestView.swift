//  SendFriendRequestView.swift
import SwiftUI

struct SendFriendRequestView: View {
    @ObservedObject var viewModel: FriendsViewModel
    @State private var username = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var searchResults: [String] = []
    let titleFont = Font.largeTitle.lowercaseSmallCaps()

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Find friends")
                .font(titleFont)
                .bold()
                .padding(.top, 100)
                .foregroundColor(CustomColors.beige)
            
            
            TextField("Enter friend's username", text: $username)
                .onChange(of: username){ newValue in
                    viewModel.searchUsers(query: newValue){ users in
                        self.searchResults = users
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(CustomColors.lightBeige)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding()
            
            List(searchResults, id: \.self) { user in
                HStack {
                    Text(user)
                    Spacer()
                    if viewModel.isFriend(user: user) {
                        Image(systemName: "person.2.fill")
                    } else if viewModel.hasSentRequest(user: user) {
                        Image(systemName: "hourglass")
                    } else {
                        Button(action: {
                            viewModel.sendFriendRequest(to: user) { message in
                                alertMessage = message
                                showAlert = true
                                if message.contains("sent") {
                                    username = user
                                }
                            }
                        }) {
                            Text("Request")
                                .bold()
                                .foregroundColor(CustomColors.lightPink)
                        }
                    }
                }
            }
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
