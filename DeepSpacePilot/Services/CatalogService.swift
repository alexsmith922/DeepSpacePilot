import Foundation

public class CatalogService {
    public static let shared = CatalogService()
    
    public let objects: [SpaceObject]
    
    private init() {
        // Initializing with a subset of popular Messier objects for the prototype
        self.objects = [
            SpaceObject(id: 1, name: "M1", commonName: "Crab Nebula", type: .supernovaRemnant, constellation: "Taurus", rightAscension: 5.575, declination: 22.014, visualMagnitude: 8.4),
            SpaceObject(id: 13, name: "M13", commonName: "Great Hercules Cluster", type: .globularCluster, constellation: "Hercules", rightAscension: 16.695, declination: 36.46, visualMagnitude: 5.8),
            SpaceObject(id: 31, name: "M31", commonName: "Andromeda Galaxy", type: .galaxy, constellation: "Andromeda", rightAscension: 0.712, declination: 41.26, visualMagnitude: 3.4, difficulty: 1),
            SpaceObject(id: 42, name: "M42", commonName: "Orion Nebula", type: .nebula, constellation: "Orion", rightAscension: 5.588, declination: -5.39, visualMagnitude: 4.0, difficulty: 1),
            SpaceObject(id: 45, name: "M45", commonName: "Pleiades", type: .openCluster, constellation: "Taurus", rightAscension: 3.783, declination: 24.116, visualMagnitude: 1.6, difficulty: 1),
            SpaceObject(id: 57, name: "M57", commonName: "Ring Nebula", type: .planetaryNebula, constellation: "Lyra", rightAscension: 18.893, declination: 33.028, visualMagnitude: 8.8),
            SpaceObject(id: 81, name: "M81", commonName: "Bode's Galaxy", type: .galaxy, constellation: "Ursa Major", rightAscension: 9.925, declination: 69.066, visualMagnitude: 6.9),
            SpaceObject(id: 82, name: "M82", commonName: "Cigar Galaxy", type: .galaxy, constellation: "Ursa Major", rightAscension: 9.93, declination: 69.679, visualMagnitude: 8.4),
            SpaceObject(id: 104, name: "M104", commonName: "Sombrero Galaxy", type: .galaxy, constellation: "Virgo", rightAscension: 12.667, declination: -11.623, visualMagnitude: 8.0)
        ]
    }
    
    public func getAllObjects() -> [SpaceObject] {
        return objects
    }
    
    public func object(withId id: Int) -> SpaceObject? {
        return objects.first(where: { $0.id == id })
    }
}
