import Foundation
import CoreLocation
public import Combine

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    public static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    @Published public var currentUserLocation: UserLocation?
    @Published public var currentLocationName: String?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let geocoder = CLGeocoder()
    
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
        
        // Reverse Geocode
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first, error == nil else { return }
            
            var name = ""
            if let city = placemark.locality {
                name += city
            }
            if let state = placemark.administrativeArea {
                if !name.isEmpty { name += ", " }
                name += state
            }
            
            if !name.isEmpty {
                self.currentLocationName = name
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }
}
