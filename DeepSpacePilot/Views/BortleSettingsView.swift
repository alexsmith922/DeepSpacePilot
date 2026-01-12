import SwiftUI
#if os(iOS)
import SafariServices
#endif

struct BortleSettingsView: View {
    @ObservedObject private var settings = BortleSettings.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingLightPollutionMap = false

    var body: some View {
        NavigationStack {
            List {
                // Tutorial Section
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text("What is the Bortle Scale?")
                                .font(.headline)
                        }

                        Text("The Bortle scale measures night sky darkness from 1 (darkest) to 9 (brightest). It was created by amateur astronomer John E. Bortle in 2001 to help observers evaluate their observing site.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("A lower Bortle number means darker skies and better conditions for viewing faint deep sky objects like galaxies and nebulae.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("About")
                }

                // How to measure Section
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.orange)
                                .font(.title2)
                            Text("How to Find Your Bortle Class")
                                .font(.headline)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            tipRow(number: "1", text: "Use a light pollution map to look up your location")
                            tipRow(number: "2", text: "On a clear night, try to see the Milky Way - if it's vivid with structure, you're likely Bortle 4 or darker")
                            tipRow(number: "3", text: "Count stars in the Little Dipper - all 7 visible means Bortle 4 or better")
                            tipRow(number: "4", text: "If you can see M31 (Andromeda) with naked eye, you're Bortle 5 or darker")
                        }
                    }
                    .padding(.vertical, 8)

                    Button(action: {
                        showingLightPollutionMap = true
                    }) {
                        HStack {
                            Image(systemName: "map.fill")
                                .foregroundColor(.blue)
                            Text("Open Light Pollution Map")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Tips")
                }

                // Bortle Scale Picker Section
                Section {
                    ForEach(BortleScale.allCases) { scale in
                        BortleScaleRow(
                            scale: scale,
                            isSelected: settings.currentScale == scale
                        ) {
                            settings.currentScale = scale
                        }
                    }
                } header: {
                    Text("Select Your Sky Conditions")
                } footer: {
                    Text("Choose the Bortle class that best matches your typical observing location. You can change this anytime when you travel to a darker site.")
                }
            }
            .navigationTitle("Light Pollution")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            #if os(iOS)
            .sheet(isPresented: $showingLightPollutionMap) {
                if let url = URL(string: "https://www.lightpollutionmap.info") {
                    BortleSafariView(url: url)
                        .ignoresSafeArea()
                }
            }
            #endif
        }
    }

    private func tipRow(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(number)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color.blue)
                .clipShape(Circle())
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct BortleScaleRow: View {
    let scale: BortleScale
    let isSelected: Bool
    let onSelect: () -> Void

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onSelect) {
                HStack(spacing: 12) {
                    // Selection indicator
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? scale.color : .secondary)
                        .font(.title3)

                    // Icon
                    Image(systemName: scale.icon)
                        .foregroundColor(scale.color)
                        .font(.title3)
                        .frame(width: 30)

                    // Text content
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("Bortle \(scale.rawValue)")
                                .font(.headline)
                            Text("-")
                                .foregroundColor(.secondary)
                            Text(scale.shortName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    // Expand/collapse button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Expandable description
            if isExpanded {
                Text(scale.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                    .padding(.leading, 74)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Safari View for Light Pollution Map

#if os(iOS)
struct BortleSafariView: UIViewControllerRepresentable {
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

#Preview {
    BortleSettingsView()
}
