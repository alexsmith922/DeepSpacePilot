import Foundation

public class CatalogService {
    public static let shared = CatalogService()

    public let objects: [SpaceObject]

    private init() {
        // Full Messier Catalog (110 objects)
        self.objects = [
            // M1 - M10
            SpaceObject(id: 1, name: "M1", commonName: "Crab Nebula", type: .supernovaRemnant, constellation: "Taurus", rightAscension: 5.575, declination: 22.014, visualMagnitude: 8.4, difficulty: 5),
            SpaceObject(id: 2, name: "M2", commonName: nil, type: .globularCluster, constellation: "Aquarius", rightAscension: 21.558, declination: -0.823, visualMagnitude: 6.5, difficulty: 4),
            SpaceObject(id: 3, name: "M3", commonName: nil, type: .globularCluster, constellation: "Canes Venatici", rightAscension: 13.703, declination: 28.377, visualMagnitude: 6.2, difficulty: 3),
            SpaceObject(id: 4, name: "M4", commonName: nil, type: .globularCluster, constellation: "Scorpius", rightAscension: 16.393, declination: -26.526, visualMagnitude: 5.6, difficulty: 3),
            SpaceObject(id: 5, name: "M5", commonName: nil, type: .globularCluster, constellation: "Serpens", rightAscension: 15.310, declination: 2.081, visualMagnitude: 5.6, difficulty: 3),
            SpaceObject(id: 6, name: "M6", commonName: "Butterfly Cluster", type: .openCluster, constellation: "Scorpius", rightAscension: 17.668, declination: -32.216, visualMagnitude: 4.2, difficulty: 2),
            SpaceObject(id: 7, name: "M7", commonName: "Ptolemy Cluster", type: .openCluster, constellation: "Scorpius", rightAscension: 17.898, declination: -34.816, visualMagnitude: 3.3, difficulty: 1),
            SpaceObject(id: 8, name: "M8", commonName: "Lagoon Nebula", type: .nebula, constellation: "Sagittarius", rightAscension: 18.063, declination: -24.386, visualMagnitude: 6.0, difficulty: 2),
            SpaceObject(id: 9, name: "M9", commonName: nil, type: .globularCluster, constellation: "Ophiuchus", rightAscension: 17.321, declination: -18.516, visualMagnitude: 7.7, difficulty: 5),
            SpaceObject(id: 10, name: "M10", commonName: nil, type: .globularCluster, constellation: "Ophiuchus", rightAscension: 16.952, declination: -4.100, visualMagnitude: 6.6, difficulty: 4),

            // M11 - M20
            SpaceObject(id: 11, name: "M11", commonName: "Wild Duck Cluster", type: .openCluster, constellation: "Scutum", rightAscension: 18.851, declination: -6.266, visualMagnitude: 6.3, difficulty: 3),
            SpaceObject(id: 12, name: "M12", commonName: nil, type: .globularCluster, constellation: "Ophiuchus", rightAscension: 16.787, declination: -1.949, visualMagnitude: 6.7, difficulty: 4),
            SpaceObject(id: 13, name: "M13", commonName: "Great Hercules Cluster", type: .globularCluster, constellation: "Hercules", rightAscension: 16.695, declination: 36.460, visualMagnitude: 5.8, difficulty: 2),
            SpaceObject(id: 14, name: "M14", commonName: nil, type: .globularCluster, constellation: "Ophiuchus", rightAscension: 17.626, declination: -3.246, visualMagnitude: 7.6, difficulty: 5),
            SpaceObject(id: 15, name: "M15", commonName: nil, type: .globularCluster, constellation: "Pegasus", rightAscension: 21.500, declination: 12.167, visualMagnitude: 6.2, difficulty: 3),
            SpaceObject(id: 16, name: "M16", commonName: "Eagle Nebula", type: .nebula, constellation: "Serpens", rightAscension: 18.313, declination: -13.786, visualMagnitude: 6.4, difficulty: 4),
            SpaceObject(id: 17, name: "M17", commonName: "Omega Nebula", type: .nebula, constellation: "Sagittarius", rightAscension: 18.346, declination: -16.183, visualMagnitude: 6.0, difficulty: 3),
            SpaceObject(id: 18, name: "M18", commonName: nil, type: .openCluster, constellation: "Sagittarius", rightAscension: 18.332, declination: -17.133, visualMagnitude: 7.5, difficulty: 5),
            SpaceObject(id: 19, name: "M19", commonName: nil, type: .globularCluster, constellation: "Ophiuchus", rightAscension: 17.044, declination: -26.268, visualMagnitude: 6.8, difficulty: 4),
            SpaceObject(id: 20, name: "M20", commonName: "Trifid Nebula", type: .nebula, constellation: "Sagittarius", rightAscension: 18.044, declination: -23.033, visualMagnitude: 6.3, difficulty: 4),

            // M21 - M30
            SpaceObject(id: 21, name: "M21", commonName: nil, type: .openCluster, constellation: "Sagittarius", rightAscension: 18.076, declination: -22.500, visualMagnitude: 6.5, difficulty: 4),
            SpaceObject(id: 22, name: "M22", commonName: "Sagittarius Cluster", type: .globularCluster, constellation: "Sagittarius", rightAscension: 18.607, declination: -23.905, visualMagnitude: 5.1, difficulty: 2),
            SpaceObject(id: 23, name: "M23", commonName: nil, type: .openCluster, constellation: "Sagittarius", rightAscension: 17.950, declination: -19.017, visualMagnitude: 6.9, difficulty: 4),
            SpaceObject(id: 24, name: "M24", commonName: "Sagittarius Star Cloud", type: .other, constellation: "Sagittarius", rightAscension: 18.283, declination: -18.483, visualMagnitude: 4.6, difficulty: 2),
            SpaceObject(id: 25, name: "M25", commonName: nil, type: .openCluster, constellation: "Sagittarius", rightAscension: 18.528, declination: -19.233, visualMagnitude: 4.6, difficulty: 2),
            SpaceObject(id: 26, name: "M26", commonName: nil, type: .openCluster, constellation: "Scutum", rightAscension: 18.756, declination: -9.400, visualMagnitude: 8.0, difficulty: 5),
            SpaceObject(id: 27, name: "M27", commonName: "Dumbbell Nebula", type: .planetaryNebula, constellation: "Vulpecula", rightAscension: 19.994, declination: 22.721, visualMagnitude: 7.5, difficulty: 3),
            SpaceObject(id: 28, name: "M28", commonName: nil, type: .globularCluster, constellation: "Sagittarius", rightAscension: 18.410, declination: -24.870, visualMagnitude: 6.8, difficulty: 4),
            SpaceObject(id: 29, name: "M29", commonName: nil, type: .openCluster, constellation: "Cygnus", rightAscension: 20.399, declination: 38.533, visualMagnitude: 7.1, difficulty: 4),
            SpaceObject(id: 30, name: "M30", commonName: nil, type: .globularCluster, constellation: "Capricornus", rightAscension: 21.673, declination: -23.180, visualMagnitude: 7.2, difficulty: 5),

            // M31 - M40
            SpaceObject(id: 31, name: "M31", commonName: "Andromeda Galaxy", type: .galaxy, constellation: "Andromeda", rightAscension: 0.712, declination: 41.269, visualMagnitude: 3.4, difficulty: 1),
            SpaceObject(id: 32, name: "M32", commonName: nil, type: .galaxy, constellation: "Andromeda", rightAscension: 0.711, declination: 40.866, visualMagnitude: 8.1, difficulty: 4),
            SpaceObject(id: 33, name: "M33", commonName: "Triangulum Galaxy", type: .galaxy, constellation: "Triangulum", rightAscension: 1.564, declination: 30.660, visualMagnitude: 5.7, difficulty: 4),
            SpaceObject(id: 34, name: "M34", commonName: nil, type: .openCluster, constellation: "Perseus", rightAscension: 2.702, declination: 42.783, visualMagnitude: 5.5, difficulty: 2),
            SpaceObject(id: 35, name: "M35", commonName: nil, type: .openCluster, constellation: "Gemini", rightAscension: 6.148, declination: 24.333, visualMagnitude: 5.3, difficulty: 2),
            SpaceObject(id: 36, name: "M36", commonName: nil, type: .openCluster, constellation: "Auriga", rightAscension: 5.602, declination: 34.133, visualMagnitude: 6.3, difficulty: 3),
            SpaceObject(id: 37, name: "M37", commonName: nil, type: .openCluster, constellation: "Auriga", rightAscension: 5.873, declination: 32.550, visualMagnitude: 6.2, difficulty: 3),
            SpaceObject(id: 38, name: "M38", commonName: nil, type: .openCluster, constellation: "Auriga", rightAscension: 5.478, declination: 35.833, visualMagnitude: 7.4, difficulty: 4),
            SpaceObject(id: 39, name: "M39", commonName: nil, type: .openCluster, constellation: "Cygnus", rightAscension: 21.535, declination: 48.433, visualMagnitude: 5.2, difficulty: 2),
            SpaceObject(id: 40, name: "M40", commonName: "Winnecke 4", type: .star, constellation: "Ursa Major", rightAscension: 12.373, declination: 58.083, visualMagnitude: 8.4, difficulty: 6),

            // M41 - M50
            SpaceObject(id: 41, name: "M41", commonName: nil, type: .openCluster, constellation: "Canis Major", rightAscension: 6.783, declination: -20.733, visualMagnitude: 4.5, difficulty: 2),
            SpaceObject(id: 42, name: "M42", commonName: "Orion Nebula", type: .nebula, constellation: "Orion", rightAscension: 5.588, declination: -5.390, visualMagnitude: 4.0, difficulty: 1),
            SpaceObject(id: 43, name: "M43", commonName: "De Mairan's Nebula", type: .nebula, constellation: "Orion", rightAscension: 5.593, declination: -5.267, visualMagnitude: 9.0, difficulty: 5),
            SpaceObject(id: 44, name: "M44", commonName: "Beehive Cluster", type: .openCluster, constellation: "Cancer", rightAscension: 8.667, declination: 19.983, visualMagnitude: 3.7, difficulty: 1),
            SpaceObject(id: 45, name: "M45", commonName: "Pleiades", type: .openCluster, constellation: "Taurus", rightAscension: 3.783, declination: 24.116, visualMagnitude: 1.6, difficulty: 1),
            SpaceObject(id: 46, name: "M46", commonName: nil, type: .openCluster, constellation: "Puppis", rightAscension: 7.697, declination: -14.817, visualMagnitude: 6.1, difficulty: 3),
            SpaceObject(id: 47, name: "M47", commonName: nil, type: .openCluster, constellation: "Puppis", rightAscension: 7.612, declination: -14.500, visualMagnitude: 4.2, difficulty: 2),
            SpaceObject(id: 48, name: "M48", commonName: nil, type: .openCluster, constellation: "Hydra", rightAscension: 8.230, declination: -5.800, visualMagnitude: 5.5, difficulty: 3),
            SpaceObject(id: 49, name: "M49", commonName: nil, type: .galaxy, constellation: "Virgo", rightAscension: 12.496, declination: 8.000, visualMagnitude: 8.4, difficulty: 5),
            SpaceObject(id: 50, name: "M50", commonName: nil, type: .openCluster, constellation: "Monoceros", rightAscension: 7.053, declination: -8.333, visualMagnitude: 5.9, difficulty: 3),

            // M51 - M60
            SpaceObject(id: 51, name: "M51", commonName: "Whirlpool Galaxy", type: .galaxy, constellation: "Canes Venatici", rightAscension: 13.498, declination: 47.195, visualMagnitude: 8.4, difficulty: 4),
            SpaceObject(id: 52, name: "M52", commonName: nil, type: .openCluster, constellation: "Cassiopeia", rightAscension: 23.413, declination: 61.583, visualMagnitude: 7.3, difficulty: 4),
            SpaceObject(id: 53, name: "M53", commonName: nil, type: .globularCluster, constellation: "Coma Berenices", rightAscension: 13.215, declination: 18.169, visualMagnitude: 7.6, difficulty: 5),
            SpaceObject(id: 54, name: "M54", commonName: nil, type: .globularCluster, constellation: "Sagittarius", rightAscension: 18.918, declination: -30.479, visualMagnitude: 7.6, difficulty: 5),
            SpaceObject(id: 55, name: "M55", commonName: nil, type: .globularCluster, constellation: "Sagittarius", rightAscension: 19.667, declination: -30.967, visualMagnitude: 6.3, difficulty: 4),
            SpaceObject(id: 56, name: "M56", commonName: nil, type: .globularCluster, constellation: "Lyra", rightAscension: 19.276, declination: 30.184, visualMagnitude: 8.3, difficulty: 5),
            SpaceObject(id: 57, name: "M57", commonName: "Ring Nebula", type: .planetaryNebula, constellation: "Lyra", rightAscension: 18.893, declination: 33.028, visualMagnitude: 8.8, difficulty: 4),
            SpaceObject(id: 58, name: "M58", commonName: nil, type: .galaxy, constellation: "Virgo", rightAscension: 12.630, declination: 11.817, visualMagnitude: 9.7, difficulty: 6),
            SpaceObject(id: 59, name: "M59", commonName: nil, type: .galaxy, constellation: "Virgo", rightAscension: 12.700, declination: 11.650, visualMagnitude: 9.6, difficulty: 6),
            SpaceObject(id: 60, name: "M60", commonName: nil, type: .galaxy, constellation: "Virgo", rightAscension: 12.728, declination: 11.550, visualMagnitude: 8.8, difficulty: 5),

            // M61 - M70
            SpaceObject(id: 61, name: "M61", commonName: nil, type: .galaxy, constellation: "Virgo", rightAscension: 12.365, declination: 4.467, visualMagnitude: 9.7, difficulty: 6),
            SpaceObject(id: 62, name: "M62", commonName: nil, type: .globularCluster, constellation: "Ophiuchus", rightAscension: 17.022, declination: -30.113, visualMagnitude: 6.5, difficulty: 4),
            SpaceObject(id: 63, name: "M63", commonName: "Sunflower Galaxy", type: .galaxy, constellation: "Canes Venatici", rightAscension: 13.264, declination: 42.029, visualMagnitude: 8.6, difficulty: 5),
            SpaceObject(id: 64, name: "M64", commonName: "Black Eye Galaxy", type: .galaxy, constellation: "Coma Berenices", rightAscension: 12.945, declination: 21.683, visualMagnitude: 8.5, difficulty: 4),
            SpaceObject(id: 65, name: "M65", commonName: nil, type: .galaxy, constellation: "Leo", rightAscension: 11.315, declination: 13.092, visualMagnitude: 9.3, difficulty: 5),
            SpaceObject(id: 66, name: "M66", commonName: nil, type: .galaxy, constellation: "Leo", rightAscension: 11.338, declination: 12.992, visualMagnitude: 8.9, difficulty: 5),
            SpaceObject(id: 67, name: "M67", commonName: nil, type: .openCluster, constellation: "Cancer", rightAscension: 8.840, declination: 11.817, visualMagnitude: 6.1, difficulty: 3),
            SpaceObject(id: 68, name: "M68", commonName: nil, type: .globularCluster, constellation: "Hydra", rightAscension: 12.655, declination: -26.745, visualMagnitude: 7.8, difficulty: 5),
            SpaceObject(id: 69, name: "M69", commonName: nil, type: .globularCluster, constellation: "Sagittarius", rightAscension: 18.523, declination: -32.348, visualMagnitude: 7.6, difficulty: 5),
            SpaceObject(id: 70, name: "M70", commonName: nil, type: .globularCluster, constellation: "Sagittarius", rightAscension: 18.720, declination: -32.298, visualMagnitude: 7.9, difficulty: 6),

            // M71 - M80
            SpaceObject(id: 71, name: "M71", commonName: nil, type: .globularCluster, constellation: "Sagitta", rightAscension: 19.896, declination: 18.779, visualMagnitude: 8.2, difficulty: 5),
            SpaceObject(id: 72, name: "M72", commonName: nil, type: .globularCluster, constellation: "Aquarius", rightAscension: 20.891, declination: -12.537, visualMagnitude: 9.3, difficulty: 6),
            SpaceObject(id: 73, name: "M73", commonName: nil, type: .other, constellation: "Aquarius", rightAscension: 20.983, declination: -12.633, visualMagnitude: 9.0, difficulty: 6),
            SpaceObject(id: 74, name: "M74", commonName: "Phantom Galaxy", type: .galaxy, constellation: "Pisces", rightAscension: 1.611, declination: 15.783, visualMagnitude: 9.4, difficulty: 7),
            SpaceObject(id: 75, name: "M75", commonName: nil, type: .globularCluster, constellation: "Sagittarius", rightAscension: 20.101, declination: -21.921, visualMagnitude: 8.5, difficulty: 6),
            SpaceObject(id: 76, name: "M76", commonName: "Little Dumbbell Nebula", type: .planetaryNebula, constellation: "Perseus", rightAscension: 1.703, declination: 51.575, visualMagnitude: 10.1, difficulty: 7),
            SpaceObject(id: 77, name: "M77", commonName: "Cetus A", type: .galaxy, constellation: "Cetus", rightAscension: 2.711, declination: -0.014, visualMagnitude: 8.9, difficulty: 5),
            SpaceObject(id: 78, name: "M78", commonName: nil, type: .nebula, constellation: "Orion", rightAscension: 5.779, declination: 0.050, visualMagnitude: 8.3, difficulty: 5),
            SpaceObject(id: 79, name: "M79", commonName: nil, type: .globularCluster, constellation: "Lepus", rightAscension: 5.406, declination: -24.523, visualMagnitude: 7.7, difficulty: 5),
            SpaceObject(id: 80, name: "M80", commonName: nil, type: .globularCluster, constellation: "Scorpius", rightAscension: 16.284, declination: -22.976, visualMagnitude: 7.3, difficulty: 5),

            // M81 - M90
            SpaceObject(id: 81, name: "M81", commonName: "Bode's Galaxy", type: .galaxy, constellation: "Ursa Major", rightAscension: 9.925, declination: 69.066, visualMagnitude: 6.9, difficulty: 3),
            SpaceObject(id: 82, name: "M82", commonName: "Cigar Galaxy", type: .galaxy, constellation: "Ursa Major", rightAscension: 9.930, declination: 69.679, visualMagnitude: 8.4, difficulty: 4),
            SpaceObject(id: 83, name: "M83", commonName: "Southern Pinwheel Galaxy", type: .galaxy, constellation: "Hydra", rightAscension: 13.617, declination: -29.867, visualMagnitude: 7.6, difficulty: 4),
            SpaceObject(id: 84, name: "M84", commonName: nil, type: .galaxy, constellation: "Virgo", rightAscension: 12.418, declination: 12.883, visualMagnitude: 9.1, difficulty: 5),
            SpaceObject(id: 85, name: "M85", commonName: nil, type: .galaxy, constellation: "Coma Berenices", rightAscension: 12.422, declination: 18.191, visualMagnitude: 9.1, difficulty: 5),
            SpaceObject(id: 86, name: "M86", commonName: nil, type: .galaxy, constellation: "Virgo", rightAscension: 12.437, declination: 12.950, visualMagnitude: 8.9, difficulty: 5),
            SpaceObject(id: 87, name: "M87", commonName: "Virgo A", type: .galaxy, constellation: "Virgo", rightAscension: 12.514, declination: 12.391, visualMagnitude: 8.6, difficulty: 4),
            SpaceObject(id: 88, name: "M88", commonName: nil, type: .galaxy, constellation: "Coma Berenices", rightAscension: 12.532, declination: 14.420, visualMagnitude: 9.6, difficulty: 6),
            SpaceObject(id: 89, name: "M89", commonName: nil, type: .galaxy, constellation: "Virgo", rightAscension: 12.594, declination: 12.556, visualMagnitude: 9.8, difficulty: 6),
            SpaceObject(id: 90, name: "M90", commonName: nil, type: .galaxy, constellation: "Virgo", rightAscension: 12.613, declination: 13.163, visualMagnitude: 9.5, difficulty: 6),

            // M91 - M100
            SpaceObject(id: 91, name: "M91", commonName: nil, type: .galaxy, constellation: "Coma Berenices", rightAscension: 12.592, declination: 14.496, visualMagnitude: 10.2, difficulty: 7),
            SpaceObject(id: 92, name: "M92", commonName: nil, type: .globularCluster, constellation: "Hercules", rightAscension: 17.285, declination: 43.137, visualMagnitude: 6.4, difficulty: 3),
            SpaceObject(id: 93, name: "M93", commonName: nil, type: .openCluster, constellation: "Puppis", rightAscension: 7.745, declination: -23.867, visualMagnitude: 6.0, difficulty: 3),
            SpaceObject(id: 94, name: "M94", commonName: nil, type: .galaxy, constellation: "Canes Venatici", rightAscension: 12.850, declination: 41.120, visualMagnitude: 8.2, difficulty: 4),
            SpaceObject(id: 95, name: "M95", commonName: nil, type: .galaxy, constellation: "Leo", rightAscension: 10.730, declination: 11.704, visualMagnitude: 9.7, difficulty: 6),
            SpaceObject(id: 96, name: "M96", commonName: nil, type: .galaxy, constellation: "Leo", rightAscension: 10.781, declination: 11.820, visualMagnitude: 9.2, difficulty: 5),
            SpaceObject(id: 97, name: "M97", commonName: "Owl Nebula", type: .planetaryNebula, constellation: "Ursa Major", rightAscension: 11.248, declination: 55.019, visualMagnitude: 9.9, difficulty: 6),
            SpaceObject(id: 98, name: "M98", commonName: nil, type: .galaxy, constellation: "Coma Berenices", rightAscension: 12.230, declination: 14.900, visualMagnitude: 10.1, difficulty: 7),
            SpaceObject(id: 99, name: "M99", commonName: "Coma Pinwheel Galaxy", type: .galaxy, constellation: "Coma Berenices", rightAscension: 12.313, declination: 14.417, visualMagnitude: 9.9, difficulty: 6),
            SpaceObject(id: 100, name: "M100", commonName: nil, type: .galaxy, constellation: "Coma Berenices", rightAscension: 12.383, declination: 15.820, visualMagnitude: 9.3, difficulty: 5),

            // M101 - M110
            SpaceObject(id: 101, name: "M101", commonName: "Pinwheel Galaxy", type: .galaxy, constellation: "Ursa Major", rightAscension: 14.054, declination: 54.349, visualMagnitude: 7.9, difficulty: 5),
            SpaceObject(id: 102, name: "M102", commonName: "Spindle Galaxy", type: .galaxy, constellation: "Draco", rightAscension: 15.112, declination: 55.763, visualMagnitude: 9.9, difficulty: 6),
            SpaceObject(id: 103, name: "M103", commonName: nil, type: .openCluster, constellation: "Cassiopeia", rightAscension: 1.558, declination: 60.700, visualMagnitude: 7.4, difficulty: 4),
            SpaceObject(id: 104, name: "M104", commonName: "Sombrero Galaxy", type: .galaxy, constellation: "Virgo", rightAscension: 12.667, declination: -11.623, visualMagnitude: 8.0, difficulty: 4),
            SpaceObject(id: 105, name: "M105", commonName: nil, type: .galaxy, constellation: "Leo", rightAscension: 10.784, declination: 12.582, visualMagnitude: 9.3, difficulty: 5),
            SpaceObject(id: 106, name: "M106", commonName: nil, type: .galaxy, constellation: "Canes Venatici", rightAscension: 12.315, declination: 47.304, visualMagnitude: 8.4, difficulty: 4),
            SpaceObject(id: 107, name: "M107", commonName: nil, type: .globularCluster, constellation: "Ophiuchus", rightAscension: 16.542, declination: -13.053, visualMagnitude: 7.9, difficulty: 5),
            SpaceObject(id: 108, name: "M108", commonName: "Surfboard Galaxy", type: .galaxy, constellation: "Ursa Major", rightAscension: 11.191, declination: 55.674, visualMagnitude: 10.0, difficulty: 6),
            SpaceObject(id: 109, name: "M109", commonName: nil, type: .galaxy, constellation: "Ursa Major", rightAscension: 11.960, declination: 53.375, visualMagnitude: 9.8, difficulty: 6),
            SpaceObject(id: 110, name: "M110", commonName: nil, type: .galaxy, constellation: "Andromeda", rightAscension: 0.673, declination: 41.685, visualMagnitude: 8.5, difficulty: 5)
        ]
    }

    public func getAllObjects() -> [SpaceObject] {
        return objects
    }

    public func object(withId id: Int) -> SpaceObject? {
        return objects.first(where: { $0.id == id })
    }
}
