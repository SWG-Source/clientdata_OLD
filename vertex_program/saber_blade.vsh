//hlsl vs_1_1 vs_2_0

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position              : POSITION0  : register(v0);
	float4  normal                : NORMAL0    : register(v3);
};

struct OutputVertex
{
	float4  position              : POSITION0;
	float2  textureCoordinateSet0 : TEXCOORD0;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	float3 temp = cameraPosition_w - float3(objectWorldMatrix[3][0], objectWorldMatrix[3][1], objectWorldMatrix[3][2]);
	float3 cameraPosition_o = mul(temp, transpose((float3x3)objectWorldMatrix));
	float3 planarCameraPosition_o = float3(cameraPosition_o.x, 0.0, cameraPosition_o.z);
	float3 planarCameraDirection_o = normalize(planarCameraPosition_o);

	outputVertex.textureCoordinateSet0.x = dot(inputVertex.normal, planarCameraDirection_o);
	outputVertex.textureCoordinateSet0.y = 0.0;

	return outputVertex;
}
