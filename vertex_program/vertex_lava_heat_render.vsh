//hlsl vs_2_0

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

#define normal_y      userConstant0.x
#define stime         userConstant0.y
#define ooShaderSize  userConstant0.z
#define waveMag       userConstant0.w
#define tcOrigin      userConstant1.xyz
#define meshOffset    userConstant2
#define meshClipMin_w userConstant3.xyzw
#define meshClipMax_w userConstant4.xyzw

#define flow float3(0.01, 0.01, 0.01)
//#define flow  userConstant5.xyz

static const float tcScale = 0.25;

struct InputVertex
{
	float4  position  : POSITION0  : register(v0);
};

struct OutputVertex
{
	float4  position  : POSITION0;
	float4  diffuse   : COLOR0;
	float   fog       : FOG;
	float3  noiseTc   : TEXCOORD0;
};

OutputVertex main (InputVertex inputVertex)
{
	OutputVertex outputVertex;

	//-- setup some starting values
	float4 position    = inputVertex.position + meshOffset;
	position           = max(position, meshClipMin_w);
	position           = min(position, meshClipMax_w);
	position = mul(objectWorldMatrix, position);
	float3 camVec      = cameraPosition_w - position;
	float  camDistSqr  = dot(camVec.xyz, camVec.xyz);

	float heatAtten = 1.0f - saturate((camDistSqr - 5000.0f) / 2000.0f);

	//-- calculate wave functions

	//-- form a 'bowl' around the camera to prevent the camera from going under the heat effect
	float waveAtten = saturate(camDistSqr / 30.0f);

	position.y += 2.0f * waveAtten;

	//-- transform vertex
	outputVertex.position = transform3d(position);

	//-- calculate fog
	outputVertex.fog = 1.0f;

	outputVertex.diffuse = 0.0f;
	outputVertex.diffuse.r = heatAtten;

	outputVertex.noiseTc = position.xzy * tcScale;
	outputVertex.noiseTc.z = frac(stime * 0.5f);		

	return outputVertex;
}
