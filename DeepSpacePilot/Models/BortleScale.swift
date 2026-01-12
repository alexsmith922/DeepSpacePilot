import Foundation
import SwiftUI

public enum BortleScale: Int, CaseIterable, Identifiable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9

    public var id: Int { rawValue }

    public var name: String {
        switch self {
        case .one: return "Excellent Dark Sky"
        case .two: return "Typical Dark Sky"
        case .three: return "Rural Sky"
        case .four: return "Rural/Suburban Transition"
        case .five: return "Suburban Sky"
        case .six: return "Bright Suburban Sky"
        case .seven: return "Suburban/Urban Transition"
        case .eight: return "City Sky"
        case .nine: return "Inner-City Sky"
        }
    }

    public var shortName: String {
        switch self {
        case .one: return "Excellent Dark"
        case .two: return "Dark Sky"
        case .three: return "Rural"
        case .four: return "Rural/Suburban"
        case .five: return "Suburban"
        case .six: return "Bright Suburban"
        case .seven: return "Suburban/Urban"
        case .eight: return "City"
        case .nine: return "Inner-City"
        }
    }

    public var description: String {
        switch self {
        case .one:
            return "Zodiacal light, gegenschein, and zodiacal band visible. M33 visible with direct vision. Scorpius and Sagittarius regions of Milky Way cast obvious shadows."
        case .two:
            return "Airglow may be visible. M33 easily seen with direct vision. Milky Way highly structured. Zodiacal light bright enough to cast shadows before dawn."
        case .three:
            return "Some light pollution on horizon. Clouds illuminated near horizon. M33 visible with averted vision. Milky Way still appears complex."
        case .four:
            return "Light pollution domes visible in several directions. Zodiacal light still visible but not extending halfway to zenith. Milky Way well above horizon shows structure but lacks detail."
        case .five:
            return "Only hints of zodiacal light on best nights. Milky Way very weak or invisible near horizon. Light sources visible in most directions. Clouds noticeably brighter than sky."
        case .six:
            return "Zodiacal light invisible. Milky Way only visible near zenith. Sky within 35° of horizon glows grayish. Clouds anywhere in sky appear fairly bright."
        case .seven:
            return "Entire sky has grayish-white hue. Strong light sources in all directions. Milky Way nearly invisible. M44 and M31 may be glimpsed but very indistinct."
        case .eight:
            return "Sky glows white or orange. You can read newspaper headlines without difficulty. M31 and M44 only barely visible to experienced observer on good nights."
        case .nine:
            return "Entire sky brightly lit. Many stars in constellations invisible. Only bright planets and a few stars visible. Only the Moon, planets, and few bright star clusters visible."
        }
    }

    public var color: Color {
        switch self {
        case .one, .two:
            return .green
        case .three, .four:
            return .mint
        case .five, .six:
            return .yellow
        case .seven:
            return .orange
        case .eight, .nine:
            return .red
        }
    }

    public var icon: String {
        switch self {
        case .one, .two:
            return "moon.stars.fill"
        case .three, .four:
            return "moon.fill"
        case .five, .six:
            return "moon.haze.fill"
        case .seven, .eight:
            return "sun.haze.fill"
        case .nine:
            return "light.max"
        }
    }
}

// MARK: - Settings Manager

public class BortleSettings: ObservableObject {
    public static let shared = BortleSettings()

    private let key = "userBortleScale"

    @Published public var currentScale: BortleScale {
        didSet {
            UserDefaults.standard.set(currentScale.rawValue, forKey: key)
        }
    }

    private init() {
        let saved = UserDefaults.standard.integer(forKey: key)
        if saved > 0, let scale = BortleScale(rawValue: saved) {
            currentScale = scale
        } else {
            // Default to Bortle 6 (Bright Suburban) as a reasonable middle ground
            currentScale = .six
        }
    }
}
