// ======================================================================
// functions.inc
// HLSL vertex shader functions
// ======================================================================

float lengthSquared(float3 v)
{
	return dot(v, v);
}

// ----------------------------------------------------------------------

float3 signAndBias(float3 v)
{
	return (v - 0.5) * 2.0;
}

// ----------------------------------------------------------------------

float3 reverseSignAndBias(float3 v)
{
	return (v * 0.5) + 0.5;
}

// ----------------------------------------------------------------------

float3 tex2DDxt5CompressedNormal(sampler map, float2 tcs)
{
	float4 pixel = tex2D(map, tcs);
	float3 normal = { pixel.a, pixel.y, 1 };
	normal = signAndBias(normal);
	normal.z = sqrt(1 - (normal.x * normal.x + normal.y * normal.y));
	return normal;
}

// ----------------------------------------------------------------------

float3 tex2DDxt5CompressedNormal_ps_14( sampler map, float2 tcs )
{
	float4 pixel = tex2D( map, tcs );
	float3 normal = { pixel.a, pixel.y, pixel.z };
	normal = signAndBias( normal );
	normal.z = 1.0f - (normal.x * normal.x + normal.y * normal.y);
	
	// no sqrt( ) available, so we must approximate it
	if (normal.z >= 0.24)
	{
		normal.z = (normal.z * 0.6667) + 0.375;
	}
	else
	{
		normal.z = (normal.z * 1.6667) + 0.15;
	}
	
	return normal;
}

// ----------------------------------------------------------------------

float3 tex2DDxt5CompressedNormal_ps_14_min_constants( sampler map, float2 tcs )
{
	float4 pixel = tex2D( map, tcs );
	float3 normal = { pixel.a, pixel.y, pixel.z };
	normal = signAndBias( normal );
	float zSquared = 1.0f - (normal.x * normal.x + normal.y * normal.y);
	
	// slightly creative rework of above method to reduce instructions and constants
	// no sqrt( ) available, so we must approximate it
	normal.z = (zSquared * 0.6667) + 0.375;
	zSquared -= 0.225; // subtracting the 0.375 that was added to normal.z above and adding 0.15 before the comparison
	if (zSquared < 0)
	{
		normal.z += zSquared;
	}
	
	return normal;
}

// ----------------------------------------------------------------------

float intensity(float3 rgb)
{
	return dot(rgb, float3(0.3f, 0.59f, 0.11f));
}

// ======================================================================

