//hlsl vs_1_1

#include "vertex_program/include/vertex_shader_constants.inc"
#include "vertex_program/include/functions.inc"

struct InputVertex
{
	float4  position              : POSITION0  : register(v0);
	float4  normal                : NORMAL0    : register(v3);
};

struct OutputVertex
{
	float4  position        : POSITION0;
	float3  specular        : COLOR0;
	float   fog             : FOG;
};

OutputVertex main(InputVertex inputVertex)
{
	OutputVertex outputVertex;

	// transform vertex
	outputVertex.position = transform3d(inputVertex.position);

	// calculate fog
	outputVertex.fog = calculateFog(inputVertex.position);

	// calculate lighting
	DiffuseSpecular diffuseSpecular = calculateDiffuseSpecularLighting(false, inputVertex.position, inputVertex.normal);
	outputVertex.specular = diffuseSpecular.specular * material.specularColor;

	return outputVertex;
}