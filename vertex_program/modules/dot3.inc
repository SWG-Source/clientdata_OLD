// ======================================================================
// inputs:
//
//   none
//
// outputs:
//
//   oT0      = texture coordinate for NRML map
//   oT1      = directon to light (packed into 0..1 range)
//
// ======================================================================

// ----------------------------------------------------------------------
// transform the light direction into texture space, pack into 0..1 range

mov r0.xyz, vTextureCoordinateSetDOT3
mov r2.xyz, vNormal
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2,r2.w
mul r1.xyz, r2.zxy, r0.yzx
mad r1.xyz, r2.yzx, r0.zxy, -r1.xyz
mul r1.xyz, r1, vTextureCoordinateSetDOT3.w

m3x3 r0.xyz, cLightData_dot3_0_direction, r0
mad oT0.xyz, r0, c0_5, c0_5

mov oT1, vTextureCoordinateSetNRML
