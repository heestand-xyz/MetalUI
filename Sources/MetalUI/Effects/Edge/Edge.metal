//
//  Created by Anton Heestand on 2023-06-15.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] half4 edge(float2 position,
                            SwiftUI::Layer layer,
                            float distance,
                            float strength,
                            float pixelsPerPoint,
                            float darkMode) {
    
    float offset = distance / pixelsPerPoint;
    
    half4 center = layer.sample(position);
    half4 right = layer.sample(float2(position.x + offset, position.y));
    half4 left = layer.sample(float2(position.x - offset, position.y));
    half4 down = layer.sample(float2(position.x, position.y + offset));
    half4 up = layer.sample(float2(position.x, position.y - offset));
    
    half4 colorEdge = (abs(center - right) + abs(center - left) + abs(center - down) + abs(center - up)) * strength;
    half monochromeEdge = (colorEdge.r + colorEdge.g + colorEdge.b) / 3;
    half alphaEdge = colorEdge.a;
    half edge = max(monochromeEdge, alphaEdge);
    
    return half4(half3(darkMode == 1.0 ? 1.0 : 0.0) * edge, edge);
}
