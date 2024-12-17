<img src="https://github.com/heestand-xyz/MetalUI-Docs/blob/main/Assets/MetalUI%20Icon.png?raw=true" width=128/>

# MetalUI

## Install

```swift
.package(url: "https://github.com/heestand-xyz/MetalUI", from: "0.1.0")
```

## Gradient Blur


| <img src="https://github.com/heestand-xyz/MetalUI-Docs/blob/main/Assets/Effects/Gradient%20Blur/MetalUI%20Gradient%20Blur%20Vertical.png?raw=true" width=200/> | 
<img src="https://github.com/heestand-xyz/MetalUI-Docs/blob/main/Assets/Effects/Gradient%20Blur/MetalUI%20Gradient%20Blur%20Horizontal.png?raw=true" width=200/> | 


```swift
import SwiftUI
import MetalUI

struct ContentView: View {
    
    @State var radius: CGFloat = 0.0
    @State var curve: CGFloat = 1
    
    var body: some View {
        VStack {
            Slider(value: $radius, in: 0...100)
            Slider(value: $curve, in: 0...2)
            HStack(spacing: 0) {
                Color.red
                Color.yellow
                Color.green
                Color.cyan
                Color.blue
            }
            .padding()
            .gradientBlur(
                axis: .vertical,
                radii: [0.0, radius],
                curve: curve
            )
        }
    }
}

#Preview {
    ContentView()
}
```

`GradientBlurStop` can also be used for more fine grained control over the stops.

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

https://github.com/heestand-xyz/MetalUI/assets/7947442/3eeb4a40-b578-4eb7-9700-3e34effe8e3d

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

## Feedback

![](https://github.com/heestand-xyz/MetalUI-Docs/raw/main/Assets/Effects/Feedback/MetalUI%20Feedback.mov)

```swift
import SwiftUI
import MetalUI

struct ContentView: View {
    
    var body: some View {
        Text("Hello, World!")
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .feedback { source, loop in
                ZStack {
                    source
                        .opacity(0.1)
                    loop
                        .scaleEffect(1.01)
                        .opacity(0.99)
                }
            }
    }
}

#Preview {
    ContentView()
}
```

## Edge

<img src="https://github.com/heestand-xyz/MetalUI-Docs/blob/main/Assets/Effects/Edge/MetalUI%20Edge.png?raw=true" width=400/>

```swift
import SwiftUI
import MetalUI

struct ContentView: View {
    
    var content: some View {
        
    }
    
    var body: some View {
        HStack {
            Image(systemName: "globe")
            Text("Hello, World!")
        }
        .font(.system(size: 50, weight: .bold))
        .padding()
        .edge()
    }
}

#Preview {
    ContentView()
}
```

## Pixelate

<img src="https://github.com/heestand-xyz/MetalUI-Docs/blob/main/Assets/Effects/Pixelate/MetalUI%20Pixelate.png?raw=true" width=400/>

```swift
import SwiftUI
import MetalUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            Text("Hello, World!")
                .pixelate()
            Text("Hello, World!")
                .quickPixelate()
        }
        .font(.largeTitle)
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
