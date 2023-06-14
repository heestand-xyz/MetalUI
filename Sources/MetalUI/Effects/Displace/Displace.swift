import SwiftUI

struct DisplaceView<Source: View, Content: View>: View {
    
    let distance: CGFloat
    let continuous: Bool
    let source: Source
    let content: () -> Content
    
    @State private var image: Image?
    
    var body: some View {
        source
            .opacity(0)
            .overlay {
                GeometryReader { proxy in
                    if let image {
                        let function = ShaderFunction(library: .bundle(.module),
                                                      name: "displace")
                        let shader = Shader(function: function, arguments: [
                            .image(image),
                            .float(distance)
                        ])
                        source.distortionEffect(shader, maxSampleOffset: proxy.size)
                    }
                }
                .task {
                    while true {
                        let renderer = ImageRenderer(content: content())
                        renderer.scale = .pixelsPerPoint
#if os(macOS)
                        guard let nsImage: NSImage = renderer.nsImage else { return }
                        image = Image(nsImage: nsImage)
#else
                        guard let uiImage: UIImage = renderer.uiImage else { return }
                        image = Image(uiImage: uiImage)
#endif
                        if continuous {
                            try? await Task.sleep(for: .seconds(1.0 / .frameRate))
                        } else {
                            break
                        }
                    }
                }
            }
    }
}

extension View {
    
    public func displace<Content: View>(distance: CGFloat = 1.0,
                                        continuous: Bool = false,
                                        _ content: @escaping () -> Content) -> some View {
        DisplaceView(distance: distance,
                     continuous: continuous,
                     source: self,
                     content: content)
    }
}
