//hlsl vs_1_1

#define textureCoordinateSetDTLA	textureCoordinateSet0
#define textureCoordinateSetDIRT	textureCoordinateSet1
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);\
	float2 textureCoordinateSet1 : TEXCOORD1 : register(v8);

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
	float4  position        	: POSITION0;
	float3  specular        	: COLOR0;
	float   fog             	: FOG;
	float2  tcs_SPEC 		: TEXCOORD0;
	float2  tcs_DIRT 		: TEXCOORD1;
	float2  lightLookUpCoords	: TEXCOORD2;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// copy texture coordinates
	outputVertex.tcs_SPEC = inputVertex.textureCoordinateSetDTLA;
	outputVertex.tcs_DIRT = inputVertex.textureCoordinateSetDIRT;

	// calculate lighting
	DiffuseSpecular diffuseSpecular = calculateDiffuseSpecularLighting(false, inputVertex.position, inputVertex.normal);
	outputVertex.specular = diffuseSpecular.specular * material.specularColor;

	outputVertex.lightLookUpCoords = calculateDiffuseSpecularLightingLookupTextureCoordinates(inputVertex.position, inputVertex.normal);

	return outputVertex;
}