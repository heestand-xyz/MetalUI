import SwiftUI

struct DisplaceView<Content: View>: View {
    
    let content: () -> Content
    
    var body: some View {
        content()
    }
}

extension View {
    
    public func displace<Content: View>(_ content: @escaping () -> Content) -> some View {
        DisplaceView(content: content)
    }
}
