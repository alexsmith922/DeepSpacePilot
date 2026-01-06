import Foundation
import SwiftAA

public struct ObjectVisibility {
    public let altitude: Double
    public let azimuth: Double
    public let isAboveHorizon: Bool
    public let difficultyScore: Double // 0 (Impossible) to 10 (Excellent)
}

public class AstronomyService {
    public static let shared = AstronomyService()
    
    private init() {}
    
    public func calculateCurrentMoonPhase(date: Date) -> Double {
        let moon = Moon(julianDay: JulianDay(date))
        // Illumination fraction (0.0 to 1.0) is a good proxy for "Phase" for our difficulty calculation
        // Or we could use moon.phaseAngle for more precision, but illumination matches our "brightness" worry.
        return moon.illuminatedFraction()
    }

    public func calculateVisibility(for object: SpaceObject, condition: ObservingCondition) -> ObjectVisibility {
        let julianDay = JulianDay(condition.date)
        let location = GeographicCoordinates(
            positivelyWestwardLongitude: Degree(-condition.location.longitude), // SwiftAA expects West positive often, need to verify. Usually standard is East positive, but AA+ uses West positive. SwiftAA wrappers usually handle this. Let's check GeographicCoordinates init.
            // Actually SwiftAA GeographicCoordinates(latitude:longitude:) usually takes standard signed degrees.
            // However, AA+ core uses West positive. SwiftAA generally abstracts this.
            // Let's stick to standard map conventions (East +, West -) and convert if needed.
            // Documentation says: "Longitude is positive West". Let's verify.
            // For now assuming SwiftAA handles conversion if we use the constructor correctly or we just adhere to their doc.
            // If doc says positive West, and we have -97 for Texas, we pass 97.
            latitude: Degree(condition.location.latitude)
        )
        
        // SwiftAA: Longitude is positive WEST of Greenwich.
        // UserLocation: Longitude is usually standard (East +, West -).
        // So if user is in NY (-74), SwiftAA wants +74.
        // So we negate the user's longitude.
        let swiftAALocation = GeographicCoordinates(
            positivelyWestwardLongitude: Degree(-condition.location.longitude),
            latitude: Degree(condition.location.latitude),
            altitude: Meter(condition.location.altitude)
        )
        
        // Create the celestial body
        // We have RA/Dec. We can create a fixed object.
        // RA in catalog is Hours. SwiftAA often wants Degrees or Hours.
        let coords = EquatorialCoordinates(
            alpha: Hour(object.rightAscension),
            delta: Degree(object.declination)
        )
        
        // Calculate Topocentric Coordinates (Alt/Az)
        let horizontal = coords.makeHorizontalCoordinates(for: swiftAALocation, at: julianDay)
        
        let altitude = horizontal.altitude.value
        let azimuth = horizontal.azimuth.value
        
        let difficulty = calculateDifficulty(
            object: object,
            altitude: altitude,
            moonPhase: condition.moonPhase,
            lightPollution: condition.lightPollution,
            cloudCover: condition.cloudCover
        )
        
        return ObjectVisibility(
            altitude: altitude,
            azimuth: azimuth,
            isAboveHorizon: altitude > 0,
            difficultyScore: difficulty
        )
    }
    
    private func calculateDifficulty(object: SpaceObject, altitude: Double, moonPhase: Double, lightPollution: Int, cloudCover: Double) -> Double {
        // Base score starts perfect
        var score = 10.0
        
        // 1. Altitude Penalty
        // Below 15 degrees is very hard. Below 0 is impossible.
        if altitude <= 0 { return 0.0 }
        if altitude < 30 {
            score -= (30 - altitude) * 0.2 // Deduct up to 6 points if at horizon
        }
        
        // 2. Magnitude & Light Pollution Penalty
        // Limiting magnitude depends on Bortle scale.
        // Approx limiting mag = 7.5 - 0.5 * Bortle (Very rough rule of thumb)
        // Bortle 1 (Excellent) -> Mag ~7.0 visible
        // Bortle 9 (Inner City) -> Mag ~3.0 visible
        let limitingMag = 7.5 - (0.5 * Double(lightPollution))
        
        // If object is fainter than limiting mag, it's very hard with naked eye/small scope.
        // But telescopes gather more light. This is a "difficulty" for a "user with a telescope".
        // Let's just say if it's faint, it's harder.
        let magDiff = object.visualMagnitude - limitingMag
        if magDiff > 0 {
            // Object is dimmer than sky limit
            score -= magDiff * 2.0
        }
        
        // 3. Moon Phase Penalty
        // Full moon (1.0) washes out sky.
        // Penalty depends on object type. Stars/Planets don't care. Galaxies/Nebulae care a lot.
        if object.type == .galaxy || object.type == .nebula {
            score -= moonPhase * 4.0 // Up to 4 points off for full moon
        }
        
        // 4. Cloud Cover Penalty
        // Simple linear reduction
        score -= cloudCover * 10.0 // 100% clouds = -10 score
        
        return max(0.0, min(10.0, score))
    }
}
