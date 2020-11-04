import Foundation
import Combine


struct CountryDB {

    static private let apiClient = APIClient()
    static private let baseUrl = URL(string: "https://connect.mindbodyonline.com/rest/worldregions/country")!

    static private func request<T>(_ path: String? = nil) -> AnyPublisher<T, Error> where T: Decodable {
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(path ?? ""), resolvingAgainstBaseURL: true)
        else { fatalError("Couldn't create URLComponents") }

        let request = URLRequest(url: components.url!)

        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

//Data access
extension CountryDB {
    static func countries() -> AnyPublisher<[Country], Error> {
        return request()
    }

    static func provinces(_ id: Int)  -> AnyPublisher<[Province], Error> {
        return request("/\(id)/province")
    }
}
