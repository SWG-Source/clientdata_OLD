//hlsl vs_2_0

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position              : POSITION0  : register(v0);
	float4  normal                : NORMAL0    : register(v3);
	float4  color                 : COLOR0     : register(v5);
	float2  textureCoordinateSet0 : TEXCOORD0  : register(v7);
};

struct OutputVertex
{
	float4  position              : POSITION0;
	float4  diffuse               : COLOR0;
	float4  dot3Color             : COLOR1;
	float   fog                   : FOG;
	float3  lightDirection_t      : TEXCOORD0;
	float2  textureCoordinateSet1 : TEXCOORD1;
	float3 halfAngle_t            : TEXCOORD2;
	float emissive                : TEXCOORD3;
	float3 eyeVector_t : TEXCOORD4;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// store dot3 light modulated by vertex color
	outputVertex.dot3Color = inputVertex.color;

	// copy texture coordinates
	outputVertex.lightDirection_t = transformTerrainDot3LightDirection(inputVertex.normal);
	outputVertex.textureCoordinateSet1 = inputVertex.textureCoordinateSet0;

	// calculate lighting
	DiffuseSpecular diffuseSpecular = calculateDiffuseSpecularTerrainLighting(true, inputVertex.position, inputVertex.normal);
	outputVertex.diffuse  = lightData.ambient.ambientColor + diffuseSpecular.diffuse;
	outputVertex.diffuse  = min(outputVertex.diffuse, 1.0) * inputVertex.color;
	
	//Get view direction and compute half-angle
	float3 h = lightData.dot3[0].direction_o + normalize(lightData.dot3[0].cameraPosition_o - inputVertex.position);
	outputVertex.halfAngle_t = transformTerrainDot3(h, inputVertex.normal);
	
	outputVertex.emissive = intensity(material.emissiveColor);

	outputVertex.eyeVector_t  = transformTerrainDot3(normalize(lightData.dot3[0].cameraPosition_o - inputVertex.position), inputVertex.normal);

	return outputVertex;
}
