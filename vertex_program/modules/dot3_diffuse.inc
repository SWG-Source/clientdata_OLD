// ======================================================================
//
// inputs:
//
//   r7       = cell/ambient lighting
//   r9.xyz   = vertex in world space
//   r10.xyz  = normal in world space (re-normalized)
//
// outputs:
//
//   oD0      = diffuse light
//
// ======================================================================

// ----------------------------------------------------------------------
// ignore diffuse/specular light 1 because it's going to be the dot3 light

// ----------------------------------------------------------------------
// calculate diffuse parallel light 1

dp3 r0, r10, cLightData_parallel_0_direction
max r0, r0, c0_0
mad r7, r0, cLightData_parallel_0_diffuseColor, r7

// ----------------------------------------------------------------------
//  calculate diffuse parallel light 2

dp3 r0, r10, cLightData_parallel_1_direction
max r0, r0, c0_0
mad r7, r0, cLightData_parallel_1_diffuseColor, r7

// ----------------------------------------------------------------------
//  calculate diffuse/specular point light 1

// calculate unit vector from vertex to light and set up for attenuation calculation
sub r0.xyz, cLightData_pointSpecular_0_position, r9
dp3 r1, r0, r0                                 // r1 = d*d, d*d, d*d, d*d
rsq r2, r1.w                                   // r2 = 1/d, 1/d, 1/d, 1/d
mul r0.xyz, r0, r2

// calculate attenuation
dst r1, r1, r2
dp3 r1, r1, cLightData_pointSpecular_0_attenuation
rcp r1, r1.w

// calculate diffuse and specular lighting
dp3 r0, r10, r0
max r0, r0, c0_0
mul r0, r0, r1
mad r7, cLightData_pointSpecular_0_diffuseColor, r0.y, r7

// ----------------------------------------------------------------------
//  calculate diffuse point light 1

// calculate unit vector from vertex to light and set up for attenuation calculation
sub r0.xyz, cLightData_point_0_position, r9
dp3 r1, r0, r0
rsq r2, r1.w
mul r0.xyz, r0, r2

// calculate attenuation
dst r1, r1, r2
dp3 r1, r1, cLightData_point_0_attenuation
rcp r1, r1.w

// calculate diffuse and  lighting
dp3 r0, r10, r0
max r0, r0, c0_0
mul r0, r0, r1
mad r7, cLightData_point_0_diffuseColor, r0, r7

// ----------------------------------------------------------------------
//  calculate diffuse point light 2

// calculate unit vector from vertex to light and set up for attenuation calculation
sub r0.xyz, cLightData_point_1_position, r9
dp3 r1, r0, r0
rsq r2, r1.w
mul r0.xyz, r0, r2

// calculate attenuation
dst r1, r1, r2
dp3 r1, r1, cLightData_point_1_attenuation
rcp r1, r1.w

// calculate diffuse and  lighting
dp3 r0, r10, r0
max r0, r0, c0_0
mul r0, r0, r1
mad r7, cLightData_point_1_diffuseColor, r0, r7

// ----------------------------------------------------------------------
//  calculate diffuse point light 3

// calculate unit vector from vertex to light and set up for attenuation calculation
sub r0.xyz, cLightData_point_2_position, r9
dp3 r1, r0, r0
rsq r2, r1.w
mul r0.xyz, r0, r2

// calculate attenuation
dst r1, r1, r2
dp3 r1, r1, cLightData_point_2_attenuation
rcp r1, r1.w

// calculate diffuse and  lighting
dp3 r0, r10, r0
max r0, r0, c0_0
mul r0, r0, r1
mad r7, cLightData_point_2_diffuseColor, r0, r7

// ----------------------------------------------------------------------
//  calculate diffuse point light 4

// calculate unit vector from vertex to light and set up for attenuation calculation
sub r0.xyz, cLightData_point_3_position, r9
dp3 r1, r0, r0
rsq r2, r1.w
mul r0.xyz, r0, r2

// calculate attenuation
dst r1, r1, r2
dp3 r1, r1, cLightData_point_3_attenuation
rcp r1, r1.w

// calculate diffuse and  lighting
dp3 r0, r10, r0
max r0, r0, c0_0
mul r0, r0, r1
mad r7, cLightData_point_3_diffuseColor, r0, r7

// ----------------------------------------------------------------------
//  store final diffuse and specular lighting colors, add in material emissive color

//mov oD0, r7
add oD0, r7, cMaterial_emissiveColor

// ======================================================================
