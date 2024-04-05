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

    init() { loadData() }

    func loadData() {
        db.collection("Archive").addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    self.archivedItems = documents.map { docSnapshot -> ArchivedItem in
                        let data = docSnapshot.data()
                        let id = docSnapshot.documentID
                        let outfit = data["Outfit"] as? String ?? ""
                        let weather = data["Weather"] as? String ?? ""
                        let timestamp: Timestamp = data["Time"] as? Timestamp ?? Timestamp(date: Date())
                        let time = timestamp.dateValue()
                        return ArchivedItem(id: id, outfit: outfit, weather: weather, time: time)
                    }
                }
            
    }

    func updateRating(forItemId itemId: String, newRating: Int) {
            let document = db.collection("Archive").document(itemId)
            document.updateData(["rating": newRating]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated with rating \(newRating)")
                    self.loadData() // Optionally reload data to reflect changes
                }
            }
        }
}

