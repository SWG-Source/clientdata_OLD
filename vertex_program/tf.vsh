//asm
#define maxTextureCoordinate      0
#define vTextureCoordinateSetMAIN vTextureCoordinateSet0

TARGET

#include "vertex_program/modules/registers.inc"


dcl_position0 vPosition
#include "vertex_program/modules/texture_coordinates.inc"

#include "vertex_program/modules/transform.inc"
#include "vertex_program/modules/fog_setup.inc"
#include "vertex_program/modules/fog.inc"

mov oD0, cMaterial_diffuseColor

mov oT0, vTextureCoordinateSetMAIN
