//  Pin.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import Foundation
import MapKit

struct Pin: Identifiable {
    let id: UUID
    var location: CLLocationCoordinate2D
    var name: String

    init(location: CLLocationCoordinate2D, name: String = "Location") {
        self.id = UUID()
        self.location = location
        self.name = name
    }
}
