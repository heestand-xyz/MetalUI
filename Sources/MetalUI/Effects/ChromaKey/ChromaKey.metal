//
//  Created by Anton Heestand on 2017-12-15.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "../../Shared/Effects/hsv_header.metal"

[[ stitchable ]] half4 chromaKey(float2 position,
                                 half4 color,
                                 half4 keyColor,
                                 float range,
                                 float softness,
                                 float edgeDesaturation,
                                 float alphaCrop) {
    
    float3 ck_hsv = rgb2hsv(keyColor.r, keyColor.g, keyColor.b);
    
    float4 c = float4(color);
    
    float3 c_hsv = rgb2hsv(c.r, c.g, c.b);
    
    float ck_h = abs(c_hsv[0] - ck_hsv[0]) - range;
    
    float ck = (ck_h + (softness) / 2) / softness;
    if (ck < 0.0) {
        ck = 0.0;
    } else if (ck > 1.0) {
        ck = 1.0;
    }
    
    ck = max(ck, 1.0 - c_hsv[1]);
    ck = max(ck, 1.0 - c_hsv[2]);
    
    float edge_sat = 1 - edgeDesaturation;
    if (edge_sat < 0) { edge_sat = 0; }
    else if (edge_sat > 1) { edge_sat = 1; }
    c_hsv[1] *= mix(edge_sat, 1.0, pow(ck, 10));
    
    float3 ck_c = hsv2rgb(c_hsv[0], c_hsv[1], c_hsv[2]);
    
    float invertedAlphaCrop = 1.0 - min(1.0, max(0.0, alphaCrop));
    ck = min(1.0, max(0.0, 1.0 - ((1.0 - ck) / invertedAlphaCrop)));
    
    // premultiply
    ck_c *= ck;
    
    float a = ck * c.a;
    
    return half4(ck_c.r, ck_c.g, ck_c.b, a);
}
