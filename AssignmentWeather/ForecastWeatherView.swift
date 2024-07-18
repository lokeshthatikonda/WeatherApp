import SwiftUI

struct ForecastWeatherView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        VStack {
            // Displays a loading message while the forecast is being fetched
            // Displays the 3-day forecast in a list
            List(homeViewModel.threeDayForecast, id: \.day) { dayForecast in
                VStack(alignment: .leading) {
                    Text(dayForecast.day)
                    Image(systemName: dayForecast.symbolName)
                    Text("Low: \(dayForecast.lowTemperature)C")
                    Text("High: \(dayForecast.highTemperature)C")
                    Text("Wind: \(dayForecast.wind)")
                    Text("Condition: \(dayForecast.currentCondition)")
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
