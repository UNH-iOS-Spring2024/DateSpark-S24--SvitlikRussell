//

import Foundation
import FirebaseFirestore

struct ArchivedItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var outfit: String
    var weather: String
    var time: Date
    var rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case title, outfit, weather, time, rating
    }
}
