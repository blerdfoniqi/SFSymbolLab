import SwiftUI

// MARK: - SymbolShowcaseItem
// A vertical stack showing an SF Symbol image with a caption label beneath it.
// Replaces the repeated VStack { Image; Text } pattern used across multiple demo views.

struct SymbolShowcaseItem<S: ShapeStyle>: View {
    let systemName: String
    let label: String
    var fontSize: CGFloat = 44
    var style: S
    var renderingMode: SymbolRenderingMode?

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemName)
                .font(.system(size: fontSize))
                .symbolRenderingMode(renderingMode ?? .monochrome)
                .foregroundStyle(style)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// Convenience initializer for simple Color styles
extension SymbolShowcaseItem where S == Color {
    init(
        systemName: String,
        label: String,
        fontSize: CGFloat = 44,
        color: Color = .primary,
        renderingMode: SymbolRenderingMode? = nil
    ) {
        self.systemName = systemName
        self.label = label
        self.fontSize = fontSize
        self.style = color
        self.renderingMode = renderingMode
    }
}

#Preview {
    HStack(spacing: 24) {
        SymbolShowcaseItem(
            systemName: "heart.fill",
            label: "Heart",
            color: .red
        )

        SymbolShowcaseItem(
            systemName: "star.fill",
            label: "Star",
            color: .yellow
        )
    }
    .padding()
}
