import SwiftUI

// MARK: - SliderControl
// Reusable labeled slider with formatted value display.
// Extracts the repeated VStack { Slider; Text } pattern from SymbolTransformationsView
// and VariableSymbolsView.

struct SliderControl: View {
    let label: String
    @Binding var value: Double
    var range: ClosedRange<Double> = 0...1
    var step: Double?
    var tintColor: Color = .blue
    var formatStyle: ValueFormat = .integer

    enum ValueFormat {
        case integer
        case decimal(Int)
        case percent
        case degrees
        case multiplier
        case points
    }

    var body: some View {
        VStack(spacing: 4) {
            if let step {
                Slider(value: $value, in: range, step: step)
                    .tint(tintColor)
            } else {
                Slider(value: $value, in: range)
                    .tint(tintColor)
            }

            Text(formattedValue)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(formattedValue)
    }

    private var formattedValue: String {
        switch formatStyle {
        case .integer:
            "\(label): \(Int(value))"
        case .decimal(let places):
            "\(label): \(String(format: "%.\(places)f", value))"
        case .percent:
            "\(Int(value * 100))%"
        case .degrees:
            "\(Int(value))°"
        case .multiplier:
            "\(label): \(String(format: "%.1f", value))x"
        case .points:
            "\(Int(value)) pt"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SliderControl(
            label: "Rotation",
            value: .constant(45),
            range: 0...360,
            formatStyle: .degrees
        )

        SliderControl(
            label: "Scale",
            value: .constant(1.5),
            range: 0.3...2.5,
            tintColor: .purple,
            formatStyle: .multiplier
        )
    }
    .padding()
}
