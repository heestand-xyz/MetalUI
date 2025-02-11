import CoreGraphics
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension CGFloat {
    
    public static var pixelsPerPoint: CGFloat {
        #if os(macOS)
        return NSScreen.main?.backingScaleFactor ?? 1.0
        #elseif os(visionOS)
        return 3.0 // guess of dynamic average
        #else
        return UIScreen.main.scale
        #endif
    }
}
