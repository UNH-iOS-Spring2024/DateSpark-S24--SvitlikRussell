//  FriendRequestView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FriendRequestView: View {
//    let db = Firestore.firestore()
    @ObservedObject var viewModel = FriendRequestsViewModel()
    
    init(viewModel: FriendRequestsViewModel = FriendRequestsViewModel()){
        self.viewModel = viewModel
    }
        
    var body: some View {
        List {
            ForEach(viewModel.friendRequests.filter { $0.status == "pending" }) { request in
                HStack {
                    Text(request.senderUsername)
                    Spacer()
                    Button("Confirm") {
                        confirmRequest(request)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.trailing)
                    
                    Button("Deny") {
                        denyRequest(request)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .navigationTitle("Friend Requests")
        .onAppear(perform: viewModel.fetchPendingFriendRequests)
    }
    
    private func confirmRequest(_ request: FriendRequest) {
        viewModel.updateFriendRequest(id: request.id, newStatus: "confirmed") {
            // Optionally add feedback to user here, e.g., using an alert
        }
    }
    
    private func denyRequest(_ request: FriendRequest) {
        viewModel.updateFriendRequest(id: request.id, newStatus: "denied") {
            // Optionally add feedback to user here, e.g., using an alert
        }
    }
}

struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestView()
    }
}
