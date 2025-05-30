import SwiftUI

// MARK: - RenderingModeOption
// Wraps the four SF Symbol rendering modes with metadata for UI display.

enum RenderingModeOption: String, CaseIterable, Identifiable {
    case monochrome
    case hierarchical
    case palette
    case multicolor

    var id: String { rawValue }

    var title: String {
        switch self {
        case .monochrome: "Monochrome"
        case .hierarchical: "Hierarchical"
        case .palette: "Palette"
        case .multicolor: "Multicolor"
        }
    }

    /// Abbreviated title for space-constrained UI (e.g. segmented pickers)
    var shortTitle: String {
        switch self {
        case .monochrome: "Mono"
        case .hierarchical: "Hierarchy"
        case .palette: "Palette"
        case .multicolor: "Multi"
        }
    }

    var description: String {
        switch self {
        case .monochrome:
            "Single color applied uniformly to all layers of the symbol."
        case .hierarchical:
            "Single color with automatic opacity variations per layer for depth."
        case .palette:
            "Multiple custom colors mapped to each layer of the symbol."
        case .multicolor:
            "Apple-designed fixed colors baked into the symbol artwork."
        }
    }

    /// Returns the SwiftUI SymbolRenderingMode value.
    var renderingMode: SymbolRenderingMode {
        switch self {
        case .monochrome: .monochrome
        case .hierarchical: .hierarchical
        case .palette: .palette
        case .multicolor: .multicolor
        }
    }
}
