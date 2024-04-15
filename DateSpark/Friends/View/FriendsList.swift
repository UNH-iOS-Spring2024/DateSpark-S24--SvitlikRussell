//  FriendsList.swift

import SwiftUI

struct FriendsList: View {
    @ObservedObject var viewModel: FriendsViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.friends, id: \.self) { friend in
                Text(friend)
            }
            .navigationTitle("Friends List")
            .onAppear {
                viewModel.fetchFriends()
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
