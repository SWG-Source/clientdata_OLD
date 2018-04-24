//hlsl vs_2_0

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position              : POSITION0  : register(v0);
	float4  normal                : NORMAL0    : register(v3);
	float4  color                 : COLOR0     : register(v5);
	float2  textureCoordinateSet0 : TEXCOORD0  : register(v7);
};

struct OutputVertex
{
	float4  position              : POSITION0;
	float4  diffuse               : COLOR0;
	float4  color                 : COLOR1;
	float   fog                   : FOG;
	float3  textureCoordinateSet0 : TEXCOORD0;
	float2  textureCoordinateSet1 : TEXCOORD1;
	float emissive                : TEXCOORD2;
	float3 eyeVector_t            : TEXCOORD3;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// calculate lighting
	outputVertex.diffuse  = lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting(true, inputVertex.position, inputVertex.normal);
	outputVertex.diffuse  = min(outputVertex.diffuse, 1.0f) * inputVertex.color;

	// pass vertex color along for per-pixel lighting.
	outputVertex.color = inputVertex.color;

	// copy texture coordinates
	outputVertex.textureCoordinateSet0 = transformTerrainDot3LightDirection(inputVertex.normal);
	outputVertex.textureCoordinateSet1 = inputVertex.textureCoordinateSet0;

	outputVertex.emissive = intensity(material.emissiveColor);

	outputVertex.eyeVector_t  = transformTerrainDot3(normalize(lightData.dot3[0].cameraPosition_o - inputVertex.position), inputVertex.normal);

	return outputVertex;
}
