import SwiftUI

public struct GradientBlurStop {
    /// Blur radius is points.
    public let radius: CGFloat
    /// Between `0.0` and `1.0`
    public let location: CGFloat
    public init(radius: CGFloat, at location: CGFloat) {
        self.radius = radius
        self.location = location
    }
}

extension View {

    /// **Gradient Blur** runs a 2D gradient blur over and over again, each step is known as a pass.
    ///
    /// The radii controls the blur radius at uniformly distributed locations. At least 2 radii needs to be provided.
    ///
    /// Curve will bend the radius. It's a value around `1.0`, down to `0.0` and up to `infinity`.
    ///
    /// Each pass will divide the radius by 2.
    @ViewBuilder
    public func gradientBlur(
        axis: Axis,
        radii: [CGFloat],
        curve: CGFloat = 1.0,
        passes: Int = 10
    ) -> some View {
        if radii.count >= 2 {
            anyGradientBlur(
                axis: axis,
                stops: radii.enumerated().map({ index, radius in
                    GradientBlurStop(
                        radius: radius,
                        at: CGFloat(index) / CGFloat(radii.count - 1)
                    )
                }),
                curve: curve,
                passes: passes
            )
        } else {
            self
        }
    }
    
    /// **Gradient Blur** runs a 2D gradient blur over and over again, each step is known as a pass.
    ///
    /// The stops controls the blur radius at a specific location.
    ///
    /// Curve will bend the radius. It's a value around `1.0`, down to `0.0` and up to `infinity`.
    ///
    /// Each pass will divide the radius by 2.
    @ViewBuilder
    public func gradientBlur(
        axis: Axis,
        stops: [GradientBlurStop],
        curve: CGFloat = 1.0,
        passes: Int = 10
    ) -> some View {
        if stops.count >= 2 {
            anyGradientBlur(
                axis: axis,
                stops: stops,
                curve: curve,
                passes: passes
            )
        } else {
            self
        }
    }
    
    // MARK: - Multi Pass
    
    private func anyGradientBlur(
        axis: Axis,
        stops: [GradientBlurStop],
        curve: CGFloat,
        passes: Int
    ) -> AnyView {
        var currentMultiplier: CGFloat = 1.0
        var multipliers = [CGFloat]()
        for _ in 0..<passes {
            multipliers.append(currentMultiplier)
            currentMultiplier /= 2
        }
        return applyGradientBlurPasses(
            axis: axis,
            stops: stops,
            multipliers: multipliers,
            curve: curve
        )
    }
    
    private func applyGradientBlurPasses(
        axis: Axis,
        stops: [GradientBlurStop],
        multipliers: [CGFloat],
        curve: CGFloat
    ) -> AnyView {
        multipliers.reduce(AnyView(self)) { view, multiplier in
            AnyView(
                view.gradientBlurPassShader(
                    axis: axis,
                    stops: stops,
                    multiplier: multiplier,
                    curve: curve
                )
            )
        }
    }
    
    // MARK: - Mutli Pass Shader
    
    private func gradientBlurPassShader(
        axis: Axis,
        stops: [GradientBlurStop],
        multiplier: CGFloat,
        curve: CGFloat
    ) -> some View {
        let function = ShaderFunction(
            library: .bundle(.module),
            name: "gradientBlurPass"
        )
        let shader = Shader(
            function: function,
            arguments: [
                .boundingRect,
                .float(axis == .horizontal ? 0 : 1),
                .float(multiplier),
                .float(curve),
                .floatArray(stops.map({ Float($0.location) })),
                .floatArray(stops.map({ Float($0.radius) })),
            ]
        )
        let maxRadius: CGFloat = stops.map(\.radius).max() ?? 0
        let maxSampleOffset = CGSize(
            width: maxRadius * multiplier,
            height: maxRadius * multiplier
        )
        return self.layerEffect(shader, maxSampleOffset: maxSampleOffset)
    }
}
