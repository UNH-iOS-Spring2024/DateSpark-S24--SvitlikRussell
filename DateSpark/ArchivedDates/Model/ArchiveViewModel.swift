//  ArchiveViewModel.swift

import Foundation
import FirebaseFirestore
import Firebase

class ArchiveViewModel: ObservableObject {
    @Published var archives: [Archive] = []

    func fetchArchiveData(userID: String) {
        let db = Firestore.firestore()

        db.collection("User").document(userID).collection("Archive").getDocuments { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            var fetchedArchives = [Archive]()
            for document in querySnapshot!.documents {
                let data = document.data()
                let archive = Archive(
                    id: document.documentID,
                    title: data["title"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    outfit: data["outfit"] as? String ?? "",
                    weather: data["weather"] as? String ?? "",
                    time: (data["time"] as? Timestamp)?.dateValue() ?? Date()
                )
                fetchedArchives.append(archive)
            }
            DispatchQueue.main.async {
                self?.archives = fetchedArchives
            }
        }
    }
}
