//hlsl vs_1_1 vs_2_0

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct Input
{
	float4  position  : POSITION0  : register(v0);
	float4  diffuse   : COLOR0     : register(v5);
};

struct Output
{
	float4  position  : POSITION0;
	float4  diffuse   : COLOR0;
};

Output main(Input vertex)
{
	Output output;

	// transform vertex
	output.position = transform2d(vertex.position);

	// calculate lighting
	output.diffuse = vertex.diffuse;

	return output;
}
