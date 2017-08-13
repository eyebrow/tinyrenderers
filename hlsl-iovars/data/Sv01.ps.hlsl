// Pixel Shader
struct PSInput {
  float4 sv_pos   : SV_POSITION;
  float4 sv_clip  : SV_ClipDistance;
  float2 sv_cull  : SV_CullDistance;
};

float4 main(PSInput input) : SV_TARGET
{
  float4 ret = float4(input.sv_pos.xy, 0.5, 1.0);
  return ret;
}

