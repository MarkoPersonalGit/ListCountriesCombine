import SwiftUI
import SwiftUIRefresh //Pull To Refresh
import struct Kingfisher.KFImage //Async image loading

struct CountriesView: View {
    @ObservedObject private var viewModel = CountriesViewModel()

    var body: some View {
        if viewModel.error != nil {
            error
        }
        else if viewModel.countries == nil {
            Spinner(isAnimating: true, style: .medium)
        } else {
            list
        }
    }

    private var error: some View {
        VStack {
            Text("Error:").font(.title)
            Text(viewModel.error!.localizedDescription)
            Button(action: {
                viewModel.retryGetCountries()
            }) {
                Text("Retry")
            }
        }
    }

    private var list: some View {
        NavigationView {
            List(viewModel.countries!) { country in
                ZStack {
                    buildNavigationLink(of: country)
                    buildFlag(of: country)
                }

            }
            .navigationBarTitle("Countries")
            .pullToRefresh(isShowing: $viewModel.isPullRefreshing) {
                viewModel.retryGetCountries()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func buildNavigationLink(of country: Country) -> some View {
        HStack {
            NavigationLink(
                destination: ProvincesView(viewModel: ProvincesViewModel(country)), label: {
                    Spacer()
                    Text(country.name)
                })
        }
    }

    private func buildFlag(of country : Country) -> some View {
        return HStack {
            country.flag.map { url in
                KFImage(url)
            }
            .frame(idealHeight: 64)
            Spacer()
        }
    }
}
