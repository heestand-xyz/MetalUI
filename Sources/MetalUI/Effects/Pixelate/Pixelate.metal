//
//  Created by Anton Heestand on 2023-06-15.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] half4 pixelate(float2 position,
                                SwiftUI::Layer layer,
                                float4 frame,
                                float fraction) {
    
    float width = frame[2];
    float height = frame[3];
    float aspectRatio = width / height;
    
    float u = position.x / width;
    float v = position.y / height;
    float2 uv = float2(u, v);
    
    float coordinate = min(max(fraction, 0.0), 1.0);
//    coordinate = 1.0 / float(int(1.0 / coordinate));
//    coordinate = pow(1.0 / float(int(pow(1.0 / coordinate, 0.5))), 2.0);
    float2 scale = float2(coordinate / aspectRatio, coordinate);
    float2 pixelUV = fraction > 0.0 ? float2(int2(round((uv - 0.5) / scale))) * scale + 0.5 : uv;
    
    float2 samplePosition = float2(pixelUV.x * width,
                                   pixelUV.y * height);
    
    half4 color = layer.sample(samplePosition);
    
    return color;
}
