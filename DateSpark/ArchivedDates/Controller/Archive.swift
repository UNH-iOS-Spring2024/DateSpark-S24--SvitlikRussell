//  Archive.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import Foundation
import FirebaseFirestore

class Archive: Identifiable, ObservableObject {
    var id: String 
    @Published var title: String
    @Published var description: String
    @Published var outfit: String
    @Published var weather: String
    @Published var time: Date

    init(id: String, title: String, description: String, outfit: String, weather: String, time: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.outfit = outfit
        self.weather = weather
        self.time = time
    }
}
