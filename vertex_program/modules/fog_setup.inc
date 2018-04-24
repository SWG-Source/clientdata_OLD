// ======================================================================
// inputs:
//
//   none
//
// outputs:
//
//   r9.xyz   = vertex in world space
//   r11.xyz  = unit vector from vertex to camera
//   r11.w    = distance squared from vertex to camera
//
// ======================================================================

// ----------------------------------------------------------------------
// transform vertex position into world space

m4x3 r9.xyz, vPosition, cObjectWorldMatrix

// ----------------------------------------------------------------------
//  calculate the direction to the viewer

sub r11.xyz, cCameraPosition, r9
dp3 r11.w, r11, r11
rsq r0.w, r11.w
mul r11.xyz, r11, r0.w
