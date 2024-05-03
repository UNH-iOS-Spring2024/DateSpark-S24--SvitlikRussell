//  DirectionsView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismissAction()
                    }
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
            return "arrow.right"  // Default case
        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView(directions: ["Turn right onto Main St.", "Continue straight for a quarter mile.", "Turn left onto Oak St."]) {
            print("Dismiss direction.")
        }
    }
}
