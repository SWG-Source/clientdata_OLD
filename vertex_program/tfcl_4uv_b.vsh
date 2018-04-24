//asm
#define maxTextureCoordinate      3
#define vTextureCoordinateSetDTLA vTextureCoordinateSet0
#define vTextureCoordinateSetDTLB vTextureCoordinateSet1
#define vTextureCoordinateSetMASK vTextureCoordinateSet2
#define vTextureCoordinateSetDCAL vTextureCoordinateSet3

TARGET

#include "vertex_program/modules/registers.inc"


dcl_position0 vPosition
dcl_normal0   vNormal
dcl_color0    vColor0
#include "vertex_program/modules/texture_coordinates.inc"

#include "vertex_program/modules/transform.inc"
#include "vertex_program/modules/lighting_fog_setup.inc"
#include "vertex_program/modules/fog.inc"
#include "vertex_program/modules/c_ambient.inc"
#include "vertex_program/modules/diffuse.inc"

mov oT0, vTextureCoordinateSetDTLA
mov oT1, vTextureCoordinateSetDTLB
mov oT2, vTextureCoordinateSetMASK
mov oT3, vTextureCoordinateSetDCAL
