//hlsl vs_1_1 vs_2_0

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
	float2  textureCoordinateSet0 : TEXCOORD0;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	//-- transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	//-- dot the direction to the eye with the interpolated normal
	float3 directionToCamera = calculateViewerDirection_w(inputVertex.position);
	float3 normal_w = rotateNormalize_o2w(inputVertex.normal);
	outputVertex.textureCoordinateSet0.x = dot(directionToCamera, normal_w);
	outputVertex.textureCoordinateSet0.y = 0;
	
	return outputVertex;
}
