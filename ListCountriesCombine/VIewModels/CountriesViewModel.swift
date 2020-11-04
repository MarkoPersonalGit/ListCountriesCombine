import Foundation
import Combine

class CountriesViewModel: ObservableObject {

//  If this is nil, then countries() API call is in progress
    @Published var countries: [Country]?
//    Needs to be nil when API call is in progress
    @Published var error: Error?

    @Published var isPullRefreshing = false
    
    private var cancellationToken: AnyCancellable?

    init() {
        getCountries()
    }

    func retryGetCountries() {
        error = nil
        getCountries()
    }

    func getCountries() {
        cancellationToken = CountryDB.countries()
            .mapError({ (error) -> Error in
                self.error = error
                self.isPullRefreshing = false
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    self.isPullRefreshing = false
                    self.countries = $0
            })
    }
}
