import SwiftUI

public struct ChromaKeySettings {
    public var range: CGFloat = 0.1
    public var softness: CGFloat = 0.1
    public var edgeDesaturation: CGFloat = 0.5
    public var alphaCrop: CGFloat = 0.5
    public init() {}
}

extension View {
    
    /// Removes any green background, making it transparent.
    ///
    /// - Parameters:
    ///   - range: The amount of background that will be removed. *(Fraction from 0.0 to 1.0, default at 0.1)*
    ///   - softness: The fade of the edge of the removed background. *(Fraction from 0.0 to 1.0, default at 0.1)*
    ///   - edgeDesaturation: The amount of desaturation to the edges. *(Fraction from 0.0 to 1.0, default at 0.5)*
    ///   - alphaCrop: A alpha crop factor. *(Fraction from 0.0 to 1.0, default at 0.5)*
    public func removeGreenScreen(settings: ChromaKeySettings = .init(),
                                  isEnabled: Bool = true) -> some View {
        chromaKey(color: Color(red: 0.0, green: 1.0, blue: 0.0),
                  settings: settings,
                  isEnabled: isEnabled)
    }
    
    /// Remove the background that has the specified a color.
    ///
    /// - Parameters:
    ///   - range: The amount of background that will be removed. *(Fraction from 0.0 to 1.0, default at 0.1)*
    ///   - softness: The fade of the edge of the removed background. *(Fraction from 0.0 to 1.0, default at 0.1)*
    ///   - edgeDesaturation: The amount of desaturation to the edges. *(Fraction from 0.0 to 1.0, default at 0.5)*
    ///   - alphaCrop: A alpha crop factor. *(Fraction from 0.0 to 1.0, default at 0.5)*
    public func chromaKey(color: Color,
                          settings: ChromaKeySettings = .init(),
                          isEnabled: Bool = true) -> some View {
        let function = ShaderFunction(library: .bundle(.module),
                                      name: "chromaKey")
        let shader = Shader(function: function, arguments: [
            .color(color),
            .float(settings.range),
            .float(settings.softness),
            .float(settings.edgeDesaturation),
            .float(settings.alphaCrop),
        ])
        return self.colorEffect(shader, isEnabled: isEnabled)
    }
}
