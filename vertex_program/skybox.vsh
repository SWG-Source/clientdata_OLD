//hlsl vs_1_1 vs_2_0

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position              : POSITION0  : register(v0);
	float3  textureCoordinateSet0 : TEXCOORD0  : register(v7);
};

struct OutputVertex
{
	float4  position              : POSITION0;
	float   fog                   : FOG;
	float3  textureCoordinateSet0 : TEXCOORD0;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// copy texture coordinates
	outputVertex.textureCoordinateSet0 = inputVertex.textureCoordinateSet0;

	// turn off fog
	outputVertex.fog = 1.f;

	return outputVertex;
}

