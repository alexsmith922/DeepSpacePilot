import Foundation

public enum SpaceObjectType: String, Codable, CaseIterable {
    case galaxy = "Galaxy"
    case nebula = "Nebula"
    case openCluster = "Open Cluster"
    case globularCluster = "Globular Cluster"
    case planetaryNebula = "Planetary Nebula"
    case supernovaRemnant = "Supernova Remnant"
    case star = "Star"
    case other = "Other"
}

public struct SpaceObject: Identifiable, Codable, Hashable {
    public let id: Int // Messier number (e.g., 31 for M31)
    public let name: String // "M31"
    public let commonName: String? // "Andromeda Galaxy"
    public let type: SpaceObjectType
    public let constellation: String
    
    // Equatorial Coordinates (J2000 epoch usually, but for simple app J2000 is standard)
    public let rightAscension: Double // In hours
    public let declination: Double // In degrees
    
    public let visualMagnitude: Double
    public let difficulty: Int // Base difficulty (1-10) independent of conditions, roughly
    
    public var imageName: String {
        return "m\(id)"
    }
    
    public init(id: Int, name: String, commonName: String?, type: SpaceObjectType, constellation: String, rightAscension: Double, declination: Double, visualMagnitude: Double, difficulty: Int = 5) {
        self.id = id
        self.name = name
        self.commonName = commonName
        self.type = type
        self.constellation = constellation
        self.rightAscension = rightAscension
        self.declination = declination
        self.visualMagnitude = visualMagnitude
        self.difficulty = difficulty
    }
}
