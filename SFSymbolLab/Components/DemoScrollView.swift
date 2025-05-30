import SwiftUI

// MARK: - DemoScrollView
// Reusable scrollable container with navigation title and consistent spacing.
// Replaces the repeated ScrollView + VStack + .padding() + .navigationTitle() boilerplate
// found in every demo view.

struct DemoScrollView<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                content()
            }
            .padding()
        }
        .navigationTitle(title)
        #if os(iOS) || os(visionOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

#Preview {
    NavigationStack {
        DemoScrollView(title: "Preview") {
            Text("Hello, World!")
        }
    }
}
