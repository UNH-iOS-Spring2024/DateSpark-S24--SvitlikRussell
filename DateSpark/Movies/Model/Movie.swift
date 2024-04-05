//
//  Date.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/5/24.
//

import Foundation

class Movie: ObservableObject {
    
    let id: String
    @Published var title: String = ""
    @Published var description : String = ""
    @Published var outfit: String = ""
    @Published var weather: String = ""
    
    required init? (id: String, data: [String : Any]) {
        let title = data["title"] as? String != nil ? data["title"] as! String : ""
        let description = data["description"] as? String != nil ? data["description"] as! String : ""
        let outfit = data["outfit"] as? String != nil ? data["outfit"] as! String : ""
        let weather = data["weather"] as? String != nil ? data["weather"] as! String : ""
        
        self.id = id
        self.title = title
        self.outfit = outfit
        self.weather = weather
    }
}
