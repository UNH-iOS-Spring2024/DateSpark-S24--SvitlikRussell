//  FriendsList.swift

import SwiftUI

struct FriendsList: View {
    @ObservedObject var viewModel: FriendsViewModel
    @State private var showingSendFriendRequest = false
    @State private var showingFriendRequests = false
    let titleFont = Font.largeTitle.lowercaseSmallCaps()

    var body: some View {
        NavigationView {
            List(viewModel.friends, id: \.self) { friend in
                Text(friend)
            }
            .navigationTitle("Friends List")
                //.font(titleFont)

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
                FriendRequestListView(viewModel: viewModel)
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
