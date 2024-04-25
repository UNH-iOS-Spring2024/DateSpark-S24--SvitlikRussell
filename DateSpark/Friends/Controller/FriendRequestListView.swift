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
        FriendRequestListView(viewModel: viewModel)
    }
}
