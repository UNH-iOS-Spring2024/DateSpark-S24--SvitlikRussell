//  FriendRequestView.swift

import SwiftUI

struct FriendRequestView: View {
    @ObservedObject var viewModel: FriendsViewModel
    var request: FriendRequest
    let titleFont = Font.largeTitle.lowercaseSmallCaps()
    @State private var accepted = false
    @State private var rejected = false

    var body: some View {
        VStack  {
                    
                    VStack{
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    }
                    
                    Text("Requests")
                        .lineLimit(2)
                        .font(titleFont)
                        .bold()
                        .foregroundColor(CustomColors.beige)
                    
                    HStack {
                        Text("\(request.from)")
                            .font(.headline)
                            
                        Button(action: {
                            viewModel.respondToRequest(request, accept: true)
                            accepted = true
                        }) {
                            Text(accepted ? "Accepted" : "Accept")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(accepted ? Color.gray : CustomColors.lightPink)
                        .disabled(request.status != .pending || accepted || rejected)
                        
                        Button(action: {
                            viewModel.respondToRequest(request, accept: false)
                            rejected = true
                        }) {
                            Text(rejected ? "Rejected" : "Reject")
                        }
                        .buttonStyle(.bordered)
                        .tint(rejected ? Color.gray : CustomColors.darkRed)
                        .disabled(request.status != .pending || accepted || rejected)
                        
                    }
                    .padding()
                }
            }
        }


struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        let mockRequest = FriendRequest(id: "1", from: "Alice", to: "Bob", status: .pending)
        FriendRequestView(viewModel: viewModel, request: mockRequest)
    }
}
