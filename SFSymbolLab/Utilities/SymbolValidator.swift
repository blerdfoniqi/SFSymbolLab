import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - SymbolValidator
// Platform-bridging helper that checks whether a string names a real SF Symbol.
// Kept out of the SwiftUI views so they depend on SwiftUI alone — the UIKit /
// AppKit import lives here, not in the view layer.

enum SymbolValidator {
    /// Returns `true` if `name` resolves to an SF Symbol on the current platform.
    static func exists(_ name: String) -> Bool {
        #if canImport(UIKit)
        return UIImage(systemName: name) != nil
        #elseif canImport(AppKit)
        return NSImage(systemSymbolName: name, accessibilityDescription: nil) != nil
        #else
        return true
        #endif
    }
}
