//hlsl vs_1_1

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position        : POSITION0  : register(v0);
	float4  normal		: NORMAL0    : register(v3);
	DECLARE_textureCoordinateSets
};

struct OutputVertex
{
	float4 position 	: POSITION0;
	float3 diffuse  	: COLOR0;
	float  fog      	: FOG;
	float2 tcs_MAIN 	: TEXCOORD0;
	float2 tcs_MASK 	: TEXCOORD1;
	float3 tcs_ENVM		: TEXCOORD2;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// calculate reflection vector for env mapping
	float3 viewer_w = calculateViewerDirection_w(inputVertex.position);
	float3 normal_w = rotateNormalize_o2w(inputVertex.normal);
	outputVertex.tcs_ENVM = reflect(-viewer_w, normal_w);

	// calculate lighting
	outputVertex.diffuse  = lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting(false, inputVertex.position, inputVertex.normal);

	// copy texture coordinates
	outputVertex.tcs_MAIN = inputVertex.textureCoordinateSetMAIN;
	// must duplicate this for ps11
	outputVertex.tcs_MASK = inputVertex.textureCoordinateSetMAIN;

	return outputVertex;
}
