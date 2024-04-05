//  FriendRequestView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FriendRequestView: View {
    let db = Firestore.firestore()
    @ObservedObject var viewModel = FriendRequestsViewModel()
        
    var body: some View {
        List(viewModel.friendRequests) { request in
            HStack {
                Text(request.uniqueIdentifier)
                Spacer()
                Button("Confirm") {
                    viewModel.updateFriendRequest(requestId: request.id, status: "confirmed")
                }
                Button("Deny") {
                    viewModel.updateFriendRequest(requestId: request.id, status: "denied")
                }
            }
        }
        .onAppear(perform: viewModel.fetchFriendRequests)
    }
}

struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestView()
    }
}
