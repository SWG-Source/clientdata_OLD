//hlsl vs_1_1 vs_2_0

#define textureCoordinateSetBLN0	textureCoordinateSet0
#define textureCoordinateSetBLN1	textureCoordinateSet1
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7); \
	float2 textureCoordinateSet1 : TEXCOORD1 : register(v8);

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position              : POSITION0  : register(v0);
	DECLARE_textureCoordinateSets
};

struct OutputVertex
{
	float4  position              : POSITION0;
	float2  textureCoordinateSet0 : TEXCOORD0;
	float2  textureCoordinateSet1 : TEXCOORD1;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// copy texture coordinates
	outputVertex.textureCoordinateSet0 = inputVertex.textureCoordinateSetBLN0;
	outputVertex.textureCoordinateSet1 = inputVertex.textureCoordinateSetBLN1;

	return outputVertex;
}
