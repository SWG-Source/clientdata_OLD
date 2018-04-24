//hlsl vs_1_1

#define textureCoordinateSetMAIN	textureCoordinateSet0
#define DECLARE_textureCoordinateSets	\
float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

#define flow material.emissiveColor.rgb
#define tcScale material.specularColor.b

#define colorScale material.specularColor.r
#define colorBias material.specularColor.g

struct InputVertex
{
	float4  position  : POSITION0  : register(v0);
	DECLARE_textureCoordinateSets
};

struct OutputVertex
{
	float4  position  : POSITION0;
	float   fog       : FOG;
	float2  tcs_MAIN  : TEXCOORD0;
	float3  noiseTc   : TEXCOORD1;
};

OutputVertex main (InputVertex inputVertex)
{
	OutputVertex outputVertex;

	//-- setup some starting values
	float4 position    = inputVertex.position;

	//-- transform vertex
	outputVertex.position = transform3d(position);

	//-- calculate fog
	outputVertex.fog = calculateFog(position);

	// copy texture coordinates
	outputVertex.tcs_MAIN = inputVertex.textureCoordinateSetMAIN;

	//-- set up tex coords
	outputVertex.noiseTc.xzy = float3(inputVertex.textureCoordinateSetMAIN, 0) * tcScale;
	outputVertex.noiseTc += flow * fmod(currentTime, 1000);

	return outputVertex;
}
