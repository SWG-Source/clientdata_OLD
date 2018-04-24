//hlsl vs_1_1

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define textureCoordinateSetDETA	textureCoordinateSet1

#define DECLARE_textureCoordinateSets \
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);\
	float2 textureCoordinateSet1 : TEXCOORD1 : register(v8);

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position        : POSITION0  : register(v0);
	float4  normal		: NORMAL0    : register(v3);
	DECLARE_textureCoordinateSets
};

struct OutputVertex
{
	float4  position        : POSITION0;
	float3  diffuse         : COLOR0;
	float   fog             : FOG;
	float2  tcs_MAIN 	: TEXCOORD0;
	float2  tcs_DETA 	: TEXCOORD1;
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
	outputVertex.diffuse += calculateDiffuseLighting(false, inputVertex.position, inputVertex.normal);

	// copy texture coordinates
	outputVertex.tcs_MAIN = inputVertex.textureCoordinateSetMAIN;
	outputVertex.tcs_DETA = inputVertex.textureCoordinateSetDETA;

	return outputVertex;
}
