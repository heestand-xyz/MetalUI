import SwiftUI

extension View {

    public func circleBlur(_ radius: CGFloat,
                           sampleCount: Int = 100,
                           isEnabled: Bool = true) -> some View {
        SizeReader { size in
            let function = ShaderFunction(library: .bundle(.module),
                                          name: "circleBlur")
            let shader = Shader(function: function, arguments: [
                .float2(size),
                .float(radius),
                .float(CGFloat(sampleCount)),
            ])
            let maxSampleOffset = CGSize(width: radius, height: radius)
            return self.layerEffect(shader, maxSampleOffset: maxSampleOffset, isEnabled: isEnabled)
        }
    }
}
