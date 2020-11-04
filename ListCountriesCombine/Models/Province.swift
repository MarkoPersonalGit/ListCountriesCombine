import Foundation

struct Province: Codable, Identifiable {
    var id : Int
    var name: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
    }
}
