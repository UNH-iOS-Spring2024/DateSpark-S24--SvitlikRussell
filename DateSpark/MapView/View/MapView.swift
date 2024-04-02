//
//  MapView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.
//

import SwiftUI
import MapKit

struct MapView: View {
@State var location = ""
    
    var body: some View {
        VStack {
            Form {
                Section (header: Text("Nearby Date locations")) {
                    ZStack (alignment: .trailing) {
                        TextField("Search", text: $location)
                    }
                }
            }
            .frame(height: 100)
            Map(initialPosition: .region(region))
        }
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion (
            center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

#Preview {
    MapView()
}
