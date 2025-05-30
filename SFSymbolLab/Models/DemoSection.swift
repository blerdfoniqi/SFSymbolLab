import SwiftUI

// MARK: - DemoSection
// Defines all available demo sections in the app.
// Each case provides a title, icon, and description for NavigationStack list rendering.

enum DemoSection: String, CaseIterable, Identifiable {
    case renderingModes
    case colorVariations
    case symbolAnimations
    case variableSymbols
    case symbolTransformations
    case playground
    case bestPractices

    var id: String { rawValue }

    var title: String {
        switch self {
        case .renderingModes: "Rendering Modes"
        case .colorVariations: "Color Variations"
        case .symbolAnimations: "Symbol Animations"
        case .variableSymbols: "Variable Symbols"
        case .symbolTransformations: "Transformations"
        case .playground: "Playground"
        case .bestPractices: "Best Practices"
        }
    }

    var icon: String {
        switch self {
        case .renderingModes: "paintpalette"
        case .colorVariations: "swatchpalette"
        case .symbolAnimations: "wand.and.stars"
        case .variableSymbols: "slider.horizontal.3"
        case .symbolTransformations: "arrow.triangle.2.circlepath"
        case .playground: "puzzlepiece.extension"
        case .bestPractices: "checkmark.seal"
        }
    }

    var description: String {
        switch self {
        case .renderingModes: "Monochrome, hierarchical, palette & multicolor"
        case .colorVariations: "Gradients, animated transitions & dynamic tints"
        case .symbolAnimations: "Bounce, pulse, scale, replace & more"
        case .variableSymbols: "Slider-driven variable value symbols"
        case .symbolTransformations: "Rotation, scale, 3D effects & matched geometry"
        case .playground: "Build your own symbol configuration"
        case .bestPractices: "Performance, accessibility & design guidance"
        }
    }

    var accentColor: Color {
        switch self {
        case .renderingModes: .blue
        case .colorVariations: .purple
        case .symbolAnimations: .orange
        case .variableSymbols: .green
        case .symbolTransformations: .pink
        case .playground: .cyan
        case .bestPractices: .mint
        }
    }

    /// Returns the destination view for navigation.
    @ViewBuilder
    var destination: some View {
        switch self {
        case .renderingModes:
            RenderingModesView()
        case .colorVariations:
            ColorVariationsView()
        case .symbolAnimations:
            SymbolAnimationsView()
        case .variableSymbols:
            VariableSymbolsView()
        case .symbolTransformations:
            SymbolTransformationsView()
        case .playground:
            PlaygroundView()
        case .bestPractices:
            BestPracticesView()
        }
    }
}
