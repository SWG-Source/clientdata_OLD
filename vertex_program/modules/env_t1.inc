// ======================================================================
// inputs:
//
//   r11.xyz  = unit vector from vertex to camera
//
// outputs:
//
//   oT1      = r11 reflected around normal
//
// ======================================================================

// normal * (2 * normal.dot(incident)) - incident;
dp3 r0, vNormal, r11
add r0, r0, r0
mad oT1, vNormal, r0, -r11
