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
                Text(direction)
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
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView(directions: ["Turn right onto Main St.", "Your destination is on the left."]) {
            print("Dismiss direction.")
        }
    }
}

