#define FLT_MAX 3.402823466e+38

#define edge 2

inline float2 unity_voronoi_noise_randomVector (float2 UV, float offset)
{
    float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
    UV = frac(sin(mul(UV, m)) * 46839.32);
    return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
}


void CustomVoronoi_float(
    float2 uv, float angleOffset, float tilling,
    out float minDistance)
{
    float2 cellPosition = floor(uv * tilling);
    
    float2 f = frac(uv * tilling);

    minDistance = FLT_MAX;

    for(int j = -1; j <= 1; j++)
    {
        for(int i = -1; i <= 1; i++)
        {
            float2 cellOffset = float2(i,j);
            float2 offset = unity_voronoi_noise_randomVector(cellOffset + cellPosition, angleOffset);
            
            float d = distance(cellOffset + offset, f);
            if(d < minDistance)
            {
                minDistance = d;
            }
        }
    }
}

void CustomSmoothVoronoi_float(
    float2 uv, float angleOffset, float tilling, float smoothness,
    out float smoothDistance)
{
    float2 cellPosition = floor(uv * tilling);
    
    float2 f = frac(uv * tilling);

    smoothDistance = 0;

    float h = -1;

    for(int j = -2; j <= 2; j++)
    {
        for(int i = -2; i <= 2; i++)
        {
            float2 cellOffset = float2(i,j);
            float2 offset = unity_voronoi_noise_randomVector(cellOffset + cellPosition, angleOffset);
            
            float d = distance(cellOffset + offset, f);

            h = h == -1 ? 1 : smoothstep(0, 1, 0.5 + 0.5 * (smoothDistance - d) / smoothness);
            float correctionFactor = smoothness * h * (1 - h);
            smoothDistance = lerp(smoothDistance, d, h) - correctionFactor;
        }
    }
}

void CustomMask_float(float2 uv, out float2 mask)
{
    // 左下
    if (uv.x <= 0.5 && uv.y <= 0.5)
    {
        mask.x = lerp(-edge, 0, uv.x * 2);
        mask.y = lerp(-edge, 0, uv.y * 2);
    }
    // 右下
    if (uv.x > 0.5 && uv.y <= 0.5)
    {
        mask.x = lerp(0, edge, (uv.x - 0.5) * 2);
        mask.y = lerp(-edge, 0, uv.y * 2);
    }
    // 左上
    if (uv.x <= 0.5 && uv.y > 0.5)
    {
        mask.x = lerp(-edge, 0, uv.x * 2);
        mask.y = lerp(0, edge, (uv.y - 0.5) * 2);
    }
    // 右上
    if (uv.x > 0.5 && uv.y > 0.5)
    {
        mask.x = lerp(0, edge, (uv.x - 0.5) * 2);
        mask.y = lerp(0, edge, (uv.y - 0.5) * 2);
    }
    
}