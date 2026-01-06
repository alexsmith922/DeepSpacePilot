import Foundation
public import Combine

public struct LogbookEntry: Codable, Identifiable {
    public let id: UUID
    public let objectId: Int
    public let dateObserved: Date
    public let notes: String?

    public init(objectId: Int, dateObserved: Date = Date(), notes: String? = nil) {
        self.id = UUID()
        self.objectId = objectId
        self.dateObserved = dateObserved
        self.notes = notes
    }
}

public class LogbookService: ObservableObject {
    public static let shared = LogbookService()

    private let userDefaultsKey = "DeepSpacePilot.Logbook"

    @Published public private(set) var entries: [LogbookEntry] = []

    private init() {
        loadEntries()
    }

    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            entries = []
            return
        }

        do {
            entries = try JSONDecoder().decode([LogbookEntry].self, from: data)
        } catch {
            entries = []
        }
    }

    private func saveEntries() {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            // Silently fail - in production would log error
        }
    }

    public func markAsSeen(objectId: Int, notes: String? = nil) {
        // Don't add duplicates
        guard !hasSeen(objectId: objectId) else { return }

        let entry = LogbookEntry(objectId: objectId, notes: notes)
        entries.append(entry)
        saveEntries()
    }

    public func hasSeen(objectId: Int) -> Bool {
        entries.contains { $0.objectId == objectId }
    }

    public func entry(for objectId: Int) -> LogbookEntry? {
        entries.first { $0.objectId == objectId }
    }

    public func removeEntry(objectId: Int) {
        entries.removeAll { $0.objectId == objectId }
        saveEntries()
    }

    public func clearAll() {
        entries = []
        saveEntries()
    }

    public var seenCount: Int {
        entries.count
    }

    public var totalObjects: Int {
        CatalogService.shared.getAllObjects().count
    }
}
