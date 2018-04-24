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
	float4  normal    : NORMAL0    : register(v3);
};

struct OutputVertex
{
	float4  position  	: POSITION0;
	float   fog       	: FOG;
	float3  noiseTc   	: TEXCOORD0;
	float3  normal_o	: TEXCOORD1;
	float3  viewer_o	: TEXCOORD2;
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

	// store vertex normal
	outputVertex.normal_o = inputVertex.normal;
	
	// transform view direction from object space to world space to send to ps for env mapping
	outputVertex.viewer_o = calculateViewerDirection_o(inputVertex.position);

	//-- set up tex coords
	outputVertex.noiseTc = rotateTranslate_o2w(position) * tcScale;
	outputVertex.noiseTc += flow * fmod(currentTime, 1000);

	return outputVertex;
}
