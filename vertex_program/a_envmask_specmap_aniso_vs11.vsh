//hlsl vs_1_1

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position        : POSITION0  : register(v0);
	float4  normal     	: NORMAL0    : register(v3);
	DECLARE_textureCoordinateSets
};

struct OutputVertex
{
	float4 position 		: POSITION0;
	float3 diffuse  		: COLOR0;
	float3 specular        		: COLOR1; 
	float  fog      		: FOG;
	float2 tcs_MAIN 		: TEXCOORD0;
	float2 tcs_SPEC 		: TEXCOORD1;
	float3 tcs_ENVM			: TEXCOORD2;
	float2 lightLookUpCoords	: TEXCOORD3;
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
	outputVertex.tcs_SPEC = inputVertex.textureCoordinateSetMAIN;

	// calculate lighting
	//DiffuseSpecular diffuseSpecular = calculateDiffuseSpecularLighting(true, inputVertex.position, inputVertex.normal);
	DiffuseSpecular diffuseSpecular = calculateDiffuseSpecularLighting(true, inputVertex.position, inputVertex.normal);
	outputVertex.diffuse  = lightData.ambient.ambientColor + diffuseSpecular.diffuse;
	outputVertex.specular = diffuseSpecular.specular * material.specularColor;
	
	// calculate reflection vector for env mapping
	float3 viewer_o = calculateViewerDirection_o(inputVertex.position);
	outputVertex.tcs_ENVM = rotate_o2w(reflect(-viewer_o, inputVertex.normal));

	outputVertex.lightLookUpCoords = calculateDiffuseSpecularLightingLookupTextureCoordinates(inputVertex.position, inputVertex.normal);

	return outputVertex;
}
