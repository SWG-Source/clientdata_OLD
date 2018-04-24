// ======================================================================
// inputs:
//
//   r11.w    = distance squared from vertex to camera
//
// outputs:
//
//   oFog
//
// ======================================================================

// ----------------------------------------------------------------------
// calculate fog

// (distance)^2 * (density)^2 = (distance * density)^2
mul r0.w, r11.w, cFog.w 
// log2(e) * (distance * density)^2
mul r0.w, cLog2e, r0.w
// 2^(log2(e) * (distance * density)^2) = (2^log2(e))^((distance * density)^2) = e^((distance * density)^2)
exp r0.w, r0.w
// 1 / (e^((distance * density)^2))
rcp oFog, r0.w
