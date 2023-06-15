import SwiftUI

extension View {

    /// Pixelate
    /// - Parameters:
    ///   - pixelCount: A higher value will result in more pixelation.
    ///   A value of 2 will result in every 2x2 pixels being averaged into one bigger pixel.
    ///   The default value of pixelCount is 10.
    public func pixelate(_ pixelCount: Int = 10,
                         isEnabled: Bool = true) -> some View {
        let function = ShaderFunction(library: .bundle(.module),
                                      name: "pixelate")
        let shader = Shader(function: function, arguments: [
            .float(CGFloat(pixelCount)),
            .float(CGFloat.pixelsPerPoint),
        ])
        let maxSampleOffset = CGSize(width: CGFloat(pixelCount) / .pixelsPerPoint * 2,
                                     height: CGFloat(pixelCount) / .pixelsPerPoint * 2)
        return self.layerEffect(shader, maxSampleOffset: maxSampleOffset, isEnabled: isEnabled)
    }
}
