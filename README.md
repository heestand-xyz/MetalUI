# MetalUI

## Install

```swift
.package(url: "https://github.com/heestand-xyz/MetalUI", from: "0.0.1")
```

## Circle Blur

![](https://github.com/heestand-xyz/MetalUI-Docs/raw/main/Assets/Effects/Circle%20Blur/MetalUI%20Circle%20Blur.mov)

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

| <img src="https://github.com/heestand-xyz/MetalUI-Docs/blob/main/Assets/Effects/Chroma%20Key/MetalUI%20Green%20Screen%20A.jpeg?raw=true" width=200/> | 
<img src="https://github.com/heestand-xyz/MetalUI-Docs/blob/main/Assets/Effects/Chroma%20Key/MetalUI%20Green%20Screen%20B.jpeg?raw=true" width=200/> | 

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

![](https://github.com/heestand-xyz/MetalUI-Docs/raw/main/Assets/Effects/Kaleidoscope/MetalUI%20Kaleidoscope.mov)

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
```

## Noise

<img src="https://github.com/heestand-xyz/MetalUI-Docs/blob/main/Assets/Content/Noise/MetalUI%20Noise.png?raw=true" width=200/>

```swift
import SwiftUI
import MetalUI

struct ContentView: View {
    
    var body: some View {
        Noise()
    }
}

#Preview {
    ContentView()
}
```
