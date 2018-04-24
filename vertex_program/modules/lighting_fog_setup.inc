// ======================================================================
// inputs:
//
//   none
//
// outputs:
//
//   r9.xyz   = vertex in world space
//   r10.xyz  = normal in world space (re-normalized)
//   r11.xyz  = unit vector from vertex to camera
//   r11.w    = distance squared from vertex to camera
//
// ======================================================================

// ----------------------------------------------------------------------
// transform vertex position into world space

m4x3 r9.xyz, vPosition, cObjectWorldMatrix

// ----------------------------------------------------------------------
//  rotate vertex normal into world space and renormalize

m3x3 r10.xyz, vNormal, cObjectWorldMatrix
dp3 r10.w, r10, r10
rsq r10.w, r10.w
mul r10.xyz, r10, r10.w

// ----------------------------------------------------------------------
//  calculate the direction to the viewer

sub r11.xyz, cCameraPosition, r9
dp3 r11.w, r11, r11
rsq r0.w, r11.w
mul r11.xyz, r11, r0.w
	
