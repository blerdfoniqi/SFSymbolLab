import SwiftUI

// MARK: - PlaygroundView
// An interactive sandbox for composing an SF Symbol configuration.
// The preview is PINNED to the top so it stays visible while every control is
// adjusted. Discrete options (rendering mode, animation, quick symbol) are
// available both as always-visible menu chips and via a long-press context menu
// on the symbol itself; continuous controls (size, variable value, colors) sit
// directly beneath the preview — no scrolling away from what you're editing.

struct PlaygroundView: View {
    @State private var symbolName: String = "star.fill"
    @State private var fontSize: Double = 64
    @State private var variableValue: Double = 1.0
    @State private var selectedMode: RenderingModeOption = .monochrome
    @State private var selectedEffect: AnimationEffectOption = .none
    @State private var primaryColor: Color = .blue
    @State private var secondaryColor: Color = .green
    @State private var tertiaryColor: Color = .orange
    @State private var isEffectActive = true
    @State private var triggerCount = 0

    /// Commonly used symbols for quick selection
    private let quickSymbols = [
        "star.fill", "heart.fill", "cloud.sun.rain.fill",
        "wifi", "speaker.wave.3", "battery.100percent",
        "flame.fill", "bolt.fill", "globe.americas.fill",
        "bell.fill", "camera.fill", "airplane"
    ]

    var body: some View {
        VStack(spacing: 0) {
            pinnedPreview
            Divider()
            ScrollView {
                controls.padding()
            }
        }
        .navigationTitle("Playground")
        #if os(iOS) || os(visionOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Pinned Preview (always visible)

    private var pinnedPreview: some View {
        VStack(spacing: 12) {
            symbolPreview
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .contentShape(.rect)
                .contextMenu { configMenu }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Preview of \(symbolName)")
                .accessibilityHint("Long press for rendering, animation and symbol options")

            Text(symbolName)
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
                .lineLimit(1)

            // Always-visible discrete menus (mirror the long-press context menu).
            HStack(spacing: 10) {
                Menu { quickSymbolItems } label: {
                    menuChip(title: "Symbol", value: symbolName, icon: "square.grid.2x2")
                }
                Menu { renderingModePicker } label: {
                    menuChip(title: "Mode", value: selectedMode.shortTitle, icon: "paintpalette")
                }
                Menu { animationPicker } label: {
                    menuChip(title: "Effect", value: selectedEffect.title, icon: "wand.and.stars")
                }
                
            }

            effectControl
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.bar)
    }

    /// Whether the entered name resolves to a real SF Symbol on this platform.
    private var symbolExists: Bool { SymbolValidator.exists(symbolName) }

    /// Builds the symbol image with all applied configurations.
    /// Falls back to a placeholder when the name doesn't resolve to a symbol.
    @ViewBuilder
    private var symbolPreview: some View {
        if symbolExists {
            let baseImage = Image(systemName: symbolName, variableValue: variableValue)
                .font(.system(size: fontSize))
                .symbolRenderingMode(selectedMode.renderingMode)
                .foregroundStyle(primaryColor, secondaryColor, tertiaryColor)

            switch selectedEffect {
            case .none:
                baseImage
            case .bounce:
                baseImage.symbolEffect(.bounce, value: triggerCount)
            case .pulse:
                baseImage.symbolEffect(.pulse, isActive: isEffectActive)
            case .scale:
                baseImage.symbolEffect(.scale.up, isActive: isEffectActive)
            case .variableColor:
                baseImage.symbolEffect(.variableColor.iterative.reversing, isActive: isEffectActive)
            }
        } else {
            Image(systemName: "questionmark.square.dashed")
                .font(.system(size: fontSize))
                .foregroundStyle(.secondary)
                .accessibilityLabel("Unknown symbol")
        }
    }

    // MARK: - Menu / Context-menu content

    @ViewBuilder
    private var configMenu: some View {
        renderingModePicker
        animationPicker
        Menu {
            quickSymbolItems
        } label: {
            Label("Quick Symbol", systemImage: "square.grid.2x2")
        }
        Divider()
        Button(role: .destructive, action: reset) {
            Label("Reset", systemImage: "arrow.counterclockwise")
        }
    }

    private var renderingModePicker: some View {
        ForEach(RenderingModeOption.allCases) { mode in
            Button {
                withAnimation { selectedMode = mode }
            } label: {
                Text(mode.title).tag(mode)
            }
        }
    }

    private var animationPicker: some View {
        ForEach(AnimationEffectOption.allCases) { effect in
            Button {
                withAnimation { selectedEffect = effect }
            } label: {
                Label(effect.title, systemImage: effect.icon).tag(effect)
            }
        }
    }

    @ViewBuilder
    private var quickSymbolItems: some View {
        ForEach(quickSymbols, id: \.self) { symbol in
            Button {
                withAnimation { symbolName = symbol }
            } label: {
                Label(symbol, systemImage: symbol)
            }
        }
    }

    // MARK: - Contextual effect control (only shown when relevant)

    @ViewBuilder
    private var effectControl: some View {
        switch selectedEffect {
        case .none:
            EmptyView()
        case .bounce:
            Button {
                triggerCount += 1
            } label: {
                Label("Trigger Bounce", systemImage: "play.fill")
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(.blue)
        default:
            Toggle(isOn: $isEffectActive) {
                Label("Animate", systemImage: "play.circle")
            }
            .toggleStyle(.button)
            .controlSize(.small)
        }
    }

    // MARK: - Scrollable controls (compact, directly under the preview)

    private var controls: some View {
        VStack(spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                controlLabel("Symbol name", icon: "character.cursor.ibeam")
                TextField("Enter SF Symbol name", text: $symbolName)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    #if os(iOS) || os(visionOS)
                    .textInputAutocapitalization(.never)
                    #endif
                if !symbolExists {
                    Label("No SF Symbol named “\(symbolName)”", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .accessibilityLabel("No SF Symbol named \(symbolName)")
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                controlLabel("Size", icon: "textformat.size")
                SliderControl(
                    label: "Size",
                    value: $fontSize,
                    range: 20...120,
                    step: 2,
                    tintColor: .blue,
                    formatStyle: .points
                )
            }

            VStack(alignment: .leading, spacing: 6) {
                controlLabel("Variable value", icon: "slider.horizontal.below.square.filled.and.square")
                SliderControl(
                    label: "Value",
                    value: $variableValue,
                    range: 0...1,
                    tintColor: .green,
                    formatStyle: .decimal(2)
                )
                Text("Only affects symbols with variable-value support")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                controlLabel("Colors", icon: "paintpalette")
                HStack(spacing: 16) {
                    colorWell("Primary", $primaryColor)
                    colorWell("Secondary", $secondaryColor)
                    colorWell("Tertiary", $tertiaryColor)
                }
            }
        }
    }

    // MARK: - Small building blocks

    private func controlLabel(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
    }

    private func colorWell(_ title: String, _ binding: Binding<Color>) -> some View {
        VStack(spacing: 4) {
            ColorPicker(title, selection: binding, supportsOpacity: false)
                .labelsHidden()
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func menuChip(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.subheadline)
            Text(title)
                .font(.caption2.weight(.semibold))
            Text(value)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
        .foregroundStyle(.primary)
    }

    private func reset() {
        withAnimation {
            symbolName = "star.fill"
            fontSize = 64
            variableValue = 1.0
            selectedMode = .monochrome
            selectedEffect = .none
            primaryColor = .blue
            secondaryColor = .green
            tertiaryColor = .orange
            isEffectActive = true
        }
    }
}

#Preview {
    NavigationStack {
        PlaygroundView()
    }
}
