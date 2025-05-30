import SwiftUI

// MARK: - VariableSymbolsView
// Demonstrates variable value support for SF Symbols (iOS 17+)
// - Slider-driven variable values for battery, wifi, speaker
// - .symbolVariant() for fill / slash toggles
// - .symbolEffect(.variableColor) layered on variable symbols

struct VariableSymbolsView: View {
    @State private var batteryValue: Double = 0.7
    @State private var wifiValue: Double = 0.5
    @State private var speakerValue: Double = 0.8
    @State private var unifiedValue: Double = 0.5
    @State private var useFillVariant = true
    @State private var useSlashVariant = false
    @State private var isVariableColorActive = false

    var body: some View {
        DemoScrollView(title: "Variable Symbols") {
            unifiedSliderSection
            individualSymbolsSection
            symbolVariantsSection
            variableColorEffectSection
        }
    }

    // MARK: - Unified Slider
    // Controls all variable symbols at once

    private var unifiedSliderSection: some View {
        DemoCard(
            title: "Unified Variable Value",
            subtitle: "One slider controls all symbols below"
        ) {
            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    Image(systemName: "speaker.wave.3", variableValue: unifiedValue)
                        .font(.system(size: 36))
                        .foregroundStyle(.blue)

                    Image(systemName: "wifi", variableValue: unifiedValue)
                        .font(.system(size: 36))
                        .foregroundStyle(.green)

                    Image(systemName: "chart.bar.fill", variableValue: unifiedValue)
                        .font(.system(size: 36))
                        .foregroundStyle(.orange)

                    Image(systemName: "cellularbars", variableValue: unifiedValue)
                        .font(.system(size: 36))
                        .foregroundStyle(.purple)
                }
                .frame(maxWidth: .infinity)
                .animation(.easeInOut(duration: 0.2), value: unifiedValue)

                SliderControl(
                    label: "Value",
                    value: $unifiedValue,
                    range: 0...1,
                    tintColor: .blue,
                    formatStyle: .decimal(2)
                )
            }
        }
    }

    // MARK: - Individual Symbol Sliders
    // Each symbol has its own independent slider

    private var individualSymbolsSection: some View {
        DemoCard(
            title: "Individual Controls",
            subtitle: "Each symbol has its own value slider"
        ) {
            VStack(spacing: 20) {
                variableRow(
                    symbol: "battery.100percent",
                    label: "Battery",
                    value: $batteryValue,
                    color: batteryValue < 0.2 ? .red : (batteryValue < 0.5 ? .orange : .green)
                )

                Divider()

                variableRow(
                    symbol: "wifi",
                    label: "Wi-Fi Signal",
                    value: $wifiValue,
                    color: .blue
                )

                Divider()

                variableRow(
                    symbol: "speaker.wave.3",
                    label: "Volume",
                    value: $speakerValue,
                    color: .purple
                )
            }
        }
    }

    /// A single row with a variable symbol, label, and slider
    private func variableRow(
        symbol: String,
        label: String,
        value: Binding<Double>,
        color: Color
    ) -> some View {
        HStack(spacing: 16) {
            Image(systemName: symbol, variableValue: value.wrappedValue)
                .font(.system(size: 32))
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .animation(.easeInOut(duration: 0.2), value: value.wrappedValue)

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline.weight(.medium))

                Slider(value: value, in: 0...1)
                    .tint(color)

                Text("\(Int(value.wrappedValue * 100))%")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Symbol Variants
    // .symbolVariant(.fill) and .symbolVariant(.slash) toggles

    private var symbolVariantsSection: some View {
        DemoCard(
            title: "Symbol Variants",
            subtitle: ".symbolVariant(.fill) and .symbolVariant(.slash)"
        ) {
            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    symbolVariantColumn("heart", "heart")
                    symbolVariantColumn("bell", "bell")
                    symbolVariantColumn("mic", "mic")
                    symbolVariantColumn("phone", "phone")
                    symbolVariantColumn("bookmark", "bookmark")
                }
                .frame(maxWidth: .infinity)

                HStack {
                    Toggle("Fill", isOn: $useFillVariant)
                    Toggle("Slash", isOn: $useSlashVariant)
                }
                .font(.subheadline)
            }
        }
    }

    private func symbolVariantColumn(_ symbol: String, _ label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: symbol)
                .font(.system(size: 28))
                .symbolVariant(useFillVariant ? .fill : .none)
                .symbolVariant(useSlashVariant ? .slash : .none)
                .foregroundStyle(.tint)
                .animation(.easeInOut, value: useFillVariant)
                .animation(.easeInOut, value: useSlashVariant)
                .frame(height: 36)

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Variable Color Effect
    // layering .symbolEffect(.variableColor) on top of variable-value symbols

    private var variableColorEffectSection: some View {
        DemoCard(
            title: "Variable Color Effect",
            subtitle: "Animated color sweep on variable symbols"
        ) {
            VStack(spacing: 16) {
                HStack(spacing: 32) {
                    Image(systemName: "wifi", variableValue: 1.0)
                        .font(.system(size: 44))
                        .foregroundStyle(.blue)
                        .symbolEffect(
                            .variableColor.iterative.reversing,
                            isActive: isVariableColorActive
                        )

                    Image(systemName: "cellularbars", variableValue: 1.0)
                        .font(.system(size: 44))
                        .foregroundStyle(.green)
                        .symbolEffect(
                            .variableColor.cumulative,
                            isActive: isVariableColorActive
                        )

                    Image(systemName: "speaker.wave.3", variableValue: 1.0)
                        .font(.system(size: 44))
                        .foregroundStyle(.purple)
                        .symbolEffect(
                            .variableColor.iterative,
                            isActive: isVariableColorActive
                        )
                }
                .frame(maxWidth: .infinity)

                Toggle("Animate Variable Color", isOn: $isVariableColorActive)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    NavigationStack {
        VariableSymbolsView()
    }
}
