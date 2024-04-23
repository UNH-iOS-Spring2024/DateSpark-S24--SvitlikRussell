//
//  ArchivedDatesModel.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.
//

import Firebase
import Foundation



class ArchivedViewModel: ObservableObject {
    @Published var archivedItems = [ArchivedItem]()
    private var db = Firestore.firestore()
    private var userId: String

    init(userId: String) {
        self.userId = userId
        loadData()
    }

    func loadData() {
        db.collection("User").document(userId).collection("Archive").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            
            self.archivedItems = documents.map { docSnapshot -> ArchivedItem in
                let data = docSnapshot.data()
                let id = docSnapshot.documentID
                let title = data["Title"] as? String ?? ""
                let outfit = data["Outfit"] as? String ?? ""
                let weather = data["Weather"] as? String ?? ""
                let timestamp: Timestamp = data["Time"] as? Timestamp ?? Timestamp(date: Date())
                let time = timestamp.dateValue()
                let rating = data["Rating"] as? Int ?? 0
                return ArchivedItem(id: id, title: title, outfit: outfit, weather: weather, time: time, rating: rating)
            }
        }
    }

    func updateRating(forItemId itemId: String, newRating: Int) {
        let document = db.collection("User").document(userId).collection("Archive").document(itemId)
        document.updateData(["rating": newRating]) { error in
            if let error = error {}
            else { self.loadData() }
        }
    }
}

