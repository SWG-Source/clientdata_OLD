//hlsl vs_1_1 vs_2_0

#define textureCoordinateSetDOT3	textureCoordinateSet0
#define textureCoordinateSetNRML	textureCoordinateSet1
#define textureCoordinateSetMAIN	textureCoordinateSet2
#define DECLARE_textureCoordinateSets	\
	float4 textureCoordinateSet0 : TEXCOORD0 : register(v7); \
	float2 textureCoordinateSet1 : TEXCOORD1 : register(v8); \
	float2 textureCoordinateSet2 : TEXCOORD2 : register(v9); 

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

	// Transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// Calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// Calculate lighting
	outputVertex.diffuse =  lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting(true, inputVertex.position, inputVertex.normal);

	// Setup for per-pixel lighting
	// leave the normal in -1..1 form because ps 2.0 can handle the full range
	outputVertex.textureCoordinateSet0 = transformDot3LightDirection(inputVertex.normal, inputVertex.textureCoordinateSetDOT3);
	
	// Copy texture coordinates
	outputVertex.textureCoordinateSet1 = inputVertex.textureCoordinateSetNRML;
	outputVertex.textureCoordinateSet2 = inputVertex.textureCoordinateSetMAIN;

	return outputVertex;
}