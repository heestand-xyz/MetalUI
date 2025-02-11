#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Double {
    
    public static var frameRate: Double {
#if os(macOS)
        let id = CGMainDisplayID()
        guard let mode = CGDisplayCopyDisplayMode(id) else { return 60 }
        return mode.refreshRate
#elseif os(iOS)
        return Double(UIScreen.main.maximumFramesPerSecond)
#elseif os(visionOS)
        return 90.0
#else
        return 60.0
#endif
    }
}

