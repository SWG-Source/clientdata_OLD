//asm
TARGET

#include "vertex_program/modules/registers.inc"
dcl_position0 vPosition

//-- normalize position
mov r0, vPosition
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.xyz, r0.w
mov r1.y, r0.y
mul r0.y, r0.y, c0_5

mov oFog, c1_0

//-- transform the vertex position into camera space
m4x4 oPos, r0, cObjectWorldCameraProjectionMatrix

//-- compute texture coordinates
mov oT0.x, cUserConstant0.x
sub r1.y, c1_0, r1.y
mov oT0.y, r1.y
