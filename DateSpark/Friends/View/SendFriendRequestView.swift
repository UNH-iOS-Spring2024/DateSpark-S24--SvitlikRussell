//  SendFriendRequestView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI

struct SendFriendRequestView: View {
    @Environment(\.dismiss) var dismiss
    @State private var username: String = ""
    @ObservedObject var viewModel: FriendsListViewModel

    var body: some View {
        NavigationView {
            Form {
                TextField("Enter username", text: $username)
                Button("Send Request") {
                    viewModel.sendFriendRequest(to: username) { success, message in
                        if success {
                            dismiss()
                        } else {
                            // Show alert or message to the user
                            print(message)
                        }
                    }
                }
            }
            .navigationTitle("Send Friend Request")
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

struct SendFriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        SendFriendRequestView()
    }
}
