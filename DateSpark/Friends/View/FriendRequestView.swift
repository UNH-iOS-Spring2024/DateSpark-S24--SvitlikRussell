//  FriendRequestView.swift

import SwiftUI

struct FriendRequestView: View {
    @ObservedObject var viewModel: FriendsViewModel
    var request: FriendRequest

    var body: some View {
        HStack {
            Text("\(request.from) added you as a friend")
                .font(.headline)

            HStack {
                Button("Accept") {
                    viewModel.respondToRequest(request, accept: true)
                }
                .buttonStyle(.borderedProminent)
                .disabled(request.status != .pending)
                
                Button("Reject") {
                    viewModel.respondToRequest(request, accept: false)
                }
                .buttonStyle(.bordered)
                .disabled(request.status != .pending)

            }
        }
        .padding()
        .frame(width: 300, height: 100)
    }
}

struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        let mockRequest = FriendRequest(id: "1", from: "Alice", to: "Bob", status: .pending)
        FriendRequestView(viewModel: viewModel, request: mockRequest)
    }
}
