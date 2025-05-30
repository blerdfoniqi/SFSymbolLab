#!/usr/bin/env swift
//
//  GenerateAppIcon.swift
//  SF Symbol Lab
//
//  Renders the app icon (light / dark / tinted) from an SF Symbol on a gradient
//  background. On-brand for a symbols showcase, and fully reproducible.
//
//  Usage:
//      swift Scripts/GenerateAppIcon.swift
//
//  Output: 1024×1024 PNGs written into the AppIcon asset set.
//

import AppKit

let symbolName = "wand.and.stars"
let outputDir = "SFSymbolLab/Assets.xcassets/AppIcon.appiconset"

func color(_ hex: UInt32) -> NSColor {
    NSColor(
        srgbRed: CGFloat((hex >> 16) & 0xFF) / 255,
        green: CGFloat((hex >> 8) & 0xFF) / 255,
        blue: CGFloat(hex & 0xFF) / 255,
        alpha: 1
    )
}

/// Recolors a template SF Symbol image to a solid color.
func tintedSymbol(_ name: String, color tint: NSColor, pointSize: CGFloat) -> NSImage {
    let config = NSImage.SymbolConfiguration(pointSize: pointSize, weight: .semibold)
    guard let base = NSImage(systemSymbolName: name, accessibilityDescription: nil)?
        .withSymbolConfiguration(config) else {
        fatalError("Symbol '\(name)' not available on this system.")
    }
    let image = NSImage(size: base.size)
    image.lockFocus()
    tint.set()
    let rect = NSRect(origin: .zero, size: base.size)
    base.draw(in: rect)
    rect.fill(using: .sourceAtop)
    image.unlockFocus()
    return image
}

func makeIcon(filename: String, gradient: [NSColor], symbolColor: NSColor) {
    let side: CGFloat = 1024
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(side), pixelsHigh: Int(side),
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
    ) else { fatalError("Could not allocate bitmap.") }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

    let rect = NSRect(x: 0, y: 0, width: side, height: side)
    NSGradient(colors: gradient)?.draw(in: rect, angle: -45)

    let symbol = tintedSymbol(symbolName, color: symbolColor, pointSize: 560)
    let size = symbol.size
    let origin = NSPoint(x: (side - size.width) / 2, y: (side - size.height) / 2)
    symbol.draw(at: origin, from: .zero, operation: .sourceOver, fraction: 1)

    NSGraphicsContext.restoreGraphicsState()

    guard let data = rep.representation(using: .png, properties: [:]) else {
        fatalError("PNG encoding failed.")
    }
    let path = "\(outputDir)/\(filename)"
    try! data.write(to: URL(fileURLWithPath: path))
    print("wrote \(path)")
}

// Light: vivid purple → blue → cyan.
makeIcon(
    filename: "AppIcon-1024.png",
    gradient: [color(0x7C3AED), color(0x2563EB), color(0x06B6D4)],
    symbolColor: .white
)

// Dark: deep indigo → near-black.
makeIcon(
    filename: "AppIcon-1024-Dark.png",
    gradient: [color(0x312E81), color(0x0B0B12)],
    symbolColor: color(0xF4F4FF)
)

// Tinted: monochrome on near-black; the system applies the user's tint.
makeIcon(
    filename: "AppIcon-1024-Tinted.png",
    gradient: [color(0x1C1C1E), color(0x000000)],
    symbolColor: .white
)
