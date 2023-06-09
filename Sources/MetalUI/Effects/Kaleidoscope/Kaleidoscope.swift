import SwiftUI

extension View {
    
    public func kaleidoscope(count: Int = 12,
                             offset: CGPoint = .zero,
                             angle: Angle = .zero,
                             scale: CGFloat = 1.0,
                             isEnabled: Bool = true) -> some View {
        SizeReader { size in
            let function = ShaderFunction(library: .bundle(.module),
                                          name: "kaleidoscope")
            let shader = Shader(function: function, arguments: [
                .float2(size),
                .float2(offset),
                .float(CGFloat(count)),
                .float(angle.radians),
                .float(scale),
            ])
            return self.distortionEffect(shader, maxSampleOffset: size, isEnabled: isEnabled)
        }
    }
}
