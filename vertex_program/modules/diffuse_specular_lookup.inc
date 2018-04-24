// ======================================================================
//
// inputs:
//
//   r7       = cell/ambient lighting
//   r9.xyz   = vertex in world space
//   r10.xyz  = normal in world space (re-normalized)
//   r11.xyz  = unit vector from vertex to camera
//
// outputs:
//
//   oD0      = diffuse light
//   oD1      = specular light
//
// ======================================================================

// ----------------------------------------------------------------------
//  calculate diffuse/specular parallel light 1
	
// calculate the half angle (H = L + V / |L + V|)
add r1.xyz, cLightData_parallelSpecular_0_direction, r11
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1, r1.w
	
//H dot N into a UV2 for the specular lookup
dp3 oT2.xyz, r1, r10

// calculate diffuse and specular lighting
dp3 r0.x, r10, cLightData_parallelSpecular_0_direction
dp3 r0.y, r10, r1
mov r0.w, cMaterial_specularPower
lit r0, r0

dp3 r0, r10, cLightData_parallelSpecular_0_direction
add r7, cExtLtData_parallelSpec_0_tangentColor, r7
max r1, r0, c0_0
mad r7, cExtLtData_parallelSpec_0_tangentMinusDiffuse, -r1.y, r7
min r1, r0, c0_0
mad r7, cExtLtData_parallelSpec_0_tangentMinusBack, r1.y, r7

//mul r8, cLightData_parallelSpecular_0_specularColor, r0.z

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

// calculate the half angle (H = L + V / |L + V|)
add r2.xyz, r0, r11
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2, r2.w

// calculate diffuse and specular lighting
dp3 r0.x, r10, r0
dp3 r0.y, r10, r2
mov r0.w, cMaterial_specularPower
lit r0, r0
mul r0, r0, r1
mad r7, cLightData_pointSpecular_0_diffuseColor, r0.y, r7
//mad r8, cLightData_pointSpecular_0_specularColor, r0.z, r8
mul r8, cLightData_pointSpecular_0_specularColor, r0.z

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
mul oD1, r8, cMaterial_specularColor

// ======================================================================
