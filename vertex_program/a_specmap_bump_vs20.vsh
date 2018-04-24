//hlsl vs_1_1 vs_2_0

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define textureCoordinateSetNRML	textureCoordinateSet1
#define textureCoordinateSetDOT3	textureCoordinateSet2
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSetMAIN : TEXCOORD0 : register(v7); \
	float2 textureCoordinateSetNRML : TEXCOORD1 : register(v8); \
	float4 textureCoordinateSetDOT3 : TEXCOORD2 : register(v9);

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
	float4  position                       : POSITION0;
	float3  diffuse                        : COLOR0;
	float   fog                            : FOG;
	float2  normalMapTextureCoordinateSet  : TEXCOORD0;
	float3  directionToLight               : TEXCOORD1;
	float3  halfAngle                      : TEXCOORD2;
	float2  diffuseMapTextureCoordinateSet : TEXCOORD3;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// calculate lighting
	outputVertex.diffuse = lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting(true, inputVertex.position, inputVertex.normal);

	// copy texture coordinates
	outputVertex.normalMapTextureCoordinateSet = inputVertex.textureCoordinateSetNRML;
	outputVertex.directionToLight = transformDot3LightDirection(inputVertex.normal, inputVertex.textureCoordinateSetDOT3);
	outputVertex.halfAngle = transformHalfAngle(inputVertex.position, inputVertex.normal, inputVertex.textureCoordinateSetDOT3);
	outputVertex.diffuseMapTextureCoordinateSet = inputVertex.textureCoordinateSetMAIN;

	return outputVertex;
}
