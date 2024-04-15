//  FriendRequestView.swift

import SwiftUI

struct FriendRequestView: View {
    @ObservedObject var viewModel: FriendsViewModel
    var request: FriendRequest
    
    var body: some View {
        VStack {
            Text("Friend Request from \(request.from)")
                .font(.headline)
            
            HStack {
                Button("Accept") {
                    viewModel.respondToRequest(request, accept: true)
                }
                .buttonStyle(.borderedProminent)

                Button("Reject") {
                    viewModel.respondToRequest(request, accept: false)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}


struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        let mockRequest = FriendRequest(id: "1", from: "Alice", to: "Bob", status: .pending)
        FriendRequestView(viewModel: viewModel, request: mockRequest)
    }
}
