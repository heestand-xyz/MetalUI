import SwiftUI

struct SizeReader<Content: View>: View {
    
    @ViewBuilder
    let content: (CGSize) -> Content
    
    @State private var size: CGSize = CGSize(width: 1.0, height: 1.0)
    
    var body: some View {
        content(size)
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                        }
                        .onChange(of: proxy.size) { _, newSize in
                            size = newSize
                        }
                }
            }
    }
}
