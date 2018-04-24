//asm
TARGET

#include "vertex_program/modules/registers.inc"

dcl_position0 vPosition
dcl_normal0   vNormal

//-- transform the vertex position into camera space
m4x4 oPos, vPosition, cObjectWorldCameraProjectionMatrix

//-- transform the normal into world space
m3x3 r0.xyz, vNormal, cObjectWorldMatrix

//-- compute direction to eye
m4x3 r1.xyz, vPosition, cObjectWorldMatrix
sub r2.xyz, cCameraPosition, r1

//-- normalize direction to eye
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2, r2.w

//-- compute texture coordinates
dp3 oT0.x, r0, r2
mov oT0.y, c0_0
