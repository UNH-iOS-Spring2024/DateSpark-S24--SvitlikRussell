//  FriendRequestList.swift


import SwiftUI

struct FriendRequestListView: View {
    @ObservedObject var viewModel: FriendsViewModel

    var body: some View {
        if viewModel.friendRequests.isEmpty {
            Text("No friend requests")
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            ForEach(viewModel.friendRequests) { request in
                FriendRequestView(viewModel: viewModel, request: request)
            }
        }
    }
}


struct FriendRequestListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        FriendRequestListView(viewModel: viewModel)
    }
}
