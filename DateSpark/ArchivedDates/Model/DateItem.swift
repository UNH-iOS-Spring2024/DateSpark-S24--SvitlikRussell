//DateSpark-S24-Svitlik-Russell

import Foundation

struct DateItem: Identifiable {
    let id = UUID()
    var date: Date
}

class ArchiveViewModel: ObservableObject {
    @Published var archivedItems: [DateItem] = []
    
    func add(item: DateItem) {
        archivedItems.append(item)
    }
}
