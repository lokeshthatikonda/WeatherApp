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
}


class HomeViewModel: ObservableObject {
    @Published private(set) var currentTemperature = String()
    @Published private(set) var currentCondition = String()
    @Published private(set) var windCondition = String()
    @Published private(set) var hourlyForecast = [HourWeather]()
    @Published private(set) var threeDayForecast = [DayWeather]()
    @Published var cityName = ""
    @Published var errorMessage: String?

    private let weatherService = WeatherService.shared
    private var cancellables = Set<AnyCancellable>()
    let locationManager: LocationManager

    // Initializer to create HomeViewModel with the provided locationManager
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        locationManager.$lastLocation
            .compactMap { $0?.coordinate }
            .sink { [weak self] coordinate in
                self?.fetchThreeDayForecast(for: coordinate)
            }
            .store(in: &cancellables)
    }

    // Fetches the current weather data for the given coordinates
    func fetchCurrentWeather(for coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                let weather = try await weatherService.weather(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), including: .current)
                DispatchQueue.main.async {
                    self.currentTemperature = weather.temperature.formatted()
                    self.windCondition = weather.wind.speed.formatted()
                    self.currentCondition = weather.condition.description
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching current weather data: \(error.localizedDescription)"
                }
            }
        }
    }

    // Fetches the 3-day weather forecast for the given coordinates
    func fetchThreeDayForecast(for coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                let weather = try await weatherService.weather(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), including: .daily)
                DispatchQueue.main.async {
                    self.threeDayForecast = weather.forecast.prefix(3).map {
                        DayWeather(day: self.dayFormatter(date: $0.date), symbolName: $0.symbolName, lowTemperature: "\($0.lowTemperature.formatted().dropLast())", highTemperature: "\($0.highTemperature.formatted().dropLast())", wind: "\($0.wind.speed.formatted())")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching 3-day forecast data: \(error.localizedDescription)"
                }
            }
        }
    }

    // Gets the coordinates for the given city name
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
            
            completion(location.coordinate)
        }
    }

    // Formats the date to a string representing the hour
    private func hourFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ha"
        return dateFormatter.string(from: date)
    }

    // Formats the date to a string representing the day of the week
    private func dayFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }

    // Gets the city name from the given location coordinates
    private func getAddressFromLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                print("Unable to reverse geocode")
                return
            }
            
            if let name = placemark.subAdministrativeArea {
                self.cityName = name
                print("CityName:", name)
            } else {
                self.cityName = "Unknown Place"
            }
        }
    }
}
