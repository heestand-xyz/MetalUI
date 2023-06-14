import SwiftUI

struct FeedbackView<Source: View, Content: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    let source: Source
    let loop: (Source, AnyView) -> Content
    
    @State private var image: Image?
    
    @State private var size: CGSize?
    
    @ViewBuilder
    private var imageBody: some View {
        if let image, let size {
            image
                .frame(width: size.width,
                       height: size.height)
        }
    }

    var body: some View {
        source
            .opacity(0.0)
            .overlay {
                GeometryReader { proxy in
                    ZStack {
                        if let image {
                            image
                        }
                    }
                    .onAppear {
                        size = proxy.size
                    }
                    .onChange(of: proxy.size) { _, newSize in
                        size = newSize
                    }
                    .task {
                        while true {
                            let renderer = ImageRenderer(content: loop(source, AnyView(imageBody)))
                            renderer.proposedSize = ProposedViewSize(width: proxy.size.width,
                                                                     height: proxy.size.height)
                            renderer.scale = .pixelsPerPoint
#if os(macOS)
                            guard let nsImage: NSImage = renderer.nsImage else { return }
                            image = Image(nsImage: nsImage)
#else
                            guard let uiImage: UIImage = renderer.uiImage else { return }
                            image = Image(uiImage: uiImage)
#endif
                            try? await Task.sleep(for: .seconds(1.0 / .frameRate))
                        }
                    }
                }
            }
    }
}

extension View {
    
    public func feedback<Content: View>(loop: @escaping (Self, AnyView) -> Content) -> some View {
        FeedbackView(source: self, loop: loop)
    }
}
