import SwiftUI
#if os(iOS)
import UIKit
import SafariServices
internal import Combine
#elseif os(macOS)
import AppKit
#endif

public struct ObjectDetailView: View {
    let object: SpaceObject
    let visibility: ObjectVisibility

    @StateObject private var viewModel: ObjectDetailViewModel
    @State private var showingLogConfirmation = false
    @State private var showingFullScreenImage = false
    @State private var showingWikipedia = false

    public init(object: SpaceObject, visibility: ObjectVisibility) {
        self.object = object
        self.visibility = visibility
        _viewModel = StateObject(wrappedValue: ObjectDetailViewModel(object: object))
    }

    private var wikipediaURL: URL? {
        let searchTerm = object.commonName ?? "Messier \(object.id)"
        let encoded = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        return URL(string: "https://en.wikipedia.org/wiki/\(encoded)")
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Object Image (tappable)
                objectImage
                    .onTapGesture {
                        if viewModel.imageURL != nil {
                            showingFullScreenImage = true
                        }
                    }

                // Current Visibility (moved above Object Info)
                visibilitySection

                // Object Info
                objectInfoSection

                // Mark as Seen Button
                markAsSeenButton
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 40) // Extra bottom padding for safe area
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .contentMargins(.bottom, 20, for: .scrollContent)
        .navigationTitle(object.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showingFullScreenImage) {
            FullScreenImageView(
                imageURL: viewModel.imageURL,
                objectName: object.commonName ?? object.name,
                onWikipediaTap: {
                    showingFullScreenImage = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showingWikipedia = true
                    }
                }
            )
        }
        .sheet(isPresented: $showingWikipedia) {
            if let url = wikipediaURL {
                SafariView(url: url)
            }
        }
        #endif
        .alert("Logged!", isPresented: $showingLogConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("\(object.name) has been added to your logbook.")
        }
        .onAppear {
            viewModel.startUpdating()
        }
        .onDisappear {
            viewModel.stopUpdating()
        }
    }

    private var objectImage: some View {
        ZStack {
            // Background
            Color.black

            // Image content
            if let url = viewModel.imageURL {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        Image(systemName: iconForType(object.type))
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                    } else {
                        ProgressView()
                            .tint(.white)
                    }
                }
            } else {
                Image(systemName: iconForType(object.type))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(height: 300)
        .clipped()
        .overlay(alignment: .bottom) {
            // Label overlay - positioned after clipping to ensure visibility
            ZStack(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)

                Text(object.commonName ?? object.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }
        .cornerRadius(16)
    }

    private var objectInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Object Information")
            .font(.headline)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                InfoCard(title: "Type", value: object.type.rawValue)
                InfoCard(title: "Constellation", value: object.constellation)
                InfoCard(title: "Magnitude", value: String(format: "%.1f", object.visualMagnitude))
                InfoCard(title: "Base Difficulty", value: "\(object.difficulty)/10")
            }

            Divider()

            Text("Coordinates (J2000)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Text("RA: \(formatRA(object.rightAscension))")
                    .font(.system(.caption, design: .monospaced))
                Spacer()
                Text("Dec: \(formatDec(object.declination))")
                    .font(.system(.caption, design: .monospaced))
            }
            .minimumScaleFactor(0.8)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }

    private var visibilitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Current Visibility")
                    .font(.headline)
                Spacer()
                Text("Live")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                InfoCard(
                    title: "Altitude",
                    value: String(format: "%.1f\u{00B0}", viewModel.currentVisibility?.altitude ?? visibility.altitude)
                )
                InfoCard(
                    title: "Azimuth",
                    value: String(format: "%.1f\u{00B0}", viewModel.currentVisibility?.azimuth ?? visibility.azimuth)
                )
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Visibility Score")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f / 10", viewModel.currentVisibility?.difficultyScore ?? visibility.difficultyScore))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(scoreColor(viewModel.currentVisibility?.difficultyScore ?? visibility.difficultyScore))
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Status")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text((viewModel.currentVisibility?.isAboveHorizon ?? visibility.isAboveHorizon) ? "Above Horizon" : "Below Horizon")
                        .font(.headline)
                        .foregroundColor((viewModel.currentVisibility?.isAboveHorizon ?? visibility.isAboveHorizon) ? .green : .red)
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }

    private var markAsSeenButton: some View {
        Button(action: {
            LogbookService.shared.markAsSeen(objectId: object.id)
            showingLogConfirmation = true
        }) {
            HStack {
                Image(systemName: LogbookService.shared.hasSeen(objectId: object.id) ? "checkmark.circle.fill" : "plus.circle")
                Text(LogbookService.shared.hasSeen(objectId: object.id) ? "Already Logged" : "Mark as Seen")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(LogbookService.shared.hasSeen(objectId: object.id) ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(LogbookService.shared.hasSeen(objectId: object.id))
    }

    private func iconForType(_ type: SpaceObjectType) -> String {
        switch type {
        case .galaxy: return "hurricane"
        case .nebula: return "cloud.fill"
        case .openCluster: return "star.fill"
        case .globularCluster: return "circle.grid.3x3.fill"
        case .planetaryNebula: return "circle.dashed"
        case .supernovaRemnant: return "burst.fill"
        case .star: return "star.fill"
        case .other: return "questionmark.circle"
        }
    }

    private func scoreColor(_ score: Double) -> Color {
        if score >= 7 { return .green }
        if score >= 4 { return .yellow }
        return .red
    }

    private func formatRA(_ hours: Double) -> String {
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        let s = ((hours - Double(h)) * 60 - Double(m)) * 60
        return String(format: "%02dh %02dm %04.1fs", h, m, s)
    }

    private func formatDec(_ degrees: Double) -> String {
        let sign = degrees >= 0 ? "+" : "-"
        let abs = Swift.abs(degrees)
        let d = Int(abs)
        let m = Int((abs - Double(d)) * 60)
        let s = ((abs - Double(d)) * 60 - Double(m)) * 60
        return String(format: "%@%02d\u{00B0} %02d' %04.1f\"", sign, d, m, s)
    }
}

struct InfoCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        #if os(iOS)
        .background(Color(UIColor.systemBackground))
        #else
        .background(Color(NSColor.windowBackgroundColor))
        #endif
        .cornerRadius(8)
    }
}

@MainActor
class ObjectDetailViewModel: ObservableObject {
    let object: SpaceObject
    @Published var currentVisibility: ObjectVisibility?
    @Published var imageURL: URL?

    private var timer: Timer?

    init(object: SpaceObject) {
        self.object = object
    }

    func startUpdating() {
        updateVisibility()
        fetchImage()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateVisibility()
            }
        }
    }
    
    private func fetchImage() {
        Task {
            // Try multiple search queries in order of likelihood to find a good image
            let queries = buildSearchQueries()

            for query in queries {
                do {
                    if let url = try await WikiImageService.shared.fetchImageURL(for: query) {
                        self.imageURL = url
                        return // Found an image, stop searching
                    }
                } catch {
                    // Continue to next query
                    continue
                }
            }
            print("No image found for \(object.name) after trying all queries")
        }
    }

    private func buildSearchQueries() -> [String] {
        var queries: [String] = []

        // 1. Try common name first (e.g., "Andromeda Galaxy") - best Wikipedia match
        if let commonName = object.commonName {
            queries.append(commonName)
        }

        // 2. Try "Messier X" format (e.g., "Messier 31")
        queries.append("Messier \(object.id)")

        // 3. Try the catalog name (e.g., "M31")
        queries.append(object.name)

        // 4. Try common name + type for disambiguation (e.g., "Andromeda Galaxy")
        if let commonName = object.commonName, !commonName.lowercased().contains(object.type.rawValue.lowercased()) {
            queries.append("\(commonName) \(object.type.rawValue)")
        }

        return queries
    }

    func stopUpdating() {
        timer?.invalidate()
        timer = nil
    }

    private func updateVisibility() {
        guard let location = LocationManager.shared.currentUserLocation else {
            // Cannot update visibility without location
            // Could return or set to nil to indicate "Waiting for location..."
            return
        }

        let condition = ObservingCondition(
            cloudCover: 0.0,
            moonPhase: AstronomyService.shared.calculateCurrentMoonPhase(date: Date()),
            lightPollution: 6,
            date: Date(),
            location: location
        )

        currentVisibility = AstronomyService.shared.calculateVisibility(for: object, condition: condition)
    }
}

// MARK: - Full Screen Image View

#if os(iOS)
struct FullScreenImageView: View {
    let imageURL: URL?
    let objectName: String
    let onWikipediaTap: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if let url = imageURL {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if phase.error != nil {
                            VStack {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                Text("Failed to load image")
                                    .foregroundColor(.gray)
                            }
                        } else {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                }
            }
            .navigationTitle(objectName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        onWikipediaTap()
                    } label: {
                        HStack {
                            Image(systemName: "book.fill")
                            Text("Wikipedia")
                        }
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black.opacity(0.8), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Safari View

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        let safari = SFSafariViewController(url: url, configuration: config)
        safari.preferredControlTintColor = .systemBlue
        return safari
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
#endif
