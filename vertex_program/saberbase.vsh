//asm
#define maxTextureCoordinate      0
#define vTextureCoordinateSetMAIN vTextureCoordinateSet0

TARGET

#include "vertex_program/modules/registers.inc"


dcl_position0 vPosition
dcl_normal    vNormal
#include "vertex_program/modules/texture_coordinates.inc"

#include "vertex_program/modules/transform.inc"

//-- transform the normal into world space
m3x3 r0.xyz, vNormal, cObjectWorldMatrix

//-- compute direction to eye
m4x3 r1.xyz, vPosition, cObjectWorldMatrix
sub r2.xyz, cCameraPosition, r1

//-- normalize direction to eye
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2, r2.w

//-- compute texture coordinates for low angle fade
dp3 oT1.x, r0, r2
mov oT1.y, c0_0

mov oT0, vTextureCoordinateSetMAIN
