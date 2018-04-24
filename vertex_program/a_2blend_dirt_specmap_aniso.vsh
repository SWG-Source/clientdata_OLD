//asm
#define maxTextureCoordinate      2
#define vTextureCoordinateSetDTLA vTextureCoordinateSet0
#define vTextureCoordinateSetDTLB vTextureCoordinateSet1
#define vTextureCoordinateSetDIRT vTextureCoordinateSet2

TARGET

#include "vertex_program/modules/registers.inc"


dcl_position0 vPosition
dcl_normal    vNormal
#include "vertex_program/modules/texture_coordinates.inc"

#include "vertex_program/modules/transform.inc"
#include "vertex_program/modules/lighting_fog_setup.inc"
#include "vertex_program/modules/fog.inc"
#include "vertex_program/modules/ambient.inc"
#include "vertex_program/modules/diffuse_specular_lookup_t3.inc"

mov oT0, vTextureCoordinateSetDTLA
mov oT1, vTextureCoordinateSetDTLB
mov oT2, vTextureCoordinateSetDIRT
