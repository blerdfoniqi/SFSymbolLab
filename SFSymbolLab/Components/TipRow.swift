import SwiftUI

// MARK: - TipRow
// A horizontal row for displaying a tip or guideline with an icon, title, and detail text.
// Extracted from BestPracticesView for reusability across educational sections.

struct TipRow: View {
    let icon: String
    let color: Color
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.body)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    TipRow(
        icon: "checkmark.circle.fill",
        color: .green,
        title: "Follow conventions",
        detail: "Using established patterns makes your code easier to maintain."
    )
    .padding()
}
