// Pixel Shader
struct PSInput {
  float4 sysPos   : SV_POSITION;
  float4 position : POSITION;
  float2 texCoord : TEXCOORD;
  float3 normal   : NORMAL;
  float3 tangent  : TANGENT;
};

float4 main(PSInput input) : SV_TARGET
{
  float4 ret = float4(0.25 * input.texCoord, 0.0, 1.0) +
               float4(0.50 * input.normal, 0.0) +
               float4(0.50 * input.tangent, 0.0);
  return ret;
}

