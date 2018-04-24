// ======================================================================
// types
// ======================================================================

struct Material
{
	float4   diffuseColor;
	float4   ambientColor;
	float4   specularColor;
	float4   emissiveColor;
	float    specularPower;
};

struct AmbientLight
{
	float4   ambientColor;
};

struct ParallelSpecularLight
{
	float3   direction_w;
	float4   diffuseColor;
	float4   specularColor;
};

struct ParallelLight
{
	float3   direction_w;
	float4   diffuseColor;
};

struct PointSpecularLight
{
	float3   position_w;
	float4   diffuseColor;
	float4   attenuation;
	float4   specularColor;
};

struct PointLight
{
	float3   position_w;
	float4   diffuseColor;
	float4   attenuation;
};

struct Dot3Light
{
	float3   cameraPosition_o;
	float3   direction_o;
	float4   diffuseColor;
	float4   specularColor;
};

struct DiffuseSpecular
{
	float4	diffuse;
	float4	specular;
};

struct HemisphericLightData
{
	float4 backColor;
	float4 tangentColor;
	float4 tangentColorMinusBackColor;
	float4 tangentColorMinusDiffuseColor;
};

static const int NumberOfParallelSpecularLights = 1;
static const int NumberOfParallelLights         = 2;
static const int NumberOfPointSpecularLights    = 1;
static const int NumberOfPointLights            = 4;
static const int NumberOfDot3Lights             = 1;

struct LightData
{
	AmbientLight           ambient;
	ParallelSpecularLight  parallelSpecular[NumberOfParallelSpecularLights];
	ParallelLight          parallel[NumberOfParallelLights];
	PointSpecularLight     pointSpecular[NumberOfPointSpecularLights];
	PointLight             point[NumberOfPointLights];
	Dot3Light              dot3[NumberOfDot3Lights];
};

struct ExtendedLightData
{
	HemisphericLightData   parallelSpecular[NumberOfParallelSpecularLights];
	HemisphericLightData   dot3[NumberOfDot3Lights];
};

// ======================================================================
// constants
// ======================================================================

float4x4  objectWorldCameraProjectionMatrix : register(c0);
float4x4  objectWorldMatrix : register(c4);
float3    cameraPosition_w : register(c8);

float4    viewportData : register(c9);

float4    fog : register(c10);

Material  material : register(c11);
LightData lightData : register(c16);

float4    textureFactor : register(c44);
float4    textureFactor2 : register(c45);
float4    textureScroll : register(c47);

float     currentTime : register(c48);

float3    unitX : register(c49);
float3    unitY : register(c50);
float3    unitZ : register(c51);

float4    userConstant0 : register(c52);
float4    userConstant1 : register(c53);
float4    userConstant2 : register(c54);
float4    userConstant3 : register(c55);
float4    userConstant4 : register(c56);
float4    userConstant5 : register(c57);
float4    userConstant6 : register(c58);
float4    userConstant7 : register(c59);

ExtendedLightData extendedLightData : register(c60);

#if VERTEX_SHADER_VERSION >= 20
const bool light_parallelSpecular_0_enabled    : register(b0);
const bool light_parallel_0_enabled            : register(b1);
const bool light_parallel_1_enabled            : register(b2);
const bool light_pointSpecular_0_enabled       : register(b3);
const bool light_point_0_enabled               : register(b4);
const bool light_point_1_enabled               : register(b5);
const bool light_point_2_enabled               : register(b6);
const bool light_point_3_enabled               : register(b7);
#endif

#pragma def(vs, c95, 0.0, 0.5f, 1.0f, 1.4426950408889634f)
