// DateItem.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import Foundation
import FirebaseFirestore

struct DateItem: /*Identifiable,*/ Codable {
//    let id = UUID()
    var title: String
    var date: Date
    var rating: String
    var outfit: String
    var weather: String
    var time: Timestamp
    
    var timeDate: Date{ return time.dateValue() }
}
