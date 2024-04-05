//  FriendRequest.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import Foundation
import FirebaseFirestore

struct FriendRequest: Identifiable {
    var id: String
    var uniqueIdentifier: String
    var status: String
}
