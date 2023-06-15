import SwiftUI

extension View {

    /// Pixelate
    /// - Parameters:
    ///   - fraction: A higher value will result in more pixelation.
    ///   A value of 1.0 will result in one pixel, 0.5 in 2x2 and 0.25 in 4x4. The default fraction is 0.1.
    public func pixelate(fraction: CGFloat = 0.1,
                         isEnabled: Bool = true) -> some View {
        SizeReader { size in
            let function = ShaderFunction(library: .bundle(.module),
                                          name: "pixelate")
            let shader = Shader(function: function, arguments: [
                .boundingRect,
                .float(fraction),
            ])
            let maxSampleOffset = CGSize(width: size.width * fraction,
                                         height: size.height * fraction)
            return self.layerEffect(shader, maxSampleOffset: maxSampleOffset, isEnabled: isEnabled)
        }
    }
}
