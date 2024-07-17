import SwiftUI

struct ForecastWeatherView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        VStack {
            // Displays a loading message while the forecast is being fetched
            if homeViewModel.threeDayForecast.isEmpty {
                Text("Loading forecast...")
                    .onAppear {
                        if let coordinate = homeViewModel.locationManager.lastLocation?.coordinate {
                            homeViewModel.fetchThreeDayForecast(for: coordinate)
                        }
                    }
            } else {
                // Displays the 3-day forecast in a list
                List(homeViewModel.threeDayForecast, id: \.day) { dayForecast in
                    VStack(alignment: .leading) {
                        Text(dayForecast.day)
                        Image(systemName: dayForecast.symbolName)
                        Text("Low: \(dayForecast.lowTemperature)°C")
                        Text("High: \(dayForecast.highTemperature)°C")
                        Text("Wind: \(dayForecast.wind)°C")
                    }
                }
            }

            // Displays error message if any
            if let errorMessage = homeViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
        }
        .navigationTitle("3-Day Forecast")
    }
}
