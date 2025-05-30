import SwiftUI

// MARK: - SymbolAnimationsView
// Demonstrates all iOS 17+ SF Symbol animation effects:
// - Trigger-based: bounce, pulse (activated by button tap)
// - Continuous: variableColor, pulse running indefinitely
// - State-driven: appear / disappear transitions
// - Replace: smooth transition between two different symbols

struct SymbolAnimationsView: View {
    // Trigger counters for discrete animations
    @State private var bounceCount = 0
    @State private var pulseCount = 0

    // State for appear/disappear
    @State private var isSymbolVisible = true

    // State for replace animation
    @State private var useAlternateSymbol = false

    // Continuous animation toggle
    @State private var isContinuousActive = true

    var body: some View {
        DemoScrollView(title: "Symbol Animations") {
            triggerAnimationsSection
            continuousAnimationsSection
            appearDisappearSection
            replaceAnimationSection
            combinedEffectsSection
        }
    }

    // MARK: - Trigger-Based Animations
    // Bounce and Pulse — each triggered by a tap (value change)

    private var triggerAnimationsSection: some View {
        DemoCard(
            title: "Trigger-Based Effects",
            subtitle: "Tap each symbol to trigger the effect"
        ) {
            HStack(spacing: 0) {
                // Bounce
                Button {
                    bounceCount += 1
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.blue)
                            .symbolEffect(.bounce, value: bounceCount)
                            .frame(width: 60, height: 60)
                        Text("Bounce")
                            .font(.caption.weight(.medium))
                        Text("Tap me")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Bounce effect")
                .accessibilityHint("Double tap to trigger bounce animation")

                Spacer()

                // Pulse (trigger)
                Button {
                    pulseCount += 1
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.orange)
                            .symbolEffect(.pulse, value: pulseCount)
                            .frame(width: 60, height: 60)
                        Text("Pulse")
                            .font(.caption.weight(.medium))
                        Text("Tap me")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Pulse effect")
                .accessibilityHint("Double tap to trigger pulse animation")

                Spacer()

                // Bounce Up variant
                Button {
                    bounceCount += 1
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.yellow)
                            .symbolEffect(.bounce.up, value: bounceCount)
                            .frame(width: 60, height: 60)
                        Text("Bounce Up")
                            .font(.caption.weight(.medium))
                        Text("Tap me")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Bounce up effect")
                .accessibilityHint("Double tap to trigger upward bounce animation")
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Continuous Animations
    // variableColor and pulse running indefinitely

    private var continuousAnimationsSection: some View {
        DemoCard(
            title: "Continuous Effects",
            subtitle: "Animations that run indefinitely"
        ) {
            VStack(spacing: 16) {
                HStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Image(systemName: "wifi")
                            .font(.system(size: 44))
                            .foregroundStyle(.blue)
                            .symbolEffect(
                                .variableColor.iterative.reversing,
                                isActive: isContinuousActive
                            )
                            .accessibilityHidden(true)
                        Text("Variable Color")
                            .font(.caption2)
                    }

                    VStack(spacing: 8) {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .font(.system(size: 44))
                            .foregroundStyle(.green)
                            .symbolEffect(.pulse, isActive: isContinuousActive)
                            .accessibilityHidden(true)
                        Text("Pulse")
                            .font(.caption2)
                    }

                    VStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.red)
                            .symbolEffect(
                                .variableColor.cumulative,
                                isActive: isContinuousActive
                            )
                            .accessibilityHidden(true)
                        Text("Cumulative")
                            .font(.caption2)
                    }
                }
                .frame(maxWidth: .infinity)

                Toggle("Active", isOn: $isContinuousActive)
                    .font(.subheadline)
            }
        }
    }

    // MARK: - Appear / Disappear
    // Toggling symbol visibility with .transition(.symbolEffect)

    private var appearDisappearSection: some View {
        DemoCard(
            title: "Appear & Disappear",
            subtitle: "Toggle visibility with symbol effect transitions"
        ) {
            VStack(spacing: 16) {
                HStack(spacing: 32) {
                    if isSymbolVisible {
                        Image(systemName: "cloud.sun.rain.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.cyan, .yellow, .blue)
                            .symbolRenderingMode(.palette)
                            .transition(.symbolEffect(.appear))
                            .accessibilityLabel("Weather symbol")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 70)

                Button {
                    withAnimation {
                        isSymbolVisible.toggle()
                    }
                } label: {
                    Label(
                        isSymbolVisible ? "Disappear" : "Appear",
                        systemImage: isSymbolVisible ? "eye.slash" : "eye"
                    )
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(isSymbolVisible ? .red : .green)
            }
        }
    }

    // MARK: - Replace Animation
    // Smoothly replace one symbol with another using .contentTransition(.symbolEffect(.replace))

    private var replaceAnimationSection: some View {
        DemoCard(
            title: "Symbol Replace",
            subtitle: ".contentTransition(.symbolEffect(.replace))"
        ) {
            VStack(spacing: 16) {
                Image(systemName: useAlternateSymbol ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(useAlternateSymbol ? .orange : .green)
                    .contentTransition(.symbolEffect(.replace))
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel(useAlternateSymbol ? "Pause" : "Play")

                Button {
                    withAnimation {
                        useAlternateSymbol.toggle()
                    }
                } label: {
                    Text(useAlternateSymbol ? "Show Play" : "Show Pause")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    // MARK: - Combined Effects
    // Showing multiple effects layered together

    private var combinedEffectsSection: some View {
        DemoCard(
            title: "Combined Effects",
            subtitle: "Multiple effects applied together"
        ) {
            VStack(spacing: 16) {
                HStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 44))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .symbolEffect(.pulse, isActive: true)
                            .accessibilityHidden(true)
                        Text("Gradient + Pulse")
                            .font(.caption2)
                    }

                    VStack(spacing: 8) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 44))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.purple, .yellow)
                            .symbolEffect(
                                .variableColor.iterative,
                                isActive: true
                            )
                            .accessibilityHidden(true)
                        Text("Palette + VarColor")
                            .font(.caption2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SymbolAnimationsView()
    }
}
