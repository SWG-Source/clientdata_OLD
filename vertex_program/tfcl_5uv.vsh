//asm
#define maxTextureCoordinate      4
#define vTextureCoordinateSetDTLA vTextureCoordinateSet0
#define vTextureCoordinateSetDTLB vTextureCoordinateSet1
#define vTextureCoordinateSetMASK vTextureCoordinateSet2
#define vTextureCoordinateSetDIRT vTextureCoordinateSet3
#define vTextureCoordinateSetDCAL vTextureCoordinateSet4

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
mov oT3, vTextureCoordinateSetDIRT
mov oT4, vTextureCoordinateSetDCAL
