//
//  Created by Anton Heestand on 2023-06-14.
//  Copyright © 2023 Anton Heestand. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] float2 displace(float2 position,
                                 texture2d<half> image,
                                 float distance) {
    // https://github.com/robb/ShaderBugs//
    return position;
}
