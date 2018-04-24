//asm
TARGET

#include "vertex_program/modules/registers.inc"

dcl_position0 vPosition
dcl_normal0   vNormal
dcl_color0    vColor0
dcl_texcoord0 vTextureCoordinateSet0

#include "vertex_program/modules/transform.inc"
#include "vertex_program/modules/lighting_fog_setup.inc"
#include "vertex_program/modules/fog.inc"
#include "vertex_program/modules/ambient.inc"
#include "vertex_program/modules/diffuse.inc"
#include "vertex_program/modules/vertex_diffuse.inc"

// -- set up diffuse texture coordinates
mov oT0.xy, vTextureCoordinateSet0
