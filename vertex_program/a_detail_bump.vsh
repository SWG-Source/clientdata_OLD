//asm
#define maxTextureCoordinate      3
#define vTextureCoordinateSetMAIN vTextureCoordinateSet0
#define vTextureCoordinateSetDETA vTextureCoordinateSet1
#define vTextureCoordinateSetDOT3 vTextureCoordinateSet2
#define vTextureCoordinateSetNRML vTextureCoordinateSet3

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

mov oT2, vTextureCoordinateSetMAIN
mov oT3, vTextureCoordinateSetDETA

