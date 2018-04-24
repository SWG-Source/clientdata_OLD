//asm
TARGET

#include "vertex_program/modules/registers.inc"
dcl_position0 vPosition
dcl_normal0   vNormal
dcl_texcoord0 vTextureCoordinateSet0
dcl_texcoord1 vTextureCoordinateSet1

// r7  = cummulative diffuse lighting
// r8  = cummulative specular lighting
// r9  = vertex in world space
// r10 = normal in world space
// r11 = vector to viewer

// -- transform vertex to projection space
m4x4 oPos, vPosition, cObjectWorldCameraProjectionMatrix

// -- transform vertex position into world space
m4x3 r9.xyz, vPosition, cObjectWorldMatrix

// -- rotate vertex normal into world space and renormalize
m3x3 r10.xyz, vNormal, cObjectWorldMatrix
dp3 r10.w, r10, r10
rsq r10.w, r10.w
mul r10.xyz, r10, r10.w

// -- calculate the direction to the viewer
sub r11.xyz, cCameraPosition, r9
dp3 r11.w, r11, r11
rsq r0.w, r11.w
mul r11.xyz, r11, r0.w

// -- calculate fog
// (distance)^2 * (density)^2 =
// (distance * density)^2
mul r0.w, r11.w, cFog.w 
// log2(e) * (distance * density)^2
mul r0.w, cLog2e, r0.w
// 2^(log2(e) * (distance * density)^2) = 
// (2^log2(e))^((distance * density)^2)
// e^((distance * density)^2)
exp r0.w, r0.w
// 1 / (e^((distance * density)^2))
rcp oFog, r0.w

// -- calculate ambient light
mov r7, cLightData_ambient_ambientColor

// -- calculate diffuse & specular parallel light 1
dp3 r0, r10, cLightData_parallelSpecular_0_direction
max r0, r0, c0_0
mad r7, r0, cLightData_parallelSpecular_0_diffuseColor, r7

// -- calculate diffuse parallel light 1
dp3 r0, r10, cLightData_parallel_0_direction
max r0, r0, c0_0
mad r7, r0, cLightData_parallel_0_diffuseColor, r7

// -- calculate diffuse parallel light 2
dp3 r0, r10, cLightData_parallel_1_direction
max r0, r0, c0_0
mad r7, r0, cLightData_parallel_1_diffuseColor, r7

// -- store final colors
mov oD0, r7

// -- set up diffuse texture coordinates
add  oT0.xy, vTextureCoordinateSet0.xy, cTextureScroll.xy

// -- set up normal map texture coordinates
add  oT1.xy, vTextureCoordinateSet0.xy, cTextureScroll.xy

// -- transform the light direction into texture space, sign and bias
mov r0.xyz, vTextureCoordinateSet1
mov r2.xyz, vNormal
mul r1.xyz, r2.zxy, r0.yzx
mad r1.xyz, r2.yzx, r0.zxy, -r1.xyz
mul r1.xyz, r1, vTextureCoordinateSet1.w

m3x3 r0.xyz, cLightData_dot3_0_direction, r0
mad oT2.xyz, r0, c0_5, c0_5
