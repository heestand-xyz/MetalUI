//
//  Created by Anton Heestand on 2023-06-09.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] half4 gradientBlurPass(float2 position,
                                        SwiftUI::Layer layer,
                                        float4 bounds,
                                        float axis,
                                        float multiplier,
                                        float curve,
                                        device const float *locations,
                                        int locationCount,
                                        device const float *radii,
                                        int radiusCount) {
    if (locationCount == 0 || radiusCount == 0) {
        return layer.sample(position);
    }
    
    float2 uv = position / bounds.zw;
    float pixelLocation = axis == 0.0 ? uv.x : uv.y;
    
    float lastLocation = locations[int(locationCount) - 1];
    bool isAtLast = pixelLocation >= lastLocation;
    float interpolatedRadius = isAtLast ? radii[int(locationCount) - 1] : radii[0];
    for (int index = 0; index < int(locationCount); index++) {
        float location = locations[index];
        float radius = radii[index];
        if (location >= pixelLocation) {
            if (index > 0) {
                float lastRadius = radii[index - 1];
                float lastLocation = locations[index - 1];
                float fraction = (pixelLocation - lastLocation) / (location - lastLocation);
                interpolatedRadius = lastRadius * (1.0 - fraction) + radius * fraction;
            }
            break;
        }
    }
    
    float maximumRadius = 0.0;
    for (int index = 0; index < int(radiusCount); index++) {
        float radius = radii[index];
        if (radius > maximumRadius) {
            maximumRadius = radius;
        }
    }
    
    float unitRadius = maximumRadius > 0.0 ? interpolatedRadius / maximumRadius : 0.0;
    unitRadius = unitRadius > 0.0 ? pow(unitRadius, 1.0 / curve) : 0.0;
    interpolatedRadius = unitRadius * maximumRadius;
    
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
        float2 offset = offsets[i] * interpolatedRadius * multiplier;
        result += layer.sample(position + offset) * weights[i];
    }
    
    return result;
}
