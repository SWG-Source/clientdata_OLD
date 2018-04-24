// -- take vertex color into account for diffuse lighting
mul oD0, r7, vColor0

// -- store dot3 light modulated by vertex color
mul oD1, cLightData_dot3_0_diffuseColor, vColor0

// -- transform the light direction into texture space, sign and bias
//m3x3 r0.xyz, cLightData_dot3_0_direction, vTextureCoordinateSet0
//mad oT2.xyz, r0, c0_5, c0_5

// -- r10 = j (-z) = normal.cross (unitX)
mul r10, vNormal.yzxw, cUnitX.zxyw
mad r10, -cUnitX.yzxw, vNormal.zxyw, r10

// -- r9  = i (x) = j.cross (normal)
mul r9, r10.yzxw, vNormal.zxyw
mad r9, -vNormal.yzxw, r10.zxyw, r9

//m3x3 r5, v0, c[3]
dp3 r0.x, cLightData_dot3_0_direction, r9
dp3 r0.y, cLightData_dot3_0_direction, r10
dp3 r0.z, cLightData_dot3_0_direction, vNormal
mad oT2.xyz, r0, c0_5, c0_5
