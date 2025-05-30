import SwiftUI

// MARK: - BestPracticesView
// Educational section covering:
// - Performance tips for SF Symbol usage
// - When to use which rendering mode
// - Accessibility considerations (labels, traits, Dynamic Type)
// - Dark mode support and adaptive colors

struct BestPracticesView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        DemoScrollView(title: "Best Practices") {
            performanceSection
            renderingModeGuideSection
            accessibilitySection
            dynamicTypeSection
            darkModeSection
        }
    }

    // MARK: - Performance Tips

    private var performanceSection: some View {
        DemoCard(
            title: "⚡ Performance Tips",
            subtitle: "Optimize SF Symbol usage in your apps"
        ) {
            VStack(alignment: .leading, spacing: 14) {
                TipRow(
                    icon: "checkmark.circle.fill",
                    color: .green,
                    title: "Prefer symbolRenderingMode()",
                    detail: "Apply rendering mode once at a container level " +
                            "rather than on each symbol individually."
                )

                TipRow(
                    icon: "checkmark.circle.fill",
                    color: .green,
                    title: "Cache symbol configurations",
                    detail: "Avoid recreating Image views with the same symbol in tight loops; " +
                            "SwiftUI caches efficiently when the view identity is stable."
                )

                TipRow(
                    icon: "exclamationmark.triangle.fill",
                    color: .orange,
                    title: "Limit continuous animations",
                    detail: "Continuous effects like .pulse or .variableColor consume GPU cycles. Use isActive: false when off-screen."
                )

                TipRow(
                    icon: "exclamationmark.triangle.fill",
                    color: .orange,
                    title: "Prefer .font(.system(size:)) over .resizable()",
                    detail: "SF Symbols are designed to scale with font metrics. Using .font() ensures proper optical alignment."
                )
            }
        }
    }

    // MARK: - Rendering Mode Guide

    private var renderingModeGuideSection: some View {
        DemoCard(
            title: "🎨 Rendering Mode Guide",
            subtitle: "Choose the right mode for your use case"
        ) {
            VStack(spacing: 16) {
                modeGuideRow(
                    mode: .monochrome,
                    when: "Toolbars, tab bars, simple icons",
                    example: "rectangle.3.group"
                )

                Divider()

                modeGuideRow(
                    mode: .hierarchical,
                    when: "Emphasis with depth; status indicators",
                    example: "square.stack.3d.up.fill"
                )

                Divider()

                modeGuideRow(
                    mode: .palette,
                    when: "Custom branded icons; multi-colored UI",
                    example: "person.crop.circle.badge.checkmark"
                )

                Divider()

                modeGuideRow(
                    mode: .multicolor,
                    when: "Weather, file types, system-defined colors",
                    example: "cloud.sun.rain.fill"
                )
            }
        }
    }

    private func modeGuideRow(
        mode: RenderingModeOption,
        when: String,
        example: String
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: example)
                .font(.system(size: 32))
                .symbolRenderingMode(mode.renderingMode)
                .foregroundStyle(.blue, .green, .orange)
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(mode.title)
                    .font(.subheadline.weight(.semibold))
                Text(when)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    // MARK: - Accessibility

    private var accessibilitySection: some View {
        DemoCard(
            title: "♿ Accessibility",
            subtitle: "Make symbols work for everyone"
        ) {
            VStack(alignment: .leading, spacing: 14) {
                TipRow(
                    icon: "speaker.wave.2.fill",
                    color: .blue,
                    title: "Always add .accessibilityLabel()",
                    detail: "Meaningful symbols need labels for VoiceOver. Use '\"Delete item\"' instead of '\"Trash can\"'."
                )

                TipRow(
                    icon: "eye.slash.fill",
                    color: .purple,
                    title: "Hide decorative symbols",
                    detail: "Use .accessibilityHidden(true) for symbols that are purely decorative and don't convey information."
                )

                TipRow(
                    icon: "hand.tap.fill",
                    color: .orange,
                    title: "Ensure touch targets ≥ 44pt",
                    detail: "Small symbols used as buttons should have padding or frames of at least 44×44 points."
                )

                // Live example
                VStack(alignment: .leading, spacing: 8) {
                    Text("Live Example:")
                        .font(.caption.weight(.semibold))

                    HStack(spacing: 16) {
                        // Good: labeled
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundStyle(.red)
                            .accessibilityLabel("Delete item")
                            .frame(width: 44, height: 44)

                        VStack(alignment: .leading) {
                            Text("✅ Has accessibility label")
                                .font(.caption2)
                            Text(".accessibilityLabel(\"Delete item\")")
                                .font(.caption2.monospaced())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
    }

    // MARK: - Dynamic Type

    private var dynamicTypeSection: some View {
        DemoCard(
            title: "🔤 Dynamic Type",
            subtitle: "Symbols scale with text automatically"
        ) {
            VStack(spacing: 16) {
                // Demonstration of symbols scaling with text styles
                VStack(spacing: 10) {
                    ForEach(
                        [Font.TextStyle.caption2, .footnote, .body, .title2, .largeTitle],
                        id: \.self
                    ) { style in
                        HStack(spacing: 12) {
                            Image(systemName: "bell.badge.fill")
                                .font(.system(style))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.red, .orange)

                            Text(textStyleName(style))
                                .font(.system(style))

                            Spacer()
                        }
                    }
                }

                Text("SF Symbols automatically adapt when using .font(.system(.textStyle)) " +
                     "— no manual sizing needed.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func textStyleName(_ style: Font.TextStyle) -> String {
        switch style {
        case .caption2: ".caption2"
        case .footnote: ".footnote"
        case .body: ".body"
        case .title2: ".title2"
        case .largeTitle: ".largeTitle"
        default: "Other"
        }
    }

    // MARK: - Dark Mode Support

    private var darkModeSection: some View {
        DemoCard(
            title: "🌗 Dark Mode Support",
            subtitle: "Symbols adapt to color scheme automatically"
        ) {
            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    SymbolShowcaseItem(
                        systemName: "moon.stars.fill",
                        label: "Multicolor",
                        color: .primary,
                        renderingMode: .multicolor
                    )

                    SymbolShowcaseItem(
                        systemName: "sun.max.fill",
                        label: ".primary",
                        color: .primary
                    )

                    SymbolShowcaseItem(
                        systemName: "iphone",
                        label: ".secondary",
                        color: .secondary
                    )
                }
                .frame(maxWidth: .infinity)

                Text("Currently in \(colorScheme == .dark ? "Dark" : "Light") mode. " +
                     "System colors like .primary and .secondary adapt automatically.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BestPracticesView()
    }
}
