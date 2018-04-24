//hlsl vs_2_0

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
	float4  position	: POSITION0;
	float   fog     	: FOG;
	float2  tcs_MAIN	: TEXCOORD0;
	float3  normal_o	: TEXCOORD1;
	float3  viewer_o	: TEXCOORD2;
	float3  position_o      : TEXCOORD3;

};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// copy texture coordinates
	outputVertex.tcs_MAIN = inputVertex.textureCoordinateSetMAIN;

	// transform vertex normal from object space to world space to send to ps for lighting
	outputVertex.normal_o = normalize(inputVertex.normal);
	
	// transform view direction from object space to world space to send to ps for env mapping
	outputVertex.viewer_o = calculateViewerDirection_o(inputVertex.position);

	outputVertex.position_o.x = inputVertex.position.y;
	outputVertex.position_o.y = textureScroll.x;
	outputVertex.position_o.z = textureScroll.y;

	return outputVertex;
}