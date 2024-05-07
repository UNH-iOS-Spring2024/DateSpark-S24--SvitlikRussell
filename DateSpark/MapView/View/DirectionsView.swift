import SwiftUI

struct DirectionsView: View {
    var directions: [String]
    var dismissAction: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(directions, id: \.self) { direction in
                        Card(
                            width: 400, // Adjust width to fit within screen bounds
                            height: 60, // Height of each card
                            color: Color.white,
                            elevation: 5,
                            views: {
                                AnyView(
                                    HStack {
                                        Image(systemName: symbolForDirection(direction))
                                            .foregroundColor(.pink)
                                        Text(direction)
                                        Spacer()
                                    }
                                        .padding(.all , 10) // Padding inside the card for content
                                )
                            },
                            click: {
                                // Optional: Define actions when a card is tapped, if necessary
                            }
                        )
                        .padding(.horizontal, 60)
                        .padding(.bottom, 5)
                    }
                }
            }
            .navigationBarTitle("Directions", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button("End Route") {
                        dismissAction()
                    }
                    .frame(width: 120, height: 50)
                    .background(CustomColors.darkRed)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                    Spacer()
                }
            }
        }
    }
    
    func symbolForDirection(_ direction: String) -> String {
        if direction.lowercased().contains("turn left") { //Turning
            return "arrow.turn.up.left"
        } else if direction.lowercased().contains("turn right") { //Turning
            return "arrow.turn.up.right"
        }else if direction.lowercased().contains("keep right") { //Staying to side
            return "road.lanes.curved.right"
        } else if direction.lowercased().contains("keep left") { //Staying to side
            return "road.lanes.curved.left"
        }else if direction.lowercased().contains("straight") ||  direction.lowercased().contains("continue") { // Straight path
            return "road.lanes"
        }  else if direction.lowercased().contains("arrive") || direction.lowercased().contains("destination") { //Destination
            return "mappin.and.ellipse"
        } else if direction.lowercased().contains("highway") || direction.lowercased().contains("merge")  { //Highways
               return "arrow.triangle.merge"
        }  else if direction.lowercased().contains("take exit") || direction.lowercased().contains("exit")  { //Exiting Highways
            return "road.lanes.curved.right"
        }else {
            return ""  // Default case for unknown
        }
    }
    
    struct EndRouteButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .font(.title).bold()
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView(directions: ["Turn right onto Main St.", "Continue straight for a quarter mile.", "Turn left onto Oak St.", "Arrive at destination"]) {
            print("Dismiss direction.")
        }
    }
}
