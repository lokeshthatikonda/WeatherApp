import SwiftUI
import CoreLocation
import WeatherKit
import Combine

struct DayWeather: Hashable {
    let day: String
    let symbolName: String
    let lowTemperature: String
    let highTemperature: String
    let wind: String
    let currentCondition: String
}

class HomeViewModel: ObservableObject {
    @Published private(set) var currentTemperature = String()
    @Published private(set) var feelsLikeTemperature = String()
    @Published private(set) var currentCondition = String()
    @Published private(set) var windCondition = String()
    @Published private(set) var humidity = String()
    @Published private(set) var symbolName = String()
    @Published private(set) var threeDayForecast = [DayWeather]()
    @Published var cityName = ""
    @Published var errorMessage: String?

    private let weatherService = WeatherService.shared
    private var cancellables = Set<AnyCancellable>()
    let locationManager: LocationManager

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        if let savedCoordinate = getSavedCoordinate() {
            // If there is a saved coordinate, fetch the weather data for it
            fetchWeatherData(for: savedCoordinate)
        } else {
            // If no saved coordinate, use the last known location
            locationManager.$lastLocation
                .compactMap { $0?.coordinate }
                .sink { [weak self] coordinate in
                    self?.saveCoordinate(coordinate)
                    self?.fetchWeatherData(for: coordinate)
                }
                .store(in: &cancellables)
        }
    }

    // Fetch current weather data for the specified coordinate
    func fetchCurrentWeather(for coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                let weather = try await weatherService.weather(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), including: .current)
                DispatchQueue.main.async {
                    self.currentTemperature = weather.temperature.formatted()
                    self.feelsLikeTemperature = weather.apparentTemperature.formatted()
                    self.windCondition = weather.wind.speed.formatted()
                    self.currentCondition = weather.condition.description
                    self.humidity = "\(weather.humidity)"
                    self.symbolName = weather.symbolName
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching current weather data: \(error.localizedDescription)"
                }
            }
        }
    }

    // Fetch 3-day weather forecast data for the specified coordinate

    func fetchThreeDayForecast(for coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                let weather = try await weatherService.weather(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), including: .daily)
                DispatchQueue.main.async {
                    self.threeDayForecast = weather.forecast.prefix(3).map {
                        DayWeather(day: self.dayFormatter(date: $0.date), symbolName: $0.symbolName, lowTemperature: "\($0.lowTemperature.formatted().dropLast())", highTemperature: "\($0.highTemperature.formatted().dropLast())", wind: "\($0.wind.speed.formatted())", currentCondition: "\($0.condition.description)")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching 3-day forecast data: \(error.localizedDescription)"
                }
            }
        }
    }

    // Get the coordinates for a specified city
    func getCoordinates(for city: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { placemarks, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Geocoding error: \(error.localizedDescription)"
                }
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first, let location = placemark.location else {
                DispatchQueue.main.async {
                    self.errorMessage = "No location found"
                }
                completion(nil)
                return
            }
            
            let coordinate = location.coordinate
            self.saveCoordinate(coordinate)
            completion(coordinate)
        }
    }

    // Fetch both current weather and 3-day forecast data for the specified coordinate
    private func fetchWeatherData(for coordinate: CLLocationCoordinate2D) {
        fetchCurrentWeather(for: coordinate)
        fetchThreeDayForecast(for: coordinate)
    }

    // Save the specified coordinate to UserDefaults
    private func saveCoordinate(_ coordinate: CLLocationCoordinate2D) {
        UserDefaults.standard.set(coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(coordinate.longitude, forKey: "longitude")
    }

    // Retrieve the saved coordinate from UserDefaults
    private func getSavedCoordinate() -> CLLocationCoordinate2D? {
        let latitude = UserDefaults.standard.double(forKey: "latitude")
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        if latitude != 0.0 && longitude != 0.0 {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }

    // Format a date into an hour string (e.g., "2PM")
    private func hourFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ha"
        return dateFormatter.string(from: date)
    }

    // Format a date into a day string (e.g., "Monday")
    private func dayFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}
