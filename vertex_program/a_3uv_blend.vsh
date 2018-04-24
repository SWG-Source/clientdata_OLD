//asm
#define maxTextureCoordinate      2
#define vTextureCoordinateSetDCAL vTextureCoordinateSet0
#define vTextureCoordinateSetMAIN vTextureCoordinateSet1
#define vTextureCoordinateSetMASK vTextureCoordinateSet2

TARGET

#include "vertex_program/modules/registers.inc"


dcl_position0 vPosition
dcl_normal    vNormal
#include "vertex_program/modules/texture_coordinates.inc"

#include "vertex_program/modules/transform.inc"
#include "vertex_program/modules/lighting_fog_setup.inc"
#include "vertex_program/modules/fog.inc"
#include "vertex_program/modules/ambient.inc"
#include "vertex_program/modules/diffuse.inc"

mov oT0, vTextureCoordinateSetDCAL
mov oT1, vTextureCoordinateSetMAIN
mov oT2, vTextureCoordinateSetMASK
