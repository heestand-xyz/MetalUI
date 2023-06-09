//
//  Created by Anton Heestand on 2017-11-24.
//  Copyright © 2017 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "../../Shared/Content/noise_header.metal"
#import "../../Shared/Content/random_header.metal"

[[ stitchable ]] half4 noise(float2 position,
                             half4 color,
                             float2 size,
                             float octaves,
                             float2 offset,
                             float zOffset,
                             float scale,
                             float isColored,
                             float isRandom,
                             float seed) {
    
    int max_res = 16384 - 1;
    
    float width = size.x;
    float height = size.y;
    float aspectRatio = width / height;
    
    float u = position.x / width;
    float v = position.y / height;
    
    float ux = ((u - 0.5) * aspectRatio - (offset.x / height)) / scale;
    float vy = ((v - 0.5) - (offset.y / height)) / scale;
    float wz = zOffset / height;
    
    float noise;
    if (isRandom == 1.0) {
        Loki loki_rnd = Loki(seed, u * max_res, v * max_res);
        noise = loki_rnd.rand();
    } else {
        noise = octave_noise_3d(octaves, 0.5, 1.0, ux, vy, wz + seed * 100);
        noise = noise * 0.5 + 0.5;
    }
    
    float noiseGreen;
    float noiseBlue;
    if (isColored == 1.0) {
        if (isRandom == 1.0) {
            Loki loki_rnd_g = Loki(seed + 100, u * max_res, v * max_res);
            noiseGreen = loki_rnd_g.rand();
            Loki loki_rnd_b = Loki(seed + 200, u * max_res, v * max_res);
            noiseBlue = loki_rnd_b.rand();
        } else {
            noiseGreen = octave_noise_3d(octaves, 0.5, 1.0, ux, vy, wz + 10 + seed);
            noiseGreen = noiseGreen * 0.5 + 0.5;
            noiseBlue = octave_noise_3d(octaves, 0.5, 1.0, ux, vy, wz + 20 + seed);
            noiseBlue = noiseBlue * 0.5 + 0.5;
        }
    }
    
    float red = noise;
    float green = isColored ? noiseGreen : noise;
    float blue = isColored ? noiseBlue : noise;
    float4 noiseColor = float4(red, green, blue, 1.0);
    
    return half4(noiseColor);
}
