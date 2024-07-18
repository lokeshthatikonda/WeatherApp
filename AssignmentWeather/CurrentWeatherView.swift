import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        VStack {
            // TextField to enter the city name and fetch weather data upon commit
            TextField("Enter City", text: $homeViewModel.cityName, onCommit: {
                homeViewModel.getCoordinates(for: homeViewModel.cityName) { coordinate in
                    guard let coordinate = coordinate else { return }
                    homeViewModel.fetchCurrentWeather(for: coordinate)
                    homeViewModel.fetchThreeDayForecast(for: coordinate)
                }
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Displays the current weather information if available
            if !homeViewModel.currentCondition.isEmpty {
                VStack {
                    HStack {
                        Text("Weather Condition: \(homeViewModel.currentCondition)")
                        Image(systemName: homeViewModel.symbolName)
                    }
                    Text("Temperature: \(homeViewModel.currentTemperature)")
                    Text("Feels Like: \(homeViewModel.feelsLikeTemperature)")
                    Text("Wind: \(homeViewModel.windCondition)")
                    Text("Humidity: \(homeViewModel.humidity)")
                }
                .padding()
            }

            // Displays error message if any
            if let errorMessage = homeViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()

            // Navigation link to view the 3-day forecast
            NavigationLink(destination: ForecastWeatherView()
                .environmentObject(homeViewModel)) {
                Text("View 3-Day Forecast")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

        }
        .onAppear(perform: {
            // Fetches current weather and 3-day forecast when the view appears
            if let coordinate = homeViewModel.locationManager.lastLocation?.coordinate {
                homeViewModel.fetchCurrentWeather(for: coordinate)
                homeViewModel.fetchThreeDayForecast(for: coordinate)
            }
            
        })
        .navigationTitle("Current Weather")
    }
}
