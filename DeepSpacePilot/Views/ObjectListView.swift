import SwiftUI
public import Combine

public struct ObjectListView: View {
    @StateObject private var viewModel = ObjectListViewModel()
    @State private var sortByBestForTonight = true

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sortedObjects(byBestForTonight: sortByBestForTonight)) { item in
                    NavigationLink(destination: ObjectDetailView(object: item.object, visibility: item.visibility)) {
                        ObjectRowView(item: item)
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
    
    private var locationTask: Task<Void, Never>?
    private var locationManager = LocationManager.shared
    
    init() {
        // Observe location changes
        locationTask = Task {
            for await _ in locationManager.$currentUserLocation.values {
                if locationManager.currentUserLocation != nil {
                   await loadData()
                }
            }
        }
        locationManager.requestPermission()
    }
    
    deinit {
        locationTask?.cancel()
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
            return items.sorted { $0.visibility.difficultyScore > $1.visibility.difficultyScore }
        } else {
            return items.sorted { $0.object.id < $1.object.id }
        }
    }
}
