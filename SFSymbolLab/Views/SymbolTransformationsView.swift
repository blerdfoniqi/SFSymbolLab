import SwiftUI

// MARK: - SymbolTransformationsView
// Demonstrates visual transformations applied to SF Symbols:
// - Rotation (2D with slider)
// - Scaling (with slider)
// - 3D rotation (perspective flip)
// - Opacity (with slider)
// - MatchedGeometryEffect (symbol moves between two positions)
// - Combined simultaneous transforms

struct SymbolTransformationsView: View {
    @State private var rotation: Double = 0
    @State private var scale: Double = 1.0
    @State private var rotation3DAngle: Double = 0
    @State private var opacity: Double = 1.0
    @State private var isOnLeft = true
    @Namespace private var symbolNamespace

    var body: some View {
        DemoScrollView(title: "Transformations") {
            rotationSection
            scaleSection
            rotation3DSection
            opacitySection
            matchedGeometrySection
            combinedSection
        }
    }

    // MARK: - Rotation

    private var rotationSection: some View {
        DemoCard(
            title: "Rotation",
            subtitle: ".rotationEffect()"
        ) {
            VStack(spacing: 16) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                    .rotationEffect(.degrees(rotation))
                    .animation(.easeInOut, value: rotation)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Gear, rotated \(Int(rotation)) degrees")

                SliderControl(
                    label: "Rotation",
                    value: $rotation,
                    range: 0...360,
                    tintColor: .blue,
                    formatStyle: .degrees
                )
            }
        }
    }

    // MARK: - Scale

    private var scaleSection: some View {
        DemoCard(
            title: "Scale",
            subtitle: ".scaleEffect()"
        ) {
            VStack(spacing: 16) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundStyle(.purple)
                    .scaleEffect(scale)
                    .animation(.spring(response: 0.3), value: scale)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .accessibilityLabel("Magnifying glass, scaled \(String(format: "%.1f", scale))x")

                SliderControl(
                    label: "Scale",
                    value: $scale,
                    range: 0.3...2.5,
                    tintColor: .purple,
                    formatStyle: .multiplier
                )
            }
        }
    }

    // MARK: - 3D Rotation

    private var rotation3DSection: some View {
        DemoCard(
            title: "3D Rotation",
            subtitle: ".rotation3DEffect()"
        ) {
            VStack(spacing: 16) {
                Image(systemName: "cube.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotation3DEffect(
                        .degrees(rotation3DAngle),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.5
                    )
                    .animation(.easeInOut, value: rotation3DAngle)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Cube, rotated \(Int(rotation3DAngle)) degrees on Y axis")

                SliderControl(
                    label: "Y-axis",
                    value: $rotation3DAngle,
                    range: -180...180,
                    tintColor: .cyan,
                    formatStyle: .degrees
                )

                Button("Flip 360°") {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        rotation3DAngle += 360
                    }
                }
                .buttonStyle(.bordered)
                .tint(.cyan)
            }
        }
    }

    // MARK: - Opacity

    private var opacitySection: some View {
        DemoCard(
            title: "Opacity",
            subtitle: ".opacity()"
        ) {
            VStack(spacing: 16) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.yellow)
                    .opacity(opacity)
                    .animation(.easeInOut, value: opacity)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Sun, \(Int(opacity * 100))% opacity")

                SliderControl(
                    label: "Opacity",
                    value: $opacity,
                    range: 0...1,
                    tintColor: .yellow,
                    formatStyle: .percent
                )
            }
        }
    }

    // MARK: - Matched Geometry Effect
    // Symbol smoothly transitions between two positions

    private var matchedGeometrySection: some View {
        DemoCard(
            title: "Matched Geometry Effect",
            subtitle: "Symbol animates between two positions"
        ) {
            VStack(spacing: 16) {
                HStack {
                    if isOnLeft {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.orange)
                            .matchedGeometryEffect(id: "plane", in: symbolNamespace)
                    }

                    Spacer()

                    if !isOnLeft {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.orange)
                            .matchedGeometryEffect(id: "plane", in: symbolNamespace)
                    }
                }
                .frame(height: 60)

                Button("Move \(isOnLeft ? "Right" : "Left")") {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        isOnLeft.toggle()
                    }
                }
                .buttonStyle(.bordered)
                .tint(.orange)
            }
        }
    }

    // MARK: - Combined Transforms
    // All transforms applied simultaneously

    private var combinedSection: some View {
        DemoCard(
            title: "Combined Transforms",
            subtitle: "All transformations applied simultaneously"
        ) {
            VStack(spacing: 16) {
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        AngularGradient(
                            colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
                            center: .center
                        )
                    )
                    .rotationEffect(.degrees(rotation))
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .rotation3DEffect(
                        .degrees(rotation3DAngle),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.5
                    )
                    .animation(.easeInOut, value: rotation)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .accessibilityHidden(true)

                Text("This symbol reflects all slider values above")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Reset All") {
                    withAnimation(.spring(response: 0.5)) {
                        rotation = 0
                        scale = 1.0
                        rotation3DAngle = 0
                        opacity = 1.0
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SymbolTransformationsView()
    }
}
