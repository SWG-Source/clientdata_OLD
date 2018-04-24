// ======================================================================
// inputs:
//
//   r7       = cell/ambient lighting
//
// outputs:
//
//   oD0      = diffuse light
//
// ======================================================================

mul oD0, r7, cMaterialDiffuseColor
