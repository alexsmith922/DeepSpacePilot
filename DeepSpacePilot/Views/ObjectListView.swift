import SwiftUI
public import Combine

public struct ObjectListView: View {
    @StateObject private var viewModel = ObjectListViewModel()
    @State private var sortByBestForTonight = true

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                if let location = viewModel.currentLocation {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                                if let locationName = viewModel.locationName {
                                    Text("Observing from \(locationName)")
                                        .font(.subheadline)
                                } else {
                                    Text("Current Location")
                                        .font(.subheadline)
                                }
                            }
                            HStack(spacing: 16) {
                                Label(String(format: "%.4f°", location.latitude), systemImage: "arrow.up.and.down")
                                Label(String(format: "%.4f°", location.longitude), systemImage: "arrow.left.and.right")
                                if location.altitude > 0 {
                                    Label(String(format: "%.0fm", location.altitude), systemImage: "mountain.2")
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }

                    // Current Conditions Section
                    if let condition = viewModel.condition {
                        Section {
                            ConditionsView(condition: condition)
                        } header: {
                            Text("Tonight's Conditions")
                        }
                    }
                }
                
                Section {
                    ForEach(viewModel.sortedObjects(byBestForTonight: sortByBestForTonight)) { item in
                        NavigationLink(destination: ObjectDetailView(object: item.object, visibility: item.visibility)) {
                            ObjectRowView(item: item)
                        }
                    }
                }
            }
            .navigationTitle("Deep Sky Objects")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: { sortByBestForTonight = true }) {
                            Label("Best for Tonight", systemImage: sortByBestForTonight ? "checkmark" : "")
                        }
                        Button(action: { sortByBestForTonight = false }) {
                            Label("By Catalog Number", systemImage: sortByBestForTonight ? "" : "checkmark")
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: LogbookView()) {
                        Image(systemName: "book.closed")
                    }
                }
                #else
                ToolbarItem(placement: .navigation) {
                    NavigationLink(destination: LogbookView()) {
                        Image(systemName: "book.closed")
                    }
                }
                #endif
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}

struct ObjectRowView: View {
    let item: ObjectListItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.object.name)
                        .font(.headline)
                    if let commonName = item.object.commonName {
                        Text("- \(commonName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                HStack {
                    Text(item.object.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("in \(item.object.constellation)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                DifficultyBadge(score: item.visibility.difficultyScore)
                Text(item.visibility.isAboveHorizon ? "Above Horizon" : "Below Horizon")
                    .font(.caption2)
                    .foregroundColor(item.visibility.isAboveHorizon ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct DifficultyBadge: View {
    let score: Double

    var color: Color {
        if score >= 7 { return .green }
        if score >= 4 { return .yellow }
        return .red
    }

    var label: String {
        if score >= 7 { return "Easy" }
        if score >= 4 { return "Moderate" }
        if score > 0 { return "Hard" }
        return "Not Visible"
    }

    var body: some View {
        Text(String(format: "%.1f", score))
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

struct ConditionsView: View {
    let condition: ObservingCondition

    var cloudIcon: String {
        let cover = condition.cloudCover
        if cover < 0.1 { return "sun.max.fill" }
        if cover < 0.3 { return "cloud.sun.fill" }
        if cover < 0.6 { return "cloud.fill" }
        if cover < 0.9 { return "smoke.fill" }
        return "cloud.fog.fill"
    }

    var cloudColor: Color {
        let cover = condition.cloudCover
        if cover < 0.2 { return .green }
        if cover < 0.5 { return .yellow }
        return .red
    }

    var cloudDescription: String {
        let cover = condition.cloudCover
        if cover < 0.1 { return "Clear" }
        if cover < 0.3 { return "Mostly Clear" }
        if cover < 0.6 { return "Partly Cloudy" }
        if cover < 0.9 { return "Mostly Cloudy" }
        return "Overcast"
    }

    var moonIcon: String {
        let phase = condition.moonPhase
        if phase < 0.125 { return "moonphase.new.moon" }
        if phase < 0.25 { return "moonphase.waxing.crescent" }
        if phase < 0.375 { return "moonphase.first.quarter" }
        if phase < 0.5 { return "moonphase.waxing.gibbous" }
        if phase < 0.625 { return "moonphase.full.moon" }
        if phase < 0.75 { return "moonphase.waning.gibbous" }
        if phase < 0.875 { return "moonphase.last.quarter" }
        return "moonphase.waning.crescent"
    }

    var moonColor: Color {
        let phase = condition.moonPhase
        // New moon is best (dark), full moon is worst (bright)
        if phase < 0.25 || phase > 0.75 { return .green }
        if phase < 0.4 || phase > 0.6 { return .yellow }
        return .red
    }

    var moonDescription: String {
        let phase = condition.moonPhase
        if phase < 0.125 { return "New Moon" }
        if phase < 0.25 { return "Waxing Crescent" }
        if phase < 0.375 { return "First Quarter" }
        if phase < 0.5 { return "Waxing Gibbous" }
        if phase < 0.625 { return "Full Moon" }
        if phase < 0.75 { return "Waning Gibbous" }
        if phase < 0.875 { return "Last Quarter" }
        return "Waning Crescent"
    }

    var overallRating: String {
        let cloudPenalty = condition.cloudCover > 0.7
        let moonPenalty = condition.moonPhase > 0.4 && condition.moonPhase < 0.6

        if condition.cloudCover > 0.9 {
            return "Poor - Heavy cloud cover"
        } else if cloudPenalty && moonPenalty {
            return "Poor - Clouds & bright moon"
        } else if cloudPenalty {
            return "Fair - Cloud cover limiting visibility"
        } else if moonPenalty {
            return "Good - Bright moon may wash out faint objects"
        } else if condition.cloudCover < 0.2 && (condition.moonPhase < 0.25 || condition.moonPhase > 0.75) {
            return "Excellent - Clear skies, dark moon"
        } else {
            return "Good - Favorable conditions"
        }
    }

    var overallColor: Color {
        if condition.cloudCover > 0.9 { return .red }
        if condition.cloudCover > 0.7 { return .orange }
        if condition.moonPhase > 0.4 && condition.moonPhase < 0.6 { return .yellow }
        if condition.cloudCover < 0.2 && (condition.moonPhase < 0.25 || condition.moonPhase > 0.75) { return .green }
        return .green
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Condition indicators
            HStack(spacing: 20) {
                // Cloud cover
                VStack(spacing: 4) {
                    Image(systemName: cloudIcon)
                        .font(.title)
                        .foregroundColor(cloudColor)
                    Text(cloudDescription)
                        .font(.caption)
                    Text("\(Int(condition.cloudCover * 100))%")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)

                // Moon phase
                VStack(spacing: 4) {
                    Image(systemName: moonIcon)
                        .font(.title)
                        .foregroundColor(moonColor)
                    Text(moonDescription)
                        .font(.caption)
                    Text("\(Int(condition.moonPhase * 100))% illuminated")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }

            // Overall rating
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(overallColor)
                Text(overallRating)
                    .font(.subheadline)
                    .foregroundColor(overallColor)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
    }
}

public struct ObjectListItem: Identifiable {
    public var id: Int { object.id }
    public let object: SpaceObject
    public let visibility: ObjectVisibility
}

@MainActor
public class ObjectListViewModel: ObservableObject {
    @Published var items: [ObjectListItem] = []
    @Published var isLoading = false
    @Published var condition: ObservingCondition?
    @Published var locationName: String?
    @Published var currentLocation: UserLocation?

    private var locationTask: Task<Void, Never>?
    private var locationNameTask: Task<Void, Never>?
    private var locationManager = LocationManager.shared

    init() {
        // Observe location changes
        locationTask = Task {
            for await location in locationManager.$currentUserLocation.values {
                self.currentLocation = location
                if location != nil {
                   await loadData()
                }
            }
        }

        // Observe location name changes
        locationNameTask = Task {
            for await name in locationManager.$currentLocationName.values {
                self.locationName = name
            }
        }

        locationManager.requestPermission()
    }
    
    deinit {
        locationTask?.cancel()
        locationNameTask?.cancel()
    }

    func loadData() async {
        guard let location = locationManager.currentUserLocation else {
            // Can't load without location
            // Could set default or show error state
            return
        }
        
        isLoading = true
        defer { isLoading = false }

        // Fetch cloud cover
        var cloudCover = 0.0
        do {
            cloudCover = try await WeatherService.shared.fetchCurrentCloudCover(
                latitude: location.latitude,
                longitude: location.longitude
            )
        } catch {
            // Assume clear skies on error
        }

        // Calculate REAL moon phase
        let currentMoonPhase = AstronomyService.shared.calculateCurrentMoonPhase(date: Date())

        let condition = ObservingCondition(
            cloudCover: cloudCover,
            moonPhase: currentMoonPhase,
            lightPollution: 6, // Still default, would need settings for this
            date: Date(),
            location: location
        )
        self.condition = condition

        let catalog = CatalogService.shared.getAllObjects()
        items = catalog.map { object in
            let visibility = AstronomyService.shared.calculateVisibility(for: object, condition: condition)
            return ObjectListItem(object: object, visibility: visibility)
        }
    }

    func refresh() async {
        await loadData()
    }

    func sortedObjects(byBestForTonight: Bool) -> [ObjectListItem] {
        if byBestForTonight {
            return items.sorted {
                // Primary: Difficulty Score (High to Low)
                if abs($0.visibility.difficultyScore - $1.visibility.difficultyScore) > 0.01 {
                    return $0.visibility.difficultyScore > $1.visibility.difficultyScore
                }
                // Secondary: Altitude (High to Low)
                if abs($0.visibility.altitude - $1.visibility.altitude) > 0.1 {
                     return $0.visibility.altitude > $1.visibility.altitude
                }
                // Tertiary: ID (Low to High)
                return $0.object.id < $1.object.id
            }
        } else {
            return items.sorted { $0.object.id < $1.object.id }
        }
    }
}
