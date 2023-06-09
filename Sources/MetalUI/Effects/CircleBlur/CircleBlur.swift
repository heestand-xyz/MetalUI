import SwiftUI

extension View {

    public func circleBlur(_ radius: CGFloat,
                           isEnabled: Bool = true) -> some View {
        let function = ShaderFunction(library: .bundle(.module),
                                      name: "circleBlur")
        let shader = Shader(function: function, arguments: [
            .float(radius),
        ])
        let maxSampleOffset = CGSize(width: radius, height: radius)
        return self.layerEffect(shader, maxSampleOffset: maxSampleOffset, isEnabled: isEnabled)
    }
}
