// ======================================================================
// functions.inc
// HLSL vertex shader functions
// ======================================================================

#include "../../shared_program/functions.inc"

// ======================================================================

float4 transform3d(float4 vertexPosition_o)
{
	return mul(vertexPosition_o, objectWorldCameraProjectionMatrix);
}

// ----------------------------------------------------------------------

float4 transform2d(float2 vertexPosition_s)
{
	float4 result;
	result.x = (vertexPosition_s.x * viewportData.x) + viewportData.z;
	result.y = (vertexPosition_s.y * viewportData.y) + viewportData.w;
	result.z = 0.5;
	result.w = 1.0;
	return result;
}

// ----------------------------------------------------------------------

float3 rotate_o2w(float3 vector_o)
{
	return mul(vector_o, (float3x3)objectWorldMatrix);
}

// ----------------------------------------------------------------------

float3 rotateNormalize_o2w(float3 vector_o)
{
	return normalize(rotate_o2w(vector_o));
}

// ----------------------------------------------------------------------

float3 rotateTranslate_o2w(float3 vector_o)
{
	return mul(vector_o, objectWorldMatrix);
}

// ----------------------------------------------------------------------

float3 calculateHalfAngle_o(float3 position_o)
{
	return normalize(lightData.dot3[0].direction_o + normalize(lightData.dot3[0].cameraPosition_o - position_o));
}

// ----------------------------------------------------------------------

//float3 calculateReflectionVector_w(float3 position_o, float3 normal_o)
//{
//	float3 fromViewer_w = normalize(rotateTranslate_o2w(position_o) - cameraPosition);
//	float3 normal_w = rotateTranslateNormalize_o2w(normal_o);
//	return reflect(fromViewer_w, normal_w);
//}

// ----------------------------------------------------------------------

float calculateFog(float4 vertexPosition_o)
{
	float4 position_w = mul(vertexPosition_o, objectWorldMatrix);
	float3 viewer_w = cameraPosition_w - position_w;
	float  viewerDistanceSquared = lengthSquared(viewer_w);
	return 1.0 / exp(viewerDistanceSquared * fog.w);
}

// ----------------------------------------------------------------------

float3x3 calculateTextureToWorldTransform(float3 vertexNormal_o, float4 tcsDOT3)
{
	// build the transformation matrix
	float3x3 m;
	m[0] = rotate_o2w((float3)tcsDOT3);
	m[2] = normalize(rotate_o2w(vertexNormal_o));
	m[1] = cross(m[2], m[0]) * tcsDOT3.w;
	return m;
}

// ----------------------------------------------------------------------

float3x3 calculateTextureToObjectTransform(float3 vertexNormal_o, float4 tcsDOT3)
{
	// build the transformation matrix
	float3x3 m;
	m[0] = (float3)tcsDOT3;
	m[2] = vertexNormal_o;
	m[1] = cross(m[2], m[0]) * tcsDOT3.w;
	return m;
}

// ----------------------------------------------------------------------

float3x3 calculateObjectToTextureTransform(float3 vertexNormal_o, float4 tcsDOT3)
{
	return transpose(calculateTextureToObjectTransform(vertexNormal_o,tcsDOT3));
}

// ----------------------------------------------------------------------

float3 calculateDot3LightDirection_t(float3 vertexNormal_o, float4 tcsDOT3)
{
	// transform the light direction into texture space
	return mul(lightData.dot3[0].direction_o, calculateObjectToTextureTransform(vertexNormal_o, tcsDOT3));
}

// ----------------------------------------------------------------------
// deprecated 

float3 transformDot3LightDirection(float3 vertexNormal_o, float4 tcsDOT3)
{
	return calculateDot3LightDirection_t(vertexNormal_o, tcsDOT3);
}

// ----------------------------------------------------------------------

float3 computeHalfAngle(float3 vertexPosition_o)
{
	// (H = L + V / |L + V|)
	return normalize(normalize(lightData.dot3[0].cameraPosition_o - vertexPosition_o) + lightData.dot3[0].direction_o);
}

// ----------------------------------------------------------------------

float3 calculateHalfAngle_t(float3 vertexPosition_o, float3 vertexNormal_o, float4 tcsDOT3)
{
	return mul(computeHalfAngle(vertexPosition_o), calculateObjectToTextureTransform(vertexNormal_o, tcsDOT3));
}

// ----------------------------------------------------------------------
// deprecated 

float3 transformHalfAngle(float3 vertexPosition_o, float3 vertexNormal_o, float4 tcsDOT3)
{
	return calculateHalfAngle_t(vertexPosition_o, vertexNormal_o, tcsDOT3);
}

// ----------------------------------------------------------------------

float3 transformTerrainDot3(float3 input, float3 vertexNormal_o)
{
	float3 j = cross(vertexNormal_o, float3(1.0f, 0.0f, 0.0f));
	float3 i = cross(j, vertexNormal_o);
	
	float3x3 ot = float3x3(i, j, vertexNormal_o);
	float3 result = mul(ot, input);
	
	return result;
}

// ----------------------------------------------------------------------

float3 transformTerrainDot3LightDirection(float3 vertexNormal_o)
{
	return normalize(transformTerrainDot3(lightData.dot3[0].direction_o, vertexNormal_o));
}

// ----------------------------------------------------------------------

float3 calculateViewerDirection_o(float3 vertexPosition_o)
{
	return normalize(lightData.dot3[0].cameraPosition_o - vertexPosition_o);
}

// ----------------------------------------------------------------------

float3 calculateViewerDirection_w(float3 vertexPosition_o)
{
	return normalize(cameraPosition_w - rotateTranslate_o2w(vertexPosition_o));
}

// ----------------------------------------------------------------------

float4 calculateDiffuseParallelLight(ParallelLight light, float3 vertexNormal_o)
{
	float3 normal_w = normalize(mul(vertexNormal_o, (float3x3)objectWorldMatrix));
	return max(dot(normal_w, light.direction_w), 0.0) * light.diffuseColor;
}

float4 calculateDiffuseParallelLightWorld(ParallelLight light, float3 normal_w)
{
	return max(dot(normal_w, light.direction_w), 0.0) * light.diffuseColor;
}

// ----------------------------------------------------------------------

float4 calculateDiffuseParallelHemisphericLight(ParallelLight light, float3 normal_w, HemisphericLightData extendedLight)
{
	float  dotProduct = dot(normal_w, light.direction_w);
	
	float3 color = extendedLight.tangentColor;
	
	float intensity = max(0.0, dotProduct);
	color += (-intensity * (extendedLight.tangentColorMinusDiffuseColor));
	
	intensity = min(0.0, dotProduct);
	color += (intensity * (extendedLight.tangentColorMinusBackColor));

	float4 result;
	result.rgb = color;
	result.a = 0.f;
	
	return result;
}

// ----------------------------------------------------------------------

DiffuseSpecular calculateDiffuseSpecularParallelLight(ParallelSpecularLight light, float4 vertexPosition_o, float3 vertexNormal_o)
{
	float3 viewer_w = normalize(cameraPosition_w - mul(vertexPosition_o, objectWorldMatrix));
	float3 vertexNormal_w = normalize(mul(vertexNormal_o, (float3x3)objectWorldMatrix));

	float3 halfAngle = normalize(light.direction_w + viewer_w);
	float  nDotL = dot(vertexNormal_w, light.direction_w);
	float  nDotH = dot(vertexNormal_w, halfAngle);
	
	float4 lighting = lit(nDotL, nDotH, material.specularPower.x);

	DiffuseSpecular diffuseSpecular;
	diffuseSpecular.diffuse  = lighting.y * light.diffuseColor;
	diffuseSpecular.diffuse.a = 0.f;
	diffuseSpecular.specular = lighting.z * light.specularColor;

	return diffuseSpecular;
}

// ----------------------------------------------------------------------

DiffuseSpecular calculateDiffuseSpecularParallelHemisphericLight(ParallelSpecularLight light, float3 vertexPosition_w, float3 vertexNormal_w, HemisphericLightData extendedLight)
{
	float3 viewer_w = normalize(cameraPosition_w - vertexPosition_w);

	float3 halfAngle = normalize(light.direction_w + viewer_w);
	float  nDotL = dot(vertexNormal_w, light.direction_w);
	float  nDotH = dot(vertexNormal_w, halfAngle);
	
	float4 lighting = lit(nDotL, nDotH, material.specularPower.x);

	DiffuseSpecular diffuseSpecular;
	diffuseSpecular.diffuse = extendedLight.tangentColor;
	
	diffuseSpecular.diffuse += (-lighting.y * (extendedLight.tangentColorMinusDiffuseColor));

	float intensity = min(nDotL, 0.0);
	diffuseSpecular.diffuse += (intensity * (extendedLight.tangentColorMinusBackColor));
	diffuseSpecular.diffuse.a = 0.f;

	diffuseSpecular.specular = lighting.z * light.specularColor;

	return diffuseSpecular;
}

// ----------------------------------------------------------------------

float4 calculateDiffusePointLight(PointLight light, float3 vertexPosition_w, float3 normal_w)
{
	// Get light direction
	float3 lightDirection = light.position_w - vertexPosition_w;

	// Get light distance squared.
	float lightDistanceSquared = lengthSquared(lightDirection);

	// Get 1/lightDistance
	float oneOverLightDistance = rsqrt(lightDistanceSquared);

	// Normalize light direction
	lightDirection *= oneOverLightDistance;

	// compute distance attenuation
	float4 attenuationFactors;
	attenuationFactors.x = 1.0;
	attenuationFactors.y = lightDistanceSquared * oneOverLightDistance;
	attenuationFactors.z = lightDistanceSquared;
	attenuationFactors.w = oneOverLightDistance;
	float distanceAttenuation = 1.0 / dot(light.attenuation, attenuationFactors);

	return max(dot(normal_w, lightDirection), 0.0) * distanceAttenuation * light.diffuseColor;
}

// ----------------------------------------------------------------------

DiffuseSpecular calculateDiffuseSpecularPointLight(PointSpecularLight light, float4 vertexPosition_o, float3 vertexNormal_o)
{
	float3 vertexPosition_w = mul(vertexPosition_o, objectWorldMatrix);
	float3 normal_w = normalize(mul(vertexNormal_o, (float3x3)objectWorldMatrix));
	float3 viewer_w = normalize(cameraPosition_w - vertexPosition_w);

	// Get light direction
	float3 lightDirection = light.position_w - vertexPosition_w;

	// Get light distance squared.
	float lightDistanceSquared = lengthSquared(lightDirection);

	// Get 1/lightDistance
	float oneOverLightDistance = rsqrt(lightDistanceSquared);

	// Normalize light direction
	lightDirection *= oneOverLightDistance;

	// compute distance attenuation
	float4 attenuationFactors;
	attenuationFactors.x = 1.0;
	attenuationFactors.y = lightDistanceSquared * oneOverLightDistance;
	attenuationFactors.z = lightDistanceSquared;
	attenuationFactors.w = 1.0; // oneOverLightDistance;
	float distanceAttenuation = 1.0 / dot(light.attenuation, attenuationFactors);

	float3 halfAngle = normalize(lightDirection + viewer_w);
	float  nDotL = dot(normal_w, lightDirection);
	float  nDotH = dot(normal_w, halfAngle);
	
	float4 lighting = lit(nDotL, nDotH, material.specularPower.x) * distanceAttenuation;

	DiffuseSpecular diffuseSpecular;
	diffuseSpecular.diffuse  = lighting.y * light.diffuseColor;
	diffuseSpecular.specular = lighting.z * light.specularColor;
	return diffuseSpecular;
}

// ----------------------------------------------------------------------

DiffuseSpecular calculateDiffuseSpecularPointLightWorld(PointSpecularLight light, float3 vertexPosition_w, float3 normal_w)
{
	float3 viewer_w = normalize(cameraPosition_w - vertexPosition_w);

	// Get light direction
	float3 lightDirection = light.position_w - vertexPosition_w;

	// Get light distance squared.
	float lightDistanceSquared = lengthSquared(lightDirection);

	// Get 1/lightDistance
	float oneOverLightDistance = rsqrt(lightDistanceSquared);

	// Normalize light direction
	lightDirection *= oneOverLightDistance;

	// compute distance attenuation
	float4 attenuationFactors;
	attenuationFactors.x = 1.0;
	attenuationFactors.y = lightDistanceSquared * oneOverLightDistance;
	attenuationFactors.z = lightDistanceSquared;
	attenuationFactors.w = 1.0; // oneOverLightDistance;
	float distanceAttenuation = 1.0 / dot(light.attenuation, attenuationFactors);

	float3 halfAngle = normalize(lightDirection + viewer_w);
	float  nDotL = dot(normal_w, lightDirection);
	float  nDotH = dot(normal_w, halfAngle);
	
	float4 lighting = lit(nDotL, nDotH, material.specularPower.x) * distanceAttenuation;

	DiffuseSpecular diffuseSpecular;
	diffuseSpecular.diffuse  = lighting.y * light.diffuseColor;
	diffuseSpecular.specular = lighting.z * light.specularColor;
	return diffuseSpecular;
}

// ----------------------------------------------------------------------

float4 calculateDiffuseLighting(bool dot3, float4 vertexPosition_o, float3 vertexNormal_o)
{
	float4 result = material.emissiveColor;

	float3 vertexPosition_w = mul(vertexPosition_o, objectWorldMatrix);
	float3 normal_w = normalize(mul(vertexNormal_o, (float3x3)objectWorldMatrix));

	if (!dot3)
		result += calculateDiffuseParallelHemisphericLight((ParallelLight)lightData.parallelSpecular[0], normal_w, extendedLightData.parallelSpecular[0]);

	result += calculateDiffuseParallelLightWorld(lightData.parallel[0], normal_w);
	result += calculateDiffuseParallelLightWorld(lightData.parallel[1], normal_w);

	result += calculateDiffusePointLight((PointLight)lightData.pointSpecular[0], vertexPosition_w, normal_w);

	result += calculateDiffusePointLight(lightData.point[0], vertexPosition_w, normal_w);
	result += calculateDiffusePointLight(lightData.point[1], vertexPosition_w, normal_w);
	result += calculateDiffusePointLight(lightData.point[2], vertexPosition_w, normal_w);
	result += calculateDiffusePointLight(lightData.point[3], vertexPosition_w, normal_w);

	return result;
}

// ----------------------------------------------------------------------

DiffuseSpecular calculateDiffuseSpecularTerrainLighting(bool dot3, float4 vertexPosition_o, float3 vertexNormal_o)
{
	DiffuseSpecular output;
	output.diffuse = 0.0;
	output.specular = float4(0.0, 0.0, 0.0, 0.0);
	
	float3 vertexPosition_w = mul(vertexPosition_o, objectWorldMatrix);
	float3 normal_w = normalize(mul(vertexNormal_o, (float3x3)objectWorldMatrix));

	if (!dot3)
	{
		DiffuseSpecular temporary = calculateDiffuseSpecularParallelHemisphericLight(lightData.parallelSpecular[0], vertexPosition_w, normal_w, extendedLightData.parallelSpecular[0]);
		output.diffuse += temporary.diffuse;
		output.specular += temporary.specular;
	}
	
	output.diffuse += calculateDiffuseParallelLightWorld(lightData.parallel[0], normal_w);
	output.diffuse += calculateDiffuseParallelLightWorld(lightData.parallel[1], normal_w);

	DiffuseSpecular temporary = calculateDiffuseSpecularPointLightWorld(lightData.pointSpecular[0], vertexPosition_w, normal_w);
	output.diffuse += temporary.diffuse;
	output.specular += temporary.specular;

	output.diffuse += calculateDiffusePointLight(lightData.point[0], vertexPosition_w, normal_w);
	output.diffuse += calculateDiffusePointLight(lightData.point[1], vertexPosition_w, normal_w);
	output.diffuse += calculateDiffusePointLight(lightData.point[2], vertexPosition_w, normal_w);
	output.diffuse += calculateDiffusePointLight(lightData.point[3], vertexPosition_w, normal_w);

	return output;
}

// ----------------------------------------------------------------------

DiffuseSpecular calculateDiffuseSpecularLighting(bool dot3, float4 vertexPosition_o, float3 vertexNormal_o)
{
	DiffuseSpecular output;
	output.diffuse = material.emissiveColor;
	output.specular = float4(0.0, 0.0, 0.0, 0.0);
	
	float3 vertexPosition_w = mul(vertexPosition_o, objectWorldMatrix);
	float3 normal_w = normalize(mul(vertexNormal_o, (float3x3)objectWorldMatrix));

	if (!dot3)
	{
		DiffuseSpecular temporary = calculateDiffuseSpecularParallelHemisphericLight(lightData.parallelSpecular[0], vertexPosition_w, normal_w, extendedLightData.parallelSpecular[0]);
		output.diffuse += temporary.diffuse;
		output.specular += temporary.specular;
	}
	
	output.diffuse += calculateDiffuseParallelLightWorld(lightData.parallel[0], normal_w);
	output.diffuse += calculateDiffuseParallelLightWorld(lightData.parallel[1], normal_w);

	DiffuseSpecular temporary = calculateDiffuseSpecularPointLightWorld(lightData.pointSpecular[0], vertexPosition_w, normal_w);
	output.diffuse += temporary.diffuse;
	output.specular += temporary.specular;

	output.diffuse += calculateDiffusePointLight(lightData.point[0], vertexPosition_w, normal_w);
	output.diffuse += calculateDiffusePointLight(lightData.point[1], vertexPosition_w, normal_w);
	output.diffuse += calculateDiffusePointLight(lightData.point[2], vertexPosition_w, normal_w);
	output.diffuse += calculateDiffusePointLight(lightData.point[3], vertexPosition_w, normal_w);

	return output;
}

// ----------------------------------------------------------------------

float2 calculateDiffuseSpecularLightingLookupTextureCoordinates(float4 vertexPosition_o, float vertexNormal_o)
{
	float2 result;
	
	// Calculate L.N for light texture lookup
	result.x = max(0.0f, dot(lightData.dot3[0].direction_o, vertexNormal_o));

	//Calculate H.N for light texture lookup
	float3 halfAngle_o = calculateHalfAngle_o(vertexPosition_o);
	result.y = max(0.0f, dot(halfAngle_o, vertexNormal_o));

	return result;
}


// ======================================================================
