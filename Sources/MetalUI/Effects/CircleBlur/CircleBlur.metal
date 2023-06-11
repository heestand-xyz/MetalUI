//
//  Created by Anton Heestand on 2023-06-09.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] half4 circleBlur(float2 position, SwiftUI::Layer layer, float2 size, float radius, float sampleCount) {
    
    half4 color = 0.0;
    for (int i = 0; i < int(sampleCount); ++i) {
        float fraction = float(i) / sampleCount;
        float x = position.x;
        float y = position.y;
        float angle = fraction * M_PI_F * 2;
        x += cos(angle) * radius;
        y += sin(angle) * radius;
        color += layer.sample(float2(x, y));
    }
    color /= float(sampleCount);

    return color;
}
