//
//  Created by Anton Heestand on 2023-06-15.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] half4 pixelate(float2 position,
                                SwiftUI::Layer layer,
                                float pixelCount,
                                float pixelsPerPoint) {
    
    float2 origin = floor(position * pixelsPerPoint / pixelCount)  * pixelCount / pixelsPerPoint;

    half4 color = 0.0;
    for (int x = 0; x < int(pixelCount); ++x) {
        for (int y = 0; y < int(pixelCount); ++y) {
            float2 index = float2(x, y);
            float2 samplePosition = origin + index;
            half4 sampleColor = layer.sample(samplePosition);
            color += sampleColor;
        }
    }
    color /= pixelCount * pixelCount;
    
    return color;
}
