import SwiftUI

@main
struct AssignmentWeatherApp: App {
    // The body property of the App protocol, which provides the main scene for the app
    var body: some Scene {
        // Create a window group for the app's user interface
        WindowGroup {
            WelcomeView()
        }
    }
}
