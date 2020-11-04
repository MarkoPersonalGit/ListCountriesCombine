import SwiftUI

struct ProvincesView: View {

    @ObservedObject var viewModel : ProvincesViewModel

    var body: some View {
        VStack {
            if viewModel.error != nil {
                error
            }
        else if viewModel.provinces == nil {
            Spinner(isAnimating: true, style: .medium)
        } else {
            map
            list
        }
        }
        //NavigationView inits views in it that are visible or close to being visible.
        //By calling viewModel.onViewAppeared() here instead of init, I avoid excessive queries to API and Apple Maps POI searches.
        .onAppear(){
            viewModel.onViewAppeared()
        }
    }

    private var error: some View {
        VStack {
            Text("Error:").font(.title)
            Text(viewModel.error!.localizedDescription)
            Button(action: {
                viewModel.retryGetProvinces()
            }) {
                Text("Retry")
            }
        }
    }

    private var list: some View {
        VStack {
        List(viewModel.provinces!) { province in
            Button(action: {
                viewModel.setRegion(province.name)
            }) {
                Text(province.name)
            }
            }
             if viewModel.provinces!.count == 0 {
                Text("No provinces available").font(.title)
             }
        }.navigationBarTitle(viewModel.title, displayMode: .inline)
    }

    private var map: some View {
        VStack {
        MapView(viewModel.region)
        if viewModel.unfindableRegionName != nil {
            Text("Can't locate \(viewModel.unfindableRegionName!) on map").font(.title)
        }
        }
    }
}
