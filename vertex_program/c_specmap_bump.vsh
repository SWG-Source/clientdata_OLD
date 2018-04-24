//asm
#define maxTextureCoordinate      2
#define vTextureCoordinateSetMAIN vTextureCoordinateSet0
#define vTextureCoordinateSetNRML vTextureCoordinateSet1
#define vTextureCoordinateSetDOT3 vTextureCoordinateSet2

TARGET

#include "vertex_program/modules/registers.inc"


dcl_position0 vPosition
dcl_normal    vNormal
dcl_color0    vColor0
#include "vertex_program/modules/texture_coordinates.inc"

#include "vertex_program/modules/transform.inc"
#include "vertex_program/modules/lighting_fog_setup.inc"
#include "vertex_program/modules/fog.inc"
#include "vertex_program/modules/c_ambient.inc"
#include "vertex_program/modules/dot3_diffuse.inc"
#include "vertex_program/modules/dot3_3x2spec.inc"

//oT0 = textureCoordinateSet[NRML]
//oT1 = light vector
//oT2 = half angle vector
mov oT3, vTextureCoordinateSetMAIN