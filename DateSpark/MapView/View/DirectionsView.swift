import SwiftUI

struct DirectionsView: View {
    var directions: [String]
    var dismissAction: () -> Void

    var body: some View {
        NavigationView {
            List(directions, id: \.self) { direction in
                HStack {
                    Image(systemName: symbolForDirection(direction))
                        .foregroundColor(.blue)  // You can customize the color
                    Text(direction)
                }
            }
            .navigationBarTitle("Directions", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button("End Route") {
                        dismissAction()
                    }
                    .buttonStyle(EndRouteButtonStyle())
                    Spacer()
                }
            }
        }
    }
    
    func symbolForDirection(_ direction: String) -> String {
        if direction.lowercased().contains("left") {
            return "arrow.turn.up.left"
        } else if direction.lowercased().contains("straight") {
            return "arrow.up"
        } else if direction.lowercased().contains("right") {
            return "arrow.turn.up.right"
        } else {
            return "mappin.and.ellipset"  // Default case for Arrival
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
