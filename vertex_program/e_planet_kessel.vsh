//hlsl vs_1_1

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);

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
	float4  position              : POSITION0;
	float4  diffuse               : COLOR0;
	float   fog                   : FOG;
	float2  textureCoordinateMAIN : TEXCOORD0;
	float2  textureCoordinateDETA : TEXCOORD1;
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
	outputVertex.diffuse = calculateDiffuseLighting(false, inputVertex.position, inputVertex.normal);

	float4 singleLight = material.emissiveColor;
	singleLight += calculateDiffuseParallelLight((ParallelLight)lightData.parallelSpecular[0],inputVertex.normal);
	
	outputVertex.diffuse = saturate(singleLight * 2.25f);

	// copy texture coordinates
	outputVertex.textureCoordinateMAIN.x  = inputVertex.textureCoordinateSetMAIN.x;
	outputVertex.textureCoordinateMAIN.y  = 0.5f * inputVertex.textureCoordinateSetMAIN.y;

	outputVertex.textureCoordinateDETA.x  = 4.0f * inputVertex.textureCoordinateSetMAIN.x;
	outputVertex.textureCoordinateDETA.y  = 2.0f * inputVertex.textureCoordinateSetMAIN.y;

	return outputVertex;
}