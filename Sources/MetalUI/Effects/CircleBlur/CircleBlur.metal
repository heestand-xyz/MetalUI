//
//  Created by Anton Heestand on 2023-06-09.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//[[ stitchable ]] half4 circleBlur(float2 position, SwiftUI::Layer layer, float radius) {
//    
//    return half4(position.x, position.y, 0.0, 1.0);
//    
////    float pi = M_PI_F;
////
////    float u = out.texCoord[0];
////    float v = out.texCoord[1];
////
////    uint iw = texture.get_width();
////    uint ih = texture.get_height();
////    float aspect = float(iw) / float(ih);
////
////    int res = uniforms.count;
////
////    float4 color = 0.0;
////    float amounts = 1.0;
////    for (int i = 0; i < res * 3; ++i) {
////        float fraction = float(i) / float(res * 3);
////        float xu = u;
////        float yv = v;
////        float ang = fraction * pi * 2;
////        xu += cos(ang) * uniforms.radius;
////        yv += (sin(ang) * uniforms.radius) * aspect;
////        float4 c = texture.sample(sampler, float2(xu, yv));
////        float3 hsv = rgb2hsv(c.r, c.g, c.b);
////        if ((hsv.z >= uniforms.brightnessLow && hsv.z <= uniforms.brightnessHigh) && (hsv.y >= uniforms.saturationLow && hsv.y <= uniforms.saturationHigh)) {
////            color += c;
////            amounts += 1.0;
////        }
////    }
////
////    color /= amounts;
////    color *= uniforms.light;
////
////    return color;
//}
