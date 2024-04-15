//  FriendRequestList.swift


import SwiftUI

struct FriendRequestListView: View {
    @ObservedObject var viewModel: FriendsViewModel
    
    var body: some View {
        List(viewModel.friendRequests) { request in
            FriendRequestView(viewModel: viewModel, request: request)
                .frame(width: 300, height: 100)
        }
    }
}

struct FriendRequestListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        viewModel.friendRequests = [
            FriendRequest(id: "1", from: "Alice", to: "User123", status: .pending),
            FriendRequest(id: "2", from: "Bob", to: "User123", status: .pending),
            FriendRequest(id: "3", from: "Carol", to: "User123", status: .pending)
        ]
        return FriendRequestListView(viewModel: viewModel)
    }
}
