import SwiftUI

struct FeedbackView<Content: View>: View {
    
    let content: Content
    
    @State private var image: Image?
    
    var body: some View {
        content.opacity(0)
            .overlay {
                if let image {
                    image
                }
            }
            .onAppear {
                let renderer = ImageRenderer(content: content)
                renderer.scale = .pixelsPerPoint
                #if os(macOS)
                guard let nsImage: NSImage = renderer.nsImage else { return }
                image = Image(nsImage: nsImage)
                #else
                guard let uiImage: UIImage = renderer.uiImage else { return }
                image = Image(uiImage: uiImage)
                #endif
            }
    }
}

extension View {
    
    public func feedback<Content: View>(loop: (Self) -> Content) -> some View {
        FeedbackView(content: loop(self))
    }
}
