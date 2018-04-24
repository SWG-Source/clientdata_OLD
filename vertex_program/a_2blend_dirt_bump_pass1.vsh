//asm
#define maxTextureCoordinate      3
#define vTextureCoordinateSetDTLA vTextureCoordinateSet0
#define vTextureCoordinateSetDTLB vTextureCoordinateSet1
#define vTextureCoordinateSetMASK vTextureCoordinateSet2
#define vTextureCoordinateSetDIRT vTextureCoordinateSet3

TARGET

#include "vertex_program/modules/registers.inc"


dcl_position0 vPosition
dcl_normal    vNormal
#include "vertex_program/modules/texture_coordinates.inc"

#include "vertex_program/modules/transform.inc"
#include "vertex_program/modules/fog_setup.inc"
#include "vertex_program/modules/fog.inc"

mov oT0, vTextureCoordinateSetDTLA
mov oT1, vTextureCoordinateSetDTLB
mov oT2, vTextureCoordinateSetMASK
mov oT3, vTextureCoordinateSetDIRT
