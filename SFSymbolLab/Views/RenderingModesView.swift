import SwiftUI

// MARK: - RenderingModesView
// Demonstrates the four SF Symbol rendering modes:
// .monochrome, .hierarchical, .palette, .multicolor
// Includes a live interactive picker to switch between modes.

struct RenderingModesView: View {
    @State private var selectedMode: RenderingModeOption = .monochrome

    /// Symbols that look great across all rendering modes
    private let showcaseSymbols = [
        "cloud.sun.rain.fill",
        "chart.bar.doc.horizontal.fill",
        "person.crop.circle.badge.checkmark",
        "externaldrive.fill.badge.icloud"
    ]

    var body: some View {
        DemoScrollView(title: "Rendering Modes") {
            interactiveModeSelector
            modeComparisonGrid
            detailedExamples
        }
    }

    // MARK: - Interactive Mode Selector
    // Allows the user to pick a rendering mode and see the result live.

    private var interactiveModeSelector: some View {
        DemoCard(
            title: "Interactive Mode Selector",
            subtitle: "Pick a rendering mode to see it applied live"
        ) {
            VStack(spacing: 16) {
                // Live preview symbol
                Image(systemName: "cloud.sun.rain.fill")
                    .font(.system(size: 80))
                    .symbolRenderingMode(selectedMode.renderingMode)
                    .foregroundStyle(.blue, .yellow, .cyan)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .contentTransition(.symbolEffect(.replace))
                    .animation(.easeInOut, value: selectedMode)

                // Rendering mode picker
                Picker("Rendering Mode", selection: $selectedMode) {
                    ForEach(RenderingModeOption.allCases) { mode in
                        Text(mode.shortTitle).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                // Description of selected mode
                Text(selectedMode.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .animation(.easeInOut, value: selectedMode)
            }
        }
    }

    // MARK: - Mode Comparison Grid
    // Shows the same symbol in all four modes side by side.

    private var modeComparisonGrid: some View {
        DemoCard(
            title: "Side-by-Side Comparison",
            subtitle: "Same symbol in all four rendering modes"
        ) {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2),
                spacing: 16
            ) {
                ForEach(RenderingModeOption.allCases) { mode in
                    VStack(spacing: 8) {
                        Image(systemName: "chart.bar.doc.horizontal.fill")
                            .font(.system(size: 44))
                            .symbolRenderingMode(mode.renderingMode)
                            .foregroundStyle(.blue, .green, .orange)
                            .frame(height: 60)

                        Text(mode.title)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.background)
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    )
                }
            }
        }
    }

    // MARK: - Detailed Examples
    // Shows specific code usage patterns for each rendering mode using data-driven approach.

    private var detailedExamples: some View {
        VStack(spacing: 16) {
            ForEach(RenderingModeOption.allCases) { mode in
                let colors = paletteColors(for: mode)
                DemoCard(
                    title: mode.title,
                    subtitle: ".symbolRenderingMode(.\(mode.rawValue))"
                ) {
                    HStack(spacing: 20) {
                        ForEach(showcaseSymbols, id: \.self) { symbol in
                            Image(systemName: symbol)
                                .font(.system(size: 32))
                                .symbolRenderingMode(mode.renderingMode)
                                .foregroundStyle(colors.primary, colors.secondary, colors.tertiary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private struct SymbolColors {
        let primary: Color
        let secondary: Color
        let tertiary: Color
    }

    /// Returns the appropriate foreground colors for each rendering mode
    private func paletteColors(for mode: RenderingModeOption) -> SymbolColors {
        switch mode {
        case .monochrome:
            return SymbolColors(primary: .blue, secondary: .blue, tertiary: .blue)
        case .hierarchical:
            return SymbolColors(primary: .purple, secondary: .purple, tertiary: .purple)
        case .palette:
            return SymbolColors(primary: .blue, secondary: .green, tertiary: .orange)
        case .multicolor:
            return SymbolColors(primary: .primary, secondary: .primary, tertiary: .primary)
        }
    }
}

#Preview {
    NavigationStack {
        RenderingModesView()
    }
}
