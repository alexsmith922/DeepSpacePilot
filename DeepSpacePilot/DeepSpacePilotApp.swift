import SwiftUI

@main
struct DeepSpacePilotApp: App {
    var body: some Scene {
        WindowGroup {
            ObjectListView()
                .onAppear {
                    // Request location permission on app launch
                    LocationManager.shared.requestPermission()
                }
        }
    }
}
