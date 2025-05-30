import SwiftUI

// MARK: - ColorVariationsView
// Demonstrates color variations with SF Symbols:
// - Single color, multi-color palette styles
// - Linear and angular gradients applied to symbols
// - Animated color transitions on tap
// - Dynamic color changes

struct ColorVariationsView: View {
    @State private var primaryColor: Color = .blue
    @State private var secondaryColor: Color = .green
    @State private var animateGradient = false
    @State private var tapCount = 0

    /// Rotating color palette for tap-to-change demo
    private let colorPalette: [Color] = [
        .blue, .purple, .pink, .red, .orange, .yellow, .green, .mint, .cyan, .indigo
    ]

    var body: some View {
        DemoScrollView(title: "Color Variations") {
            singleColorSection
            multiColorSection
            gradientSection
            animatedTransitionsSection
            dynamicTapSection
        }
    }

    // MARK: - Single Color

    private var singleColorSection: some View {
        DemoCard(
            title: "Single Color",
            subtitle: ".foregroundStyle(.color)"
        ) {
            HStack(spacing: 16) {
                ForEach(
                    [Color.blue, .purple, .pink, .orange, .green],
                    id: \.self
                ) { color in
                    Image(systemName: "heart.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(color)
                        .accessibilityHidden(true)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Multi-Color Palette

    private var multiColorSection: some View {
        DemoCard(
            title: "Multi-Color Palette",
            subtitle: ".foregroundStyle(.blue, .green) on palette mode"
        ) {
            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 44))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.blue, .green)
                        Text("2 Colors")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        Image(systemName: "cloud.sun.rain.fill")
                            .font(.system(size: 44))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.cyan, .yellow, .blue)
                        Text("3 Colors")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        Image(systemName: "externaldrive.fill.badge.icloud")
                            .font(.system(size: 44))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.indigo, .mint, .purple)
                        Text("3 Colors")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)

                // Interactive color pickers
                VStack(alignment: .leading, spacing: 12) {
                    ColorPicker("Primary", selection: $primaryColor)
                    ColorPicker("Secondary", selection: $secondaryColor)
                }
                .font(.caption)

                Image(systemName: "person.3.fill")
                    .font(.system(size: 50))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(primaryColor, secondaryColor)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Custom palette preview")
            }
        }
    }

    // MARK: - Gradients

    private var gradientSection: some View {
        DemoCard(
            title: "Gradient Styles",
            subtitle: "Linear and angular gradients on symbols"
        ) {
            HStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange, .red],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .accessibilityHidden(true)
                    Text("Linear")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    Image(systemName: "hurricane")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            AngularGradient(
                                colors: [.blue, .purple, .pink, .red, .orange, .yellow, .green, .blue],
                                center: .center
                            )
                        )
                        .accessibilityHidden(true)
                    Text("Angular")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            RadialGradient(
                                colors: [.yellow, .orange],
                                center: .center,
                                startRadius: 0,
                                endRadius: 25
                            )
                        )
                        .accessibilityHidden(true)
                    Text("Radial")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Animated Transitions

    private var animatedTransitionsSection: some View {
        DemoCard(
            title: "Animated Color Transitions",
            subtitle: "Tap the symbol to animate gradient"
        ) {
            VStack(spacing: 16) {
                Button {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        animateGradient.toggle()
                    }
                } label: {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 70))
                        .foregroundStyle(
                            LinearGradient(
                                colors: animateGradient
                                    ? [.purple, .blue, .cyan]
                                    : [.orange, .red, .pink],
                                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                                endPoint: animateGradient ? .bottomTrailing : .topLeading
                            )
                        )
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Animate gradient")
                .accessibilityHint("Double tap to toggle gradient colors")

                Text("Tap the symbol")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Dynamic Tap Color

    private var dynamicTapSection: some View {
        DemoCard(
            title: "Dynamic Tint on Tap",
            subtitle: "Each tap cycles through colors"
        ) {
            VStack(spacing: 16) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        tapCount += 1
                    }
                } label: {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(colorPalette[tapCount % colorPalette.count])
                        .symbolEffect(.bounce, value: tapCount)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Cycle color")
                .accessibilityHint("Double tap to change to the next color")

                Text("Color: \(tapCount % colorPalette.count + 1) of \(colorPalette.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ColorVariationsView()
    }
}
