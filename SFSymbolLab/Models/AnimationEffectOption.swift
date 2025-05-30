import SwiftUI

// MARK: - AnimationEffectOption
// Enumerates the SF Symbol animation effects available in iOS 17+.
// Used by the Playground and Animations demo screens.

enum AnimationEffectOption: String, CaseIterable, Identifiable {
    case none
    case bounce
    case pulse
    case scale
    case variableColor

    var id: String { rawValue }

    var title: String {
        switch self {
        case .none: "None"
        case .bounce: "Bounce"
        case .pulse: "Pulse"
        case .scale: "Scale"
        case .variableColor: "Variable Color"
        }
    }

    var icon: String {
        switch self {
        case .none: "xmark.circle"
        case .bounce: "arrow.up.arrow.down"
        case .pulse: "waveform.path"
        case .scale: "arrow.up.left.and.arrow.down.right"
        case .variableColor: "paintbrush.pointed"
        }
    }
}
