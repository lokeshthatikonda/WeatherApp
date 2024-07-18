# WeatherApp

## Description

WeatherApp is a SwiftUI application that provides current weather information and a 3-day weather forecast based on the user's location or a specified city. It leverages Apple's native WeatherKit and CoreLocation frameworks to fetch and display weather data.

# Usage
Launch the app.
Grant location permissions when prompted.
View the current weather information.
Enter a city name to fetch weather data for that location.
Navigate to the 3-day forecast screen to view the weather forecast.

## Application Flow

1. **Welcome Screen**:
   - Displays a welcome message.
   - Contains a button to proceed to the home screen.
   - Requests location permission on appearance.

2. **Home Screen**:
   - Displays the current weather conditions and temperature for the user's location.
   - Provides a text field to enter a city name and fetch weather data for that city.
   - Shows weather information based on the fetched coordinates.
   - Includes a link to view the 3-day weather forecast.

3. **Current Weather Screen**:
   - Displays the current weather condition, temperature, feels like, wind speed and humidity.
   - Provides an input for entering a city name to fetch weather data for that city.
   - Fetches and displays weather data based on the entered city or user's location.

4. **Forecast Weather Screen**:
   - Displays a 3-day weather forecast.
   - Fetches and displays forecast data based on the user's location.

## Choice of Framework, Library, and API

### Framework
- **SwiftUI**: Used for building the user interface. SwiftUI provides a declarative syntax and a real-time preview, making it easy to design complex interfaces efficiently.
- **Combine**: Used for managing asynchronous events and data binding. Combine allows for reactive programming, making it easier to handle data streams and state changes.

### Library
- **CoreLocation**: Used for accessing the user's location. CoreLocation provides services for determining the device's geographic location, altitude, and orientation.

### API
- **WeatherKit**: A native framework provided by Apple to fetch weather data. WeatherKit offers accurate and up-to-date weather information directly from Apple’s servers, ensuring reliable and integrated weather data without the need for third-party APIs.

## Assumptions

1. **WeatherKit**:
   - Assumed that WeatherKit provides all necessary weather data (current conditions and forecasts). The implementation leverages WeatherKit for its simplicity and seamless integration with the Apple ecosystem.

2. **Location Permissions**:
   - Assumed that the user grants location permissions when requested. If denied, the app might not function correctly without the user's location data.

3. **City Name Input**:
   - Assumed that users will input valid city names. If an invalid city name is entered, the app displays an appropriate error message.

## Improvements

1. **Error Handling**:
   - Improve error handling to cover more edge cases and provide more user-friendly error messages.
   - Include retry mechanisms for network requests in case of temporary failures.

2. **UI/UX Enhancements**:
   - Improve the overall design and responsiveness of the user interface.
   - Add animations and transitions to enhance the user experience.
   - Provide visual feedback during data fetching processes.

3. **Testing**:
   - Add comprehensive unit tests and UI tests to ensure the app functions correctly under various scenarios.

4. **Localization**:
   - Add support for multiple languages to make the app accessible to a broader audience.

5. **Caching**:
   - Implement caching mechanisms to store weather data locally for offline access and reduce the number of API requests.

6. **Performance Optimization**:
   - Optimize the app's performance by minimizing memory usage and ensuring smooth UI updates.

## Getting Started

### Prerequisites

- Xcode 13 or later
- iOS 15.0 or later

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/lokeshthatikonda/WeatherApp.git

