//  FriendsListView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseFirestore

struct FriendsListView: View {
    @State private var showSendRequest = false
    @ObservedObject var viewModel = FriendsListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.friends, id: \.self) { friend in
                    Text(friend)
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                Button("Add Friend") {
                    showSendRequest = true
                }
            }
            .sheet(isPresented: $showSendRequest) {
                SendFriendRequestView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchFriends()
        }
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView()
    }
}
