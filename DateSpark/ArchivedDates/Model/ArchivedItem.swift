//

import Foundation
import FirebaseFirestore

struct ArchivedItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var outfit: String
    var weather: String
    var time: Date
//    var rating: String?
    
    enum CodingKeys: String, CodingKey {
        case outfit, weather, time /*, rating*/
    }
}
