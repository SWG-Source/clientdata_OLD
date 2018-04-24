//hlsl vs_1_1 vs_2_0

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct Input
{

	float4  position              : POSITION0  : register(v1);
	float4  diffuse               : COLOR0     : register(v5);
	DECLARE_textureCoordinateSets
};

struct Output
{
	float4  position              : POSITION0;
	float4  diffuse               : COLOR0;
	float   fog                   : FOG;
	float2  textureCoordinateSet0 : TEXCOORD0;
};

Output main(Input vertex)
{
	Output output;

	// transform vertex
	output.position = mul(vertex.position, objectWorldCameraProjectionMatrix);

	// calculate fog
	output.fog = calculateFog(vertex.position);

	// copy lighting
	output.diffuse = vertex.diffuse;

	// copy lighting
	output.textureCoordinateSet0 = vertex.textureCoordinateSetMAIN;

	return output;
}
