import SwiftUI

// MARK: - ContentView
// Root view of the app, displaying a NavigationStack with a list of all demo sections.
// Each section navigates to its corresponding demo view.

struct ContentView: View {
    @State private var path: [DemoSection] = ContentView.initialPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                // App header section
                Section {
                    headerView
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

                // Demo sections
                Section("Demos") {
                    ForEach(DemoSection.allCases) { section in
                        NavigationLink(value: section) {
                            demoRow(for: section)
                        }
                    }
                }
            }
            .navigationTitle("SF Symbol Lab")
            .navigationDestination(for: DemoSection.self) { section in
                destinationView(for: section)
            }
        }
    }

    /// Screenshot / UI-automation hook: launch with the `SCREENSHOT_SECTION`
    /// environment variable set to a `DemoSection.rawValue` to open that screen
    /// directly. Debug-only — stripped from release builds.
    private static func initialPath() -> [DemoSection] {
        #if DEBUG
        if let raw = ProcessInfo.processInfo.environment["SCREENSHOT_SECTION"],
           let section = DemoSection(rawValue: raw) {
            return [section]
        }
        #endif
        return []
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: 12) {
            // Animated hero symbols
            HStack(spacing: 16) {
                Image(systemName: "star.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.yellow)
                    .symbolEffect(.pulse, isActive: true)

                Image(systemName: "paintpalette.fill")
                    .font(.system(size: 36))
                    .symbolRenderingMode(.multicolor)

                Image(systemName: "wand.and.stars")
                    .font(.system(size: 28))
                    .foregroundStyle(.purple)
                    .symbolEffect(.variableColor.iterative, isActive: true)
            }
            .padding(.top, 8)

            Text("Explore everything SF Symbols can do in SwiftUI")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    // MARK: - Demo Row

    private func demoRow(for section: DemoSection) -> some View {
        HStack(spacing: 14) {
            Image(systemName: section.icon)
                .font(.title2)
                .foregroundStyle(section.accentColor)
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(section.title)
                    .font(.subheadline.weight(.semibold))

                Text(section.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Navigation Destination

    private func destinationView(for section: DemoSection) -> some View {
        section.destination
    }
}

#Preview {
    ContentView()
}
