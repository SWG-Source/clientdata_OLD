//hlsl vs_2_0

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position              : POSITION0  : register(v0);
	float4  normal                : NORMAL0    : register(v3);
	float4  color                 : COLOR0     : register(v5);
	float2  textureCoordinateSet0 : TEXCOORD0  : register(v7);
	float2  textureCoordinateSet1 : TEXCOORD1  : register(v8);
	float2  textureCoordinateSet2 : TEXCOORD2  : register(v9);
};

struct OutputVertex
{
	float4  position              : POSITION0;
	float4  diffuse               : COLOR0;
	float   fog                   : FOG;
	float2  textureCoordinateSet0 : TEXCOORD0;
	float2  textureCoordinateSet1 : TEXCOORD1;
	float2  textureCoordinateSet2 : TEXCOORD2;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// calculate lighting
	outputVertex.diffuse = lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting(false, inputVertex.position, inputVertex.normal);
	outputVertex.diffuse = min(outputVertex.diffuse, 1.0f) * inputVertex.color;

	// copy texture coordinates
	outputVertex.textureCoordinateSet0 = inputVertex.textureCoordinateSet0;
	outputVertex.textureCoordinateSet1 = inputVertex.textureCoordinateSet1;
	outputVertex.textureCoordinateSet2 = inputVertex.textureCoordinateSet2;

	return outputVertex;
}
