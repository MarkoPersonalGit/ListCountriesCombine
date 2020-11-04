import Foundation
import MapKit
import Combine

class ProvincesViewModel: ObservableObject {

//    If this is nil, then provinces(country.id) API call is in progress
    @Published var provinces: [Province]? = nil
//    Needs to be nil when API call is in progress
    @Published var error: Error?
    @Published var title: String
//    Name of place that was not found on map
    @Published var unfindableRegionName: String? = nil
//    Region that can be used by MapView
    @Published var region: MKCoordinateRegion?
//    countryRegion to fall back to when province can't be found on map
    private var countryRegion: MKCoordinateRegion?

    private var country: Country
    private var cancellationToken: AnyCancellable?

    init(_ country: Country) {
        self.country = country
        self.title = country.name
    }

    func onViewAppeared() {
        getProvinces()
        setRegion()
    }

//    Sets the region used by MapView, if province = nil, sets country as region.
    func setRegion(_ province: String? = nil) {
//        Sets a searchQuery for apple maps either in format "province, country" or if there is no province, "country"
        let query = province == nil ? country.name : "\(province!), \(country.name)"

        MapView.getRegion(query, completion: { [weak self] region in
//            Handle region not found
            guard let region = region else {
                self?.unfindableRegionName = query
//                Fall back to country region if exists.
                self?.region = self?.countryRegion ?? nil
//                Fall back to country name.
                self?.title = self?.country.name ?? ""
                return
            }
//            Handle region found
            self?.unfindableRegionName = nil
            self?.title = query
            self?.region = region
//            set countryRegion when province was nil, meaning setRegion was called for a country.
            if province == nil {
            self?.countryRegion = self?.region
            }
        })
    }

    func retryGetProvinces() {
        error = nil
        getProvinces()
    }

    private func getProvinces() {
        cancellationToken = CountryDB.provinces(country.id)
            .mapError({ [weak self] (error) -> Error in
                self?.error = error
                return error
            })
            .sink(receiveCompletion: {  _ in },
                  receiveValue: { [weak self] value in
                    self?.provinces = value
            })
    }

}
