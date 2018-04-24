// ======================================================================
// inputs:
//
//   none
//
// outputs:
//
//   oT0      = texture coordinate for NRML map
//   oT1      = direction to light (-1 .. 1)
//   oT2      = half angle vector (-1 .. 1)
//
// ======================================================================

// build transform from object space to texture space
mov r0.xyz, vTextureCoordinateSetDOT3
mov r2.xyz, vNormal
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2,r2.w
mul r1.xyz, r2.zxy, r0.yzx
mad r1.xyz, r2.yzx, r0.zxy, -r1.xyz
mul r1.xyz, r1, vTextureCoordinateSetDOT3.w

// pass through normal map coordinates
mov oT0, vTextureCoordinateSetNRML
//m3x3 r3.xyz, vNormal, r0
//mad oT0.xyz, r3, c0_5, c0_5

// transform the light direction into texture space
m3x3 oT1.xyz, cLightData_dot3_0_direction, r0

// calculate the half angle (H = L + V / |L + V|)
sub r3.xyz, cLightData_dot3_0_cameraPosition, vPosition
dp3 r3.w, r3, r3
rsq r3.w, r3.w
mul r3.xyz, r3, r3.w
add r3.xyz, r3, cLightData_dot3_0_direction
dp3 r3.w, r3, r3
rsq r3.w, r3.w
mul r3.xyz, r3, r3.w

// transform half angle into texture space
m3x3 oT2.xyz, r3, r0


