import SwiftUI

struct HomeView: View {
    private let locationManager: LocationManager
    @StateObject private var homeViewModel: HomeViewModel

    // Initializer to create HomeViewModel with the provided locationManager

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(locationManager: locationManager))
    }

    var body: some View {
        NavigationView {
            // Displays the current weather view and hides the navigation bar
            CurrentWeatherView()
                .environmentObject(homeViewModel)
                .navigationBarHidden(true)
        }
    }
}
