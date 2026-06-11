import SwiftUI

enum Theme {
    static let bg = Color.black
    static let surface = Color(red: 0.110, green: 0.110, blue: 0.118)       // #1C1C1E
    static let surfaceLight = Color(red: 0.173, green: 0.173, blue: 0.180)  // #2C2C2E
    static let card = Color(red: 0.078, green: 0.078, blue: 0.084)
    static let composer = Color(red: 0.102, green: 0.102, blue: 0.108)
    static let stroke = Color.white.opacity(0.09)
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.580, green: 0.580, blue: 0.600) // #949499
    static let blue = Color(red: 0.250, green: 0.480, blue: 1.000)
    static let green = Color(red: 0.290, green: 0.850, blue: 0.550)
    static let red = Color(red: 0.960, green: 0.380, blue: 0.380)
    static let amber = Color(red: 1.000, green: 0.700, blue: 0.300)

    static let bloomBlue = Color(red: 0.110, green: 0.300, blue: 0.980)
    static let bloomIndigo = Color(red: 0.300, green: 0.220, blue: 0.950)
    static let bloomPink = Color(red: 0.940, green: 0.230, blue: 0.560)
    static let bloomOrange = Color(red: 1.000, green: 0.420, blue: 0.130)

    static let heartGradient = LinearGradient(
        colors: [bloomOrange, bloomPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

/// The Lovable home-screen glow: black up top melting into a blue bloom,
/// then pink, then orange at the very bottom edge.
struct LovableBloom: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                Color.black

                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [Theme.bloomBlue.opacity(0.80), .clear],
                            center: .center,
                            startRadius: 8,
                            endRadius: w * 0.85
                        )
                    )
                    .frame(width: w * 1.8, height: h * 0.62)
                    .position(x: w / 2, y: h * 0.62)
                    .blur(radius: 46)

                Ellipse()
                    .fill(Theme.bloomIndigo.opacity(0.45))
                    .frame(width: w * 1.3, height: h * 0.36)
                    .position(x: w * 0.32, y: h * 0.72)
                    .blur(radius: 70)

                Ellipse()
                    .fill(Theme.bloomPink.opacity(0.85))
                    .frame(width: w * 2.0, height: h * 0.42)
                    .position(x: w / 2, y: h * 0.92)
                    .blur(radius: 60)

                Ellipse()
                    .fill(Theme.bloomOrange.opacity(0.95))
                    .frame(width: w * 2.2, height: h * 0.34)
                    .position(x: w / 2, y: h * 1.10)
                    .blur(radius: 55)
            }
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
    }
}

struct CircleIconButton: View {
    let systemName: String
    var size: CGFloat = 44
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: size * 0.40, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(Theme.surface, in: Circle())
        }
    }
}

private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.16), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.7)
                    .offset(x: phase * geo.size.width * 1.7)
                }
                .allowsHitTesting(false)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        modifier(ShimmerModifier())
    }
}

enum Haptics {
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

/// Springy press feedback for tappable surfaces.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.spring(response: 0.28, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

/// A glossy gradient orb whose colors are derived from a stable seed, so every
/// project gets its own slightly different orb.
struct OrbIcon: View {
    let seed: String
    var size: CGFloat = 40

    private var baseHue: Double {
        var hash = 0
        for scalar in seed.unicodeScalars {
            hash = (hash &* 31 &+ Int(scalar.value)) & 0xFFFF
        }
        return Double(hash % 360) / 360.0
    }

    var body: some View {
        let h1 = baseHue
        let h2 = (baseHue + 0.11).truncatingRemainder(dividingBy: 1.0)
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        Color(hue: h1, saturation: 0.80, brightness: 0.98),
                        Color(hue: h2, saturation: 0.90, brightness: 0.62),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Circle().fill(
                    RadialGradient(
                        colors: [.white.opacity(0.50), .clear],
                        center: UnitPoint(x: 0.32, y: 0.26),
                        startRadius: 1,
                        endRadius: size * 0.6
                    )
                )
            )
            .overlay(Circle().strokeBorder(.white.opacity(0.16), lineWidth: 0.8))
            .frame(width: size, height: size)
            .shadow(color: Color(hue: h1, saturation: 0.85, brightness: 0.85).opacity(0.40), radius: 5, y: 2)
    }
}
