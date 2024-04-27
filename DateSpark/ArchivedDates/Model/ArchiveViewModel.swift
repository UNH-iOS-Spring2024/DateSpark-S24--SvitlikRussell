//  ArchiveViewModel.swift

import Foundation
import FirebaseFirestore
import Firebase

class ArchiveViewModel: ObservableObject {
    @Published var archives: [Archive] = []
    private var listenerRegistration: AuthStateDidChangeListenerHandle?

    private func fetchArchiveData(userID: String) {
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
                    title: data["Title"] as? String ?? "",
                    description: data["Description"] as? String ?? "",
                    outfit: data["Outfit"] as? String ?? "",
                    weather: data["Weather"] as? String ?? "", 
                    time: (data["Time"] as? Timestamp)?.dateValue() ?? Date()
                )
                fetchedArchives.append(archive)
            }
            DispatchQueue.main.async {
                self?.archives = fetchedArchives
            }
        }
    }
    
    func observeAuthChanges() {
        listenerRegistration = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let userID = user?.uid {
                self?.fetchArchiveData(userID: userID)
            } else {
                DispatchQueue.main.async {
                    self?.archives = []
                }
            }
        }
    }
    
}

