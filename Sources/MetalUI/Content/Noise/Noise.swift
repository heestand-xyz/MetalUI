import SwiftUI

public struct Noise: View {
    
    let octaves: Int
    let offset: CGPoint
    let zOffset: CGFloat
    let scale: CGFloat
    let isColored: Bool
    let isRandom: Bool
    let seed: Int
    
    public init(octaves: Int = 1,
                offset: CGPoint = .zero,
                zOffset: CGFloat = 0.0,
                scale: CGFloat = 1.0,
                isColored: Bool = true,
                isRandom: Bool = false,
                seed: Int = 0) {
        self.octaves = octaves
        self.offset = offset
        self.zOffset = zOffset
        self.scale = scale
        self.isColored = isColored
        self.isRandom = isRandom
        self.seed = seed
    }
    
    private var shaderFunction: ShaderFunction {
        ShaderFunction(library: .bundle(.module),
                       name: "noise")
    }
    
    private func shader(size: CGSize) -> Shader {
        Shader(function: shaderFunction, arguments: [
            .float2(size),
            .float(CGFloat(octaves)),
            .float2(offset),
            .float(zOffset),
            .float(scale),
            .float(isColored ? 1.0 : 0.0),
            .float(isRandom ? 1.0 : 0.0),
            .float(CGFloat(seed)),
        ])
    }
    
    public var body: some View {
        SizeReader { size in
            Rectangle()
                .colorEffect(shader(size: size))
        }
    }
}
