//asm
#define maxTextureCoordinate      3
#define vTextureCoordinateSetMAIN vTextureCoordinateSet0
#define vTextureCoordinateSetNRML vTextureCoordinateSet1
#define vTextureCoordinateSetDCAL vTextureCoordinateSet2
#define vTextureCoordinateSetDOT3 vTextureCoordinateSet3

TARGET

#include "vertex_program/modules/registers.inc"

dcl_position0 vPosition
dcl_normal    vNormal
#include "vertex_program/modules/texture_coordinates.inc"

#include "vertex_program/modules/transform.inc"
#include "vertex_program/modules/lighting_fog_setup.inc"
#include "vertex_program/modules/fog.inc"
#include "vertex_program/modules/ambient.inc"
#include "vertex_program/modules/dot3_diffuse.inc"
#include "vertex_program/modules/dot3.inc"

// ----------------------------------------------------------------------
//  calculate diffuse/specular parallel light 1 so I can send two different lighting values into pixel shader

// calculate diffuse and specular lighting
dp3 r0, r10, cLightData_parallelSpecular_0_direction
max r0, r0, c0_0
mad oD1, cLightData_parallelSpecular_0_diffuseColor, r0.y, r7

mov oT2, vTextureCoordinateSetMAIN
mov oT3, vTextureCoordinateSetDCAL
