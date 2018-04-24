//hlsl vs_2_0

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define DECLARE_textureCoordinateSets	\
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7); 

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position     	: POSITION0  	: register(v0);
	float4  normal		: NORMAL0    	: register(v3);
	float4  color		: COLOR0	: register(v5);
	DECLARE_textureCoordinateSets
};

struct OutputVertex
{
	float4  position               		: POSITION0;
	float3  diffuse                		: COLOR0;
	float3  specular               		: COLOR1;
	float   fog                    		: FOG;
	float2  tcs_MAIN  			: TEXCOORD0;
	float3  normal_o	  		: TEXCOORD1;
	float3  halfAngle_o	  		: TEXCOORD2;
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

	// calculate lighting
	DiffuseSpecular diffuseSpecular = calculateDiffuseSpecularLighting(true, inputVertex.position, inputVertex.normal);
	outputVertex.diffuse  = diffuseSpecular.diffuse + inputVertex.color;
//outputVertex.diffuse  =  lightData.ambient.ambientColor ;
	outputVertex.specular = diffuseSpecular.specular * material.specularColor;

	// setup for per-pixel specular lighting
	outputVertex.normal_o = inputVertex.normal;
	
	//Get view direction and compute half-angle
	outputVertex.halfAngle_o = calculateHalfAngle_o(inputVertex.position);
	
	return outputVertex;
}
