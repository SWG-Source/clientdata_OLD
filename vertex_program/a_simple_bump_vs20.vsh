//hlsl vs_1_1 vs_2_0

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define textureCoordinateSetNRML	textureCoordinateSet1
#define textureCoordinateSetDOT3	textureCoordinateSet2
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7); \
	float2 textureCoordinateSet1 : TEXCOORD1 : register(v8); \
	float4 textureCoordinateSet2 : TEXCOORD2 : register(v9);

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position              : POSITION0  : register(v0);
	float4  normal                : NORMAL0    : register(v3);
	DECLARE_textureCoordinateSets
};

struct OutputVertex
{
	float4  position               : POSITION0;
	float4  diffuse                : COLOR0;
	float   fog                    : FOG;
	float3  textureCoordinateSet0  : TEXCOORD0;
	float2  textureCoordinateSet1  : TEXCOORD1;
	float2  textureCoordinateSet2  : TEXCOORD2;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// calculate lighting
	outputVertex.diffuse =  lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting(true, inputVertex.position, inputVertex.normal);

	// setup for per-pixel lighting
	// leave the normal in -1..1 form because ps 2.0 can handle the full range
	outputVertex.textureCoordinateSet0 = transformDot3LightDirection(inputVertex.normal, inputVertex.textureCoordinateSetDOT3);
	outputVertex.textureCoordinateSet1 = inputVertex.textureCoordinateSetNRML;

	// copy texture coordinates
	outputVertex.textureCoordinateSet2 = inputVertex.textureCoordinateSetMAIN;

	return outputVertex;
}

