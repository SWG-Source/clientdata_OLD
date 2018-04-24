//hlsl vs_2_0

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define textureCoordinateSetNRML	textureCoordinateSet1
#define textureCoordinateSetDOT3	textureCoordinateSet2
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7); \
	float2 textureCoordinateSet1 : TEXCOORD1 : register(v8); \
	float4 textureCoordinateSet2 : TEXCOORD2 : register(v9);

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
	float4  position                : POSITION0;
	float3  diffuse                 : COLOR0;
	float3  specular                : COLOR1;
	float   fog                     : FOG;
	float2  tcs_MAIN		: TEXCOORD0;
	float2  tcs_NRML		: TEXCOORD1;
	float3  directionToLight_t	: TEXCOORD2;
	float3  halfAngle_t             : TEXCOORD3;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// calculate lighting
	DiffuseSpecular diffuseSpecular = calculateDiffuseSpecularLighting(true, inputVertex.position, inputVertex.normal);
	outputVertex.diffuse  = lightData.ambient.ambientColor + diffuseSpecular.diffuse;
	outputVertex.specular = diffuseSpecular.specular * material.specularColor;

	// copy texture coordinates
	outputVertex.tcs_MAIN = inputVertex.textureCoordinateSetMAIN;
	outputVertex.tcs_NRML = inputVertex.textureCoordinateSetNRML;

	// setup for per-pixel lighting
	outputVertex.directionToLight_t = calculateDot3LightDirection_t(inputVertex.normal, inputVertex.textureCoordinateSetDOT3);
	outputVertex.halfAngle_t = calculateHalfAngle_t(inputVertex.position, inputVertex.normal, inputVertex.textureCoordinateSetDOT3);

	return outputVertex;
}
