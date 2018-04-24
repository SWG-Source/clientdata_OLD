//hlsl vs_1_1

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

#define flow material.emissiveColor.rgb
#define tcScale material.specularColor.b

#define colorScale material.specularColor.r
#define colorBias material.specularColor.g

struct InputVertex
{
	float4  position  : POSITION0  : register(v0);
	float2 textureCoordinateSet0 : TEXCOORD0 : register(v7);
};

struct OutputVertex
{
	float4  position  : POSITION0;
	float   fog       : FOG;
	float3  noiseTc   : TEXCOORD0;
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

	//-- set up tex coords
	outputVertex.noiseTc = float3(inputVertex.textureCoordinateSet0, 0) * tcScale;
	outputVertex.noiseTc += flow * fmod(currentTime, 1000);

	return outputVertex;
}
