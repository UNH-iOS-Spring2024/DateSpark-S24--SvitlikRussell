//  FriendsList.swift

import SwiftUI

struct FriendsList: View {
    @ObservedObject var viewModel: FriendsViewModel
    @State private var showingSendFriendRequest = false
    @State private var showingFriendRequests = false
    let titleFont = Font.largeTitle.lowercaseSmallCaps()
    
    var sortedFriends: [String] {
        return viewModel.friends.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }
    
    var body: some View {
        NavigationView {
            List(sortedFriends, id: \.self) { friend in
                Text("⭐️ \(friend)")
            }
            .alert("New Friend Request", isPresented: $viewModel.newFriendRequestReceived) {
                Button("View Requests") {
                    showingFriendRequests = true
                }
                Button("Dismiss") {
                    viewModel.newFriendRequestReceived = false
                }
            } message: {
                Text("You have a new friend request.")
            }
            .navigationBarTitleDisplayMode(.inline) // Use inline display mode
            .toolbar {
                ToolbarItem(placement: .principal) { // Use a custom view for the title
                    Text("Friends List")
                        .font(titleFont)
                        .bold()
                        .padding(.top, 100)
                        .foregroundColor(CustomColors.beige)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingFriendRequests = true
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(CustomColors.lightPink)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSendFriendRequest = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(CustomColors.lightPink)
                    }
                }
            }
            .padding(.top, 80)

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
