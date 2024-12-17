import SwiftUI

extension View {

    /// **Pass Blur** runs a simple blur over and over again, each step is known as a pass.
    ///
    /// Each pass will divide the radius by 2.
    public func passBlur(radius: CGFloat, passes: Int = 10) -> some View {
        anyPassBlur(radius: radius, passes: passes)
    }
    
    private func anyPassBlur(radius: CGFloat, passes: Int = 10) -> AnyView {
        if radius > 1.0 {
            var currentRadius: CGFloat = radius
            var radii = [CGFloat]()
            for _ in 0..<passes {
                radii.append(currentRadius)
                currentRadius /= 2
            }
            return applyBlurPasses(radii)
        } else {
            return AnyView(self)
        }
    }
    
    private func applyBlurPasses(_ radii: [CGFloat]) -> AnyView {
        radii.reduce(AnyView(self)) { view, radius in
            AnyView(view.blurPass(radius))
        }
    }
    
    private func blurPass(_ radius: CGFloat) -> some View {
        let function = ShaderFunction(library: .bundle(.module),
                                      name: "blurPass")
        let shader = Shader(function: function, arguments: [
            .float(radius),
        ])
        let maxSampleOffset = CGSize(width: radius, height: radius)
        return self.layerEffect(shader, maxSampleOffset: maxSampleOffset)
    }
}
