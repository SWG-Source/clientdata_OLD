//hlsl vs_1_1 vs_2_0

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct Input
{
	float4  position              : POSITION0  : register(v0);
	float2  textureCoordinateSet0 : TEXCOORD0  : register(v7);
};

struct Output
{
	float4  position              : POSITION0;
	float2  textureCoordinateSet0 : TEXCOORD0;
	float2  textureCoordinateSet1 : TEXCOORD1;
};

Output main(Input vertex)
{
	Output output;

	// transform vertex
	output.position = transform2d(vertex.position);

	// copy texture coordinates
	output.textureCoordinateSet0 = vertex.textureCoordinateSet0;
	output.textureCoordinateSet1 = vertex.textureCoordinateSet0;

	return output;
}
