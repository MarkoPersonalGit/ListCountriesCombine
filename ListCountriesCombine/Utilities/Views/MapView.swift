import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    private var region: MKCoordinateRegion?

    init(_ region: MKCoordinateRegion? = nil) {
        self.region = region
    }
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if self.region != nil {
            uiView.setRegion(region!, animated:true)
        }
    }

    static func getRegion(_ query: String, completion : @escaping (MKCoordinateRegion?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: coordinate, span: span)
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            if error == nil {
                completion(response!.boundingRegion)
            } else {
                completion(nil)
            }
        })
    }
}



