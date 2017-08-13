// SV semantics

// Vertex Shader
struct VSInput {
  float4 position : POSITION;
};

struct VSOutput {
  float4 sv_pos   : SV_Position;
  float3 sv_clip  : SV_ClipDistance;
  float3 sv_cull  : SV_CullDistance;
};

VSOutput main(VSInput input) 
{
  VSOutput ret;
  ret.sv_pos    = input.position;
  ret.sv_clip.z = 2;
  ret.sv_clip.y = 1;
  ret.sv_clip.x = 0;
  ret.sv_cull   = float3(0, 1, 2);
  return ret;
}