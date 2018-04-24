//asm
#define maxTextureCoordinate      0
#define vTextureCoordinateSetMAIN vTextureCoordinateSet0

TARGET

#include "vertex_program/modules/registers.inc"


dcl_position0 vPosition
#include "vertex_program/modules/texture_coordinates.inc"


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

mov  r1, c0_5
mul  r1, r1, r1
mul  r1, r1, r1
mul  r2, r1, cCurrentTime
add  oT0.x, vTextureCoordinateSetMAIN.x, r2
add  oT0.y, vTextureCoordinateSetMAIN.y, r2
add  oT1.x, vTextureCoordinateSetMAIN.x, r2
add  oT1.y, vTextureCoordinateSetMAIN.y, r2

//-- compute alpha
mov oD0, c1_0
mov oD0.w, cUserConstant.x

