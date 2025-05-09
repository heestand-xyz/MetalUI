//
//  Created by Anton Heestand on 2023-06-09.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] half4 gradientLinearBlur(float2 position,
                                          SwiftUI::Layer layer,
                                          float4 bounds,
                                          float gradientAxis,
                                          float blurAxis,
                                          float detail,
                                          float curve,
                                          device const float *locations,
                                          int locationCount,
                                          device const float *radii,
                                          int radiusCount) {
    if (locationCount == 0 || radiusCount == 0) {
        return layer.sample(position);
    }
    
    float2 uv = position / bounds.zw;
    float pixelLocation = gradientAxis == 0.0 ? uv.x : uv.y;
    
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
    
    int count = int(detail);
    half4 result = 0.0;
    float weights = 0.0;
    for (int i = 0; i < count; i++) {
        float fraction = float(i) / float(count - 1);
        float extraFraction = float(i + 1) / float(count + 1);
        float vector = fraction * 2.0 - 1.0;
        float extraVector = extraFraction * 2.0 - 1.0;
        float weight = 1.0 - abs(extraVector);
        float2 rawOffset = float2(blurAxis == 0 ? vector : 0,
                                  blurAxis != 0 ? vector : 0);
        float2 offset = rawOffset * interpolatedRadius;
        result += layer.sample(position + offset) * weight;
        weights += weight;
    }
    result /= weights;
    
    return result;
}

[[ stitchable ]] half4 gradientLinearBlurPass(float2 position,
                                              SwiftUI::Layer layer,
                                              float4 bounds,
                                              float gradientAxis,
                                              float blurAxis,
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
    float pixelLocation = gradientAxis == 0.0 ? uv.x : uv.y;
    
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
    
    float2 offsets[3];
    
    if (blurAxis == 0.0) {
        offsets[0] = float2(-1, 0);
        offsets[1] = float2(0, 0);
        offsets[2] = float2(1, 0);
    } else {
        offsets[0] = float2(0, -1);
        offsets[1] = float2(0, 0);
        offsets[2] = float2(0, 1);
    }
    
    float weights[3] = { 0.25, 0.5, 0.25 };
    
    half4 result = 0.0;
    
    for (int i = 0; i < 3; i++) {
        float2 offset = offsets[i] * interpolatedRadius * multiplier;
        result += layer.sample(position + offset) * weights[i];
    }
    
    return result;
}
