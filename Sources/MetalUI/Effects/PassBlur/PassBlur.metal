//
//  Created by Anton Heestand on 2023-06-09.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] half4 blurPass(float2 position,
                                SwiftUI::Layer layer,
                                float distance) {
    
    float2 offsets[9] = {
        float2(-1, -1), float2(0, -1), float2(1, -1),
        float2(-1,  0), float2(0,  0), float2(1,  0),
        float2(-1,  1), float2(0,  1), float2(1,  1)
    };
    
    float weights[9] = { 1.0 / 16, 2.0 / 16, 1.0 / 16,
                         2.0 / 16, 4.0 / 16, 2.0 / 16,
                         1.0 / 16, 2.0 / 16, 1.0 / 16 };
    
    half4 result = 0.0;
    
    for (int i = 0; i < 9; i++) {
        float2 offset = offsets[i] * distance;
        result += layer.sample(position + offset) * weights[i];
    }
    
    return result;
}
