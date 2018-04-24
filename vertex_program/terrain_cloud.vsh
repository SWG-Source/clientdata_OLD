//asm
TARGET

#include "vertex_program/modules/registers.inc"
dcl_position0 vPosition

//-- transform the vertex position into camera space
m4x4 oPos, vPosition, cObjectWorldCameraProjectionMatrix

// -- transform vertex position into world space
m4x3 r9.xyz, vPosition, cObjectWorldMatrix

// -- calculate the direction to the viewer
sub r11.xyz, cCameraPosition, r9
dp3 r11.w, r11, r11
rsq r0.w, r11.w
mul r11.xyz, r11, r0.w

// -- calculate fog
// (distance)^2 * (density)^2 =
// (distance * density)^2
mul r0.w, r11.w, cFog.w 
// log2(e) * (distance * density)^2
mul r0.w, cLog2e, r0.w
// 2^(log2(e) * (distance * density)^2) = 
// (2^log2(e))^((distance * density)^2)
// e^((distance * density)^2)
exp r0.w, r0.w
// 1 / (e^((distance * density)^2))
rcp oFog, r0.w

//-- compute texture coordinates
mov  r1, c1_0
add  r1, r1, r1
mul  r1, r1, r1
mul  r1, r1, r1
mul  r1, r1, r1
rcp  r1, r1.w
mul  r1.x, r1.x, vPosition.x
mul  r1.z, r1.z, vPosition.z
mov  r2, c0_5
mul  r2, r2, r2
mul  r2, r2, r2
mul  r2, r2, r2
mul  r2, r2, cCurrentTime
add  oT0.x, r1.x, r2.x
add  oT0.y, r1.z, -r2.z
