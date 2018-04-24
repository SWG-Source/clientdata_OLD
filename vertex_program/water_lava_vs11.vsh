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
	outputVertex.noiseTc = inputVertex.tc0;
	outputVertex.noiseTc *= tcScale * ooShaderSize;
	outputVertex.noiseTc -= flow * fmod(currentTime, loopTime);

	outputVertex.noiseTc.x = fmod(outputVertex.noiseTc.x, 100.0f);
	if (outputVertex.noiseTc.x > 50.0)
		outputVertex.noiseTc.x = 100.0 - outputVertex.noiseTc.x;

	outputVertex.noiseTc.y = fmod(outputVertex.noiseTc.y, 100.0f);
	if (outputVertex.noiseTc.y > 50.0)
		outputVertex.noiseTc.y = 100.0 - outputVertex.noiseTc.y;

	outputVertex.noiseTc.z = fmod(outputVertex.noiseTc.z, 100.0f);
	if (outputVertex.noiseTc.z > 50.0)
		outputVertex.noiseTc.z = 100.0 - outputVertex.noiseTc.z;

	return outputVertex;
}
