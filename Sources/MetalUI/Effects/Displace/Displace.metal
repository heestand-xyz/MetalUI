//
//  Created by Anton Heestand on 2023-06-14.
//  Copyright © 2023 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] float2 displace(float2 position,
                                 SwiftUI::Layer layer,
                                 float distance) {
    // Layer does still not work with distortion effects as of 2025
    // https://github.com/robb/ShaderBugs
    half4 color = layer.sample(position);
    float2 offset = float2(color.rg) * distance;
    return position - offset;
}
