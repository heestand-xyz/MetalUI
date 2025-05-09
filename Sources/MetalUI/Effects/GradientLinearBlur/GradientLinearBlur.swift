import SwiftUI

extension View {

    /// **Gradient Linear Blur** runs a 1D gradient blur over and over again, each step is known as a pass.
    ///
    /// The radii controls the blur radius at uniformly distributed locations. At least 2 radii needs to be provided.
    ///
    /// Curve will bend the radius. It's a value around `1.0`, down to `0.0` and up to `infinity`.
    @ViewBuilder
    public func gradientLinearBlur(
        gradientAxis: Axis,
        blurAxis: Axis,
        radii: [CGFloat],
        curve: CGFloat = 1.0,
        passes: Int = 10
    ) -> some View {
        if radii.count >= 2 {
            anyGradientLinearBlur(
                gradientAxis: gradientAxis,
                blurAxis: blurAxis,
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
    
    /// **Gradient Linear Blur** runs a 1D gradient blur over and over again, each step is known as a pass.
    ///
    /// The stops controls the blur radius at a specific location.
    ///
    /// Curve will bend the radius. It's a value around `1.0`, down to `0.0` and up to `infinity`.
    @ViewBuilder
    public func gradientLinearBlur(
        gradientAxis: Axis,
        blurAxis: Axis,
        stops: [GradientBlurStop],
        curve: CGFloat = 1.0,
        passes: Int = 10
    ) -> some View {
        if stops.count >= 2 {
            anyGradientLinearBlur(
                gradientAxis: gradientAxis,
                blurAxis: blurAxis,
                stops: stops,
                curve: curve,
                passes: passes
            )
        } else {
            self
        }
    }
    
    /// **Gradient Linear Blur** runs a 1D gradient blur in a single pass.
    ///
    /// The radii controls the blur radius at uniformly distributed locations. At least 2 radii needs to be provided.
    ///
    /// Curve will bend the radius. It's a value around `1.0`, down to `0.0` and up to `infinity`.
    @ViewBuilder
    public func gradientLinearBlur(
        gradientAxis: Axis,
        blurAxis: Axis,
        radii: [CGFloat],
        curve: CGFloat = 1.0,
        detail: Int = 100
    ) -> some View {
        if radii.count >= 2, detail >= 2 {
            gradientLinearBlur(
                gradientAxis: gradientAxis,
                blurAxis: blurAxis,
                stops: radii.enumerated().map({ index, radius in
                    GradientBlurStop(
                        radius: radius,
                        at: CGFloat(index) / CGFloat(radii.count - 1)
                    )
                }),
                curve: curve,
                detail: detail
            )
        } else {
            self
        }
    }
    
    /// **Gradient Linear Blur** runs a 1D gradient blur in a single pass.
    ///
    /// The stops controls the blur radius at a specific location.
    ///
    /// Curve will bend the radius. It's a value around `1.0`, down to `0.0` and up to `infinity`.
    @ViewBuilder
    public func gradientLinearBlur(
        gradientAxis: Axis,
        blurAxis: Axis,
        stops: [GradientBlurStop],
        curve: CGFloat = 1.0,
        detail: Int = 100
    ) -> some View {
        if stops.count >= 2, detail >= 2 {
            gradientLinearBlurShader(
                gradientAxis: gradientAxis,
                blurAxis: blurAxis,
                stops: stops,
                curve: curve,
                detail: detail
            )
        } else {
            self
        }
    }
    
    // MARK: - Multi Pass
    
    private func anyGradientLinearBlur(
        gradientAxis: Axis,
        blurAxis: Axis,
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
        return applyGradientLinearBlurPasses(
            gradientAxis: gradientAxis,
            blurAxis: blurAxis,
            stops: stops,
            multipliers: multipliers,
            curve: curve
        )
    }
    
    private func applyGradientLinearBlurPasses(
        gradientAxis: Axis,
        blurAxis: Axis,
        stops: [GradientBlurStop],
        multipliers: [CGFloat],
        curve: CGFloat
    ) -> AnyView {
        multipliers.reduce(AnyView(self)) { view, multiplier in
            AnyView(
                view.gradientLinearBlurPassShader(
                    gradientAxis: gradientAxis,
                    blurAxis: blurAxis,
                    stops: stops,
                    multiplier: multiplier,
                    curve: curve
                )
            )
        }
    }
    
    // MARK: - Multi Pass Shader
    
    private func gradientLinearBlurPassShader(
        gradientAxis: Axis,
        blurAxis: Axis,
        stops: [GradientBlurStop],
        multiplier: CGFloat,
        curve: CGFloat
    ) -> some View {
        let function = ShaderFunction(
            library: .bundle(.module),
            name: "gradientLinearBlurPass"
        )
        let shader = Shader(
            function: function,
            arguments: [
                .boundingRect,
                .float(gradientAxis == .horizontal ? 0 : 1),
                .float(blurAxis == .horizontal ? 0 : 1),
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
    
    // MARK: - Single Pass Shader
    
    private func gradientLinearBlurShader(
        gradientAxis: Axis,
        blurAxis: Axis,
        stops: [GradientBlurStop],
        curve: CGFloat,
        detail: Int
    ) -> some View {
        let function = ShaderFunction(
            library: .bundle(.module),
            name: "gradientLinearBlur"
        )
        let shader = Shader(
            function: function,
            arguments: [
                .boundingRect,
                .float(gradientAxis == .horizontal ? 0 : 1),
                .float(blurAxis == .horizontal ? 0 : 1),
                .float(Float(detail)),
                .float(curve),
                .floatArray(stops.map({ Float($0.location) })),
                .floatArray(stops.map({ Float($0.radius) })),
            ]
        )
        let maxRadius: CGFloat = stops.map(\.radius).max() ?? 0
        let maxSampleOffset = CGSize(
            width: maxRadius,
            height: maxRadius
        )
        return self.layerEffect(shader, maxSampleOffset: maxSampleOffset)
    }
}
