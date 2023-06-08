# MetalUI

## Install

```swift
.package(url: "https://github.com/heestand-xyz/MetalUI", from: "0.0.1")
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
