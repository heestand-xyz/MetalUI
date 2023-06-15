import SwiftUI

struct ColorSchemeReader<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ViewBuilder
    let content: (ColorScheme) -> Content
        
    var body: some View {
        content(colorScheme)
    }
}
