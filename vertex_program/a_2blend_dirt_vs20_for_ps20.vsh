//hlsl vs_2_0

#define textureCoordinateSetDTLA	textureCoordinateSet0
#define textureCoordinateSetDTLB	textureCoordinateSet1
#define textureCoordinateSetMASK	textureCoordinateSet2
#define textureCoordinateSetDIRT	textureCoordinateSet3
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);\
	float2 textureCoordinateSet1 : TEXCOORD1 : register(v8);\
	float2 textureCoordinateSet2 : TEXCOORD2 : register(v9);\
	float2 textureCoordinateSet3 : TEXCOORD3 : register(v10);
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
	float4  position        : POSITION0;
	float3  diffuse         : COLOR0;
	float   fog             : FOG;
	float2  tcs_DTLA 	: TEXCOORD0;
	float2  tcs_DTLB 	: TEXCOORD1;
	float2  tcs_MASK 	: TEXCOORD2;
	float2  tcs_DIRT 	: TEXCOORD3;
	float3  normal_o	: TEXCOORD4;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// copy texture coordinates
	outputVertex.tcs_DTLA = inputVertex.textureCoordinateSetDTLA;
	outputVertex.tcs_DTLB = inputVertex.textureCoordinateSetDTLB;
	outputVertex.tcs_MASK = inputVertex.textureCoordinateSetMASK;
	outputVertex.tcs_DIRT = inputVertex.textureCoordinateSetDIRT;

	// calculate lighting
	outputVertex.diffuse  = lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting(true, inputVertex.position, inputVertex.normal);

	// store vertex normal
	outputVertex.normal_o = inputVertex.normal;

	return outputVertex;
}
