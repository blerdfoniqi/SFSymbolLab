import SwiftUI

// MARK: - DemoCard
// A reusable card container with rounded corners, material background, and optional title.
// Used across all demo screens for consistent visual grouping.

struct DemoCard<Content: View>: View {
    let title: String?
    let subtitle: String?
    @ViewBuilder let content: () -> Content

    init(
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.quaternary, lineWidth: 0.5)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        DemoCard(title: "Example Card", subtitle: "This is a reusable card") {
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundStyle(.yellow)
        }

        DemoCard {
            Text("Card without title")
        }
    }
    .padding()
}
