import Foundation
import CoreLocation
public import Combine

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    public static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    @Published public var currentUserLocation: UserLocation?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    public func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    public func startUpdating() {
        manager.startUpdatingLocation()
    }
    
    public func stopUpdating() {
        manager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        #if os(iOS)
        let authorized = authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
        #else
        let authorized = authorizationStatus == .authorizedAlways || authorizationStatus == .authorized
        #endif
        
        if authorized {
            manager.startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.currentUserLocation = UserLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude
        )
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }
}
