import Foundation

public struct ObservingCondition {
    public var cloudCover: Double // 0.0 to 1.0 (0% to 100%)
    public var moonPhase: Double // 0.0 (New) to 1.0 (Full) roughly, or age
    public var lightPollution: Int // Bortle Scale 1-9
    public var date: Date
    public var location: UserLocation
    
    public init(cloudCover: Double, moonPhase: Double, lightPollution: Int, date: Date, location: UserLocation) {
        self.cloudCover = cloudCover
        self.moonPhase = moonPhase
        self.lightPollution = lightPollution
        self.date = date
        self.location = location
    }
}

public struct UserLocation {
    public let latitude: Double
    public let longitude: Double
    public let altitude: Double // meters
    
    public init(latitude: Double, longitude: Double, altitude: Double = 0.0) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
}
