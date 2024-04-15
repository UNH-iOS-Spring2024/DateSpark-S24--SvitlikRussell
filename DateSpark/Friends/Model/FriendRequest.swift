//  FriendRequest.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import Foundation
import FirebaseFirestore

struct FriendRequest: Identifiable {
    var id: String
    var senderUsername: String
    var receiverUsername: String
    var status: String
}
