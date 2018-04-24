//hlsl vs_1_1

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position              : POSITION0  : register(v0);
	float4  normal                : NORMAL0    : register(v3);
};

struct OutputVertex
{
	float4  position              : POSITION0;
	float3  normal_o	: TEXCOORD0;
	float3  viewer_o	: TEXCOORD1;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	float3 temp = float3(1.0, 1.0, 0.5);

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// transform vertex normal from object space to world space to send to ps for lighting
	outputVertex.normal_o = normalize(inputVertex.normal);
	//outputVertex.normal_o = temp;
	
	// transform view direction from object space to world space to send to ps for env mapping
	outputVertex.viewer_o = calculateViewerDirection_o(inputVertex.position);
	//outputVertex.viewer_o = temp;

	return outputVertex;
}