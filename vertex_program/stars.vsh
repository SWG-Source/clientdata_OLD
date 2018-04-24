//hlsl vs_1_1

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position  : POSITION0  : register(v0);
	float4  diffuse   : COLOR0     : register(v5);
};

struct OutputVertex
{
	float4  position               : POSITION0;
	float4  diffuse                : COLOR0;
	float   fog                    : FOG;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// copy color
	outputVertex.diffuse = inputVertex.diffuse;

	// turn off fog
	outputVertex.fog = 1.f;

	return outputVertex;
}

