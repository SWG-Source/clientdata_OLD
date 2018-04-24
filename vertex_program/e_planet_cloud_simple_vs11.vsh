//hlsl vs_1_1

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
	float4  position              	: POSITION0;
	float4  diffuse               	: COLOR0;
	float   fog                   	: FOG;
	float2  textureCoordinateSet0 	: TEXCOORD0;
	float  	falloff			: TEXCOORD1;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// calculate lighting
	outputVertex.diffuse  = lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting(false, inputVertex.position, inputVertex.normal);
	outputVertex.diffuse = saturate(outputVertex.diffuse);

	// copy texture coordinates
	outputVertex.textureCoordinateSet0 = inputVertex.textureCoordinateSetMAIN;
	
	//Setup edge softing on cloud layer
	// transform vertex normal from object space to world space to send to ps for lighting
	float3 normal_w = rotateNormalize_o2w(inputVertex.normal);
	
	// transform view direction from object space to world space to send to ps for env mapping
	float3 viewer_w = calculateViewerDirection_w(inputVertex.position);

	outputVertex.falloff = saturate(dot(normal_w, viewer_w)*6.0f);

	return outputVertex;
}