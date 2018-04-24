//hlsl vs_1_1

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define textureCoordinateSetDETA	textureCoordinateSet1
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
	float3  diffuse         	: COLOR0;
	float4  specular        	: COLOR1;
	float   fog             	: FOG;
	float2  tcs_MAIN 		: TEXCOORD0;
	float2  tcs_SPEC 		: TEXCOORD1;
	float2  tcs_DETA 		: TEXCOORD2;
	float2  lightLookUpCoords	: TEXCOORD3;
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
	// this must be duplicated for ps_1_1
	outputVertex.tcs_SPEC = inputVertex.textureCoordinateSetMAIN;
	outputVertex.tcs_DETA = inputVertex.textureCoordinateSetDETA;

	// calculate lighting
	//*** Calculate only diffuse for ps1.1. The second specular is thrown out because we end up too any instructions otherwise
		//DiffuseSpecular diffuseSpecular = calculateDiffuseSpecularLighting(false, inputVertex.position, inputVertex.normal_o);
		//outputVertex.diffuse  = lightData.ambient.ambientColor + diffuseSpecular.diffuse;
		//outputVertex.specular = diffuseSpecular.specular * material.specularColor;
	outputVertex.diffuse =  lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting(false, inputVertex.position, inputVertex.normal);
	outputVertex.specular = float4(0.0, 0.0, 0.0, 0.0);

	outputVertex.lightLookUpCoords = calculateDiffuseSpecularLightingLookupTextureCoordinates(inputVertex.position, inputVertex.normal);

	return outputVertex;
}
