//
//  DateClass.swift
//  DateSpark
//
//  Created by Sarah Svitlik on 3/19/24.
//

import Foundation
import FirebaseFirestore
import WeatherKit
import CoreLocation

class DateClass: ObservableObject{
    
    let weatherService = WeatherService()

    let syracuse = CLLocation(latitude: 43, longitude: -76)

    /* let weather = try! await weatherService.weather(for: syracuse)

    let temperature = weather.currentWeather.temperature

    let uvIndex = weather.currentWeather.uvIndex */
    
    var id: String
    
    @Published var title: String
    @Published var description: String
    @Published var outfit: String
    @Published var time: String
    @Published var weather: String
    @Published var portion: Double
    @Published var rating: String
    @Published var index: Int

    required init?(id: String, data: [String: Any], title: String, index: Int) {
              let title = data["title"] as? String != nil ? data["title"] as! String : ""
              let description = data["description"] as? String != nil ? data["description"] as! String : ""
              let outfit = data["outfit"] as? String != nil ? data["outfit"] as! String : ""
              let time = data["time"] as? String != nil ? data["time"] as! String : ""
              let weather = data["weather"] as? String != nil ? data["weather"] as! String : ""
              let portion = data["portion"] as? Double != nil ? data["portion"] as! Double : 50
              let rating = data["rating"] as? String != nil ? data["rating"] as! String : ""


        self.id = id
        self.title = title
        self.description = description
        self.outfit = outfit
        self.time = time
        self.weather = weather
        self.portion = portion
        self.rating = rating
        self.index = index  
    }
}
