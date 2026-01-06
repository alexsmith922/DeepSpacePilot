import SwiftUI

public struct LogbookView: View {
    @ObservedObject private var logbook = LogbookService.shared
    @State private var showingClearConfirmation = false

    public init() {}

    public var body: some View {
        Group {
            if logbook.entries.isEmpty {
                emptyState
            } else {
                logbookList
            }
        }
        .navigationTitle("Logbook")
        .toolbar {
            if !logbook.entries.isEmpty {
                ToolbarItem(placement: .primaryAction) {
                    Button(role: .destructive) {
                        showingClearConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .alert("Clear Logbook?", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Clear All", role: .destructive) {
                logbook.clearAll()
            }
        } message: {
            Text("This will remove all \(logbook.seenCount) entries from your logbook. This cannot be undone.")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No Objects Logged")
                .font(.title2)
                .fontWeight(.semibold)

            Text("When you observe a deep sky object, mark it as seen to track your progress.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private var logbookList: some View {
        List {
            Section {
                ProgressCard(seen: logbook.seenCount, total: logbook.totalObjects)
            }

            Section("Observed Objects") {
                ForEach(logbook.entries.sorted(by: { $0.dateObserved > $1.dateObserved })) { entry in
                    if let object = CatalogService.shared.object(withId: entry.objectId) {
                        LogbookRowView(object: object, entry: entry)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    logbook.removeEntry(objectId: entry.objectId)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
    }
}

struct ProgressCard: View {
    let seen: Int
    let total: Int

    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(seen) / Double(total)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Progress")
                    .font(.headline)
                Spacer()
                Text("\(seen) / \(total)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            ProgressView(value: percentage)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))

            Text(String(format: "%.1f%% Complete", percentage * 100))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct LogbookRowView: View {
    let object: SpaceObject
    let entry: LogbookEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(object.name)
                        .font(.headline)
                    if let commonName = object.commonName {
                        Text("- \(commonName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Text(object.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)

                Text(entry.dateObserved, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        LogbookView()
    }
}
