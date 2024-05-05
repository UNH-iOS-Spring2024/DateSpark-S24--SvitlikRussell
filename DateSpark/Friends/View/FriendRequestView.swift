//  FriendRequestView.swift

import SwiftUI

struct FriendRequestView: View {
    @ObservedObject var viewModel: FriendsViewModel
    var request: FriendRequest
    let titleFont = Font.largeTitle.lowercaseSmallCaps()
    @State private var accepted = false
    @State private var rejected = false
 
    var body: some View {
        
        HStack  {
            Text("\(request.from)")
                .lineLimit(2)
                .font(titleFont)
                .bold()
                .foregroundColor(CustomColors.beige)
            
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }
        
        
        
        HStack {
             
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
                
            
               // .padding()
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
