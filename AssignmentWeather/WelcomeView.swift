import SwiftUI

struct WelcomeView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var showHomeView = false

    var body: some View {
        VStack {
            // Displays welcome messages and a button to proceed to the next view
            Text("Welcome to WeatherApp")
                .font(.largeTitle)
                .padding()
            Text("Get the latest weather updates for your location.")
                .font(.subheadline)
                .padding()
            Button(action: {
                // Sets showHomeView to true when the button is pressed
                showHomeView = true
            }) {
                Text("Get Started")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }.onAppear {
            // Requests location permission when the view appears
            locationManager.requestLocationPermission()
        }
        .fullScreenCover(isPresented: $showHomeView) {
            // Presents HomeView as a full-screen cover when showHomeView is true
            HomeView(locationManager: locationManager)
        }
    }
}
