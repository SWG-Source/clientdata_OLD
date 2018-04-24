//hlsl vs_1_1 vs_2_0

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

struct InputVertex
{
	float4  position  : POSITION0  : register (v0);
};

struct OutputVertex
{
	float4  position              : POSITION0;
	float4  diffuse               : COLOR0;
	float   fog                   : FOG;
	float2  textureCoordinateSet0 : TEXCOORD0;
	float4  textureCoordinateSet1 : TEXCOORD1;
	float4  textureCoordinateSet2 : TEXCOORD2;
	float4  textureCoordinateSet3 : TEXCOORD3;
};

OutputVertex main (InputVertex inputVertex)
{
	OutputVertex outputVertex;

	//-- setup some starting values
	float4 position    = inputVertex.position + meshOffset;
	position           = max(position, meshClipMin_w);
	position           = min(position, meshClipMax_w);
	float3 normal      = float3(0, normal_y, 0);
	float3 camVec      = cameraPosition_w - position;
	float  camDistSqr  = dot(camVec.xyz, camVec.xyz);

	// taper off the wave function over 32 meters using the envelope
	// (1-x^16).  I use the eighth power to take advantage of the fact
	// that it is fewer calculations to get distance squared rather
	// than distance.
	float  waveAtten   = saturate(1.0 - pow(camDistSqr/sqrt(32), 8));

	//-- calculate wave functions
	float  turn     = position.z + position.x + stime;
	float2 vturn    = float2(cos(turn), sin (turn));
	float2 delta_tc = float2(vturn.x * waveMag * waveAtten, vturn.y * waveMag * waveAtten);

	position.y += delta_tc.x;

	//-- transform vertex
	outputVertex.position = transform3d(position);

	//-- calculate fog
	outputVertex.fog = calculateFog(position);

	//-- calculate lighting
	outputVertex.diffuse  = lightData.ambient.ambientColor;
	outputVertex.diffuse += calculateDiffuseLighting (true, position, normal);

	//-- calculate texture coordinates
	float3 tcPos    = position - tcOrigin;
	float2 gen_tc   = float2(-tcPos.x * ooShaderSize, tcPos.z * ooShaderSize);
	float2 tc       = gen_tc + delta_tc;
	outputVertex.textureCoordinateSet0 = tc + textureScroll.xy;

	//-- calculate env map lookup
	float3 directionToCamera = normalize(camVec); 
	outputVertex.textureCoordinateSet1 = float4 (1.f, 0.f, 0.f, directionToCamera.x);
	outputVertex.textureCoordinateSet2 = float4 (0.f, 0.f, -1.f, directionToCamera.y);
	outputVertex.textureCoordinateSet3 = float4 (0.f, 1.f, 0.f, directionToCamera.z);

	return outputVertex;
}
