//hlsl vs_1_1
#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

#define flow material.emissiveColor.rgb
#define loopTime material.emissiveColor.a
#define tcScale material.specularColor.b

#define colorScale material.specularColor.r
#define colorBias material.specularColor.g
#define ooShaderSize  userConstant0.z
struct InputVertex
{
	float4  position  : POSITION0  : register(v0);
	float3  tc0  : TEXCOORD0 : register(v7);
};

struct OutputVertex
{
	float4  position  : POSITION0;
	float   fog       : FOG;
	float3  noiseTc   : TEXCOORD0;
	float2  texTc     : TEXCOORD1;
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
	float3 temp = inputVertex.tc0;
	temp *= tcScale * ooShaderSize;
	temp -= flow * fmod(currentTime, loopTime);

	outputVertex.noiseTc = temp;
	outputVertex.noiseTc.xz *= 0.25;

	outputVertex.texTc = temp.xz;

	return outputVertex;
}
