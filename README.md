# MetalUI

## Install

```swift
.package(url: "https://github.com/heestand-xyz/MetalUI", from: "0.0.1")
```

## Circle Blur

```swift
import SwiftUI
import MetalUI

struct ContentView: View {
    
    @State var value: CGFloat = 0.0
    
    var body: some View {
        VStack {
            Text("Hello World")
                .padding()
                .border(Color.black)
                .circleBlur(value * 10)
            Slider(value: $value)
        }
        .padding()
        .frame(width: 250)
    }
}

#Preview {
    ContentView()
}
```

## Green Screen

```swift

import SwiftUI
import MetalUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            Image("Superman")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .chromaKey(color: Color(red: 0.0,
                                        green: 1.0,
                                        blue: 0.0))
        }
    }
}

#Preview {
    ContentView()
}

```

## Kaleidoscope

```swift
import SwiftUI
import MetalUI

struct ContentView: View {
    
    @State var value: CGFloat = 0.0
    
    var body: some View {
        VStack {
            Color.red
            Color.green
            Color.blue
        }
        .frame(width: 200, height: 200)
        .kaleidoscope(count: 12, angle: .degrees(180))
    }
}

#Preview {
    ContentView()
}
```swift
