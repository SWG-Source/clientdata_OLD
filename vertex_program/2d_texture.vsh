//hlsl vs_1_1 vs_2_0

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct Input
{
	float4  position  : POSITION0  : register(v0);
	DECLARE_textureCoordinateSets
};

struct Output
{
	float4  position  : POSITION0;
	float2  textureCoordinateSet0 : TEXCOORD0;
};

Output main(Input vertex)
{
	Output output;

	// transform vertex
	output.position = transform2d(vertex.position);
	output.textureCoordinateSet0 = vertex.textureCoordinateSetMAIN;
	return output;
}
