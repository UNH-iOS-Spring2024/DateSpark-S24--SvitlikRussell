//  FriendsList.swift

import SwiftUI

struct FriendsList: View {
    @ObservedObject var viewModel: FriendsViewModel
    @State private var showingSendFriendRequest = false
    @State private var showingFriendRequests = false
    
    var body: some View {
        NavigationView {
            List(viewModel.friends, id: \.self) { friend in
                Text(friend)
            }
            .navigationTitle("Friends List")
            .navigationBarItems(
                leading: Button(action: {
                    showingFriendRequests = true
                }) {
                    Image(systemName: "bell")
                },
                trailing: Button(action: {
                    showingSendFriendRequest = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingSendFriendRequest) {
                SendFriendRequestView(viewModel: viewModel)
            }
            .popover(isPresented: $showingFriendRequests) {
                FriendRequestList(viewModel: viewModel)
            }
        }
    }
}

struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        FriendsList(viewModel: viewModel)
    }
}
