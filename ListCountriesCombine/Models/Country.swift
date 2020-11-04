import Foundation

struct Country: Codable, Identifiable {
    var id : Int
    var name: String
    var code: String
    var flag: URL? {
        URL(string: "https://www.countryflags.io")?.appendingPathComponent("/\(code)//flat/64.png")
    }

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case code = "Code"
    }
}
