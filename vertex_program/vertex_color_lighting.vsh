//hlsl vs_1_1 vs_2_0

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct Input
{
	float4  position  : POSITION0  : register(v0);
	float3  normal    : NORMAL0    : register(v3);
	float4  diffuse   : COLOR0     : register(v5);
};

struct Output
{
	float4  position  : POSITION0;
	float4  diffuse   : COLOR0;
	float   fog       : FOG;
};

Output main(Input vertex)
{
	Output output;

	// transform vertex
	output.position = mul(vertex.position, objectWorldCameraProjectionMatrix);

	// calculate fog
	output.fog = calculateFog(vertex.position);

	// calculate lighting
	output.diffuse = vertex.diffuse * saturate(lightData.ambient.ambientColor + calculateDiffuseLighting(false, vertex.position, vertex.normal));

	return output;
}
