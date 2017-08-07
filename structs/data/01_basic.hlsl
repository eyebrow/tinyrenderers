/* See build results at bottom of file */

SamplerState    MySampler : register(s0);
Texture2D       MyTexure : register(t1);

struct Combined {
  Texture2D     tex;
  SamplerState  sam;
};

Combined CreateCombined(Texture2D tex, SamplerState sam)
{
    Combined ret;
    ret.tex = tex;
    ret.sam = sam;
    return ret;
}

float4 GetSample(Combined com, float2 texCoord)
{
  return com.tex.Sample(com.sam, texCoord);
}

struct VSInput {
  float4  position : POSITION;
  float2  texCoord : TEXCOORD;
};

struct VSOutput {
  float4  position : SV_POSITION;
  float2  texCoord : TEXCOORD;
};

VSOutput VSMain(VSInput input)
{
  VSOutput ret = {input.position, input.texCoord};
  return ret;
}

float4 PSMain(VSOutput input) : SV_TARGET
{
  Combined com = CreateCombined(MyTexure, MySampler);
  return GetSample(com, input.texCoord);
}

/*

Build Results

FXC: VS:PASSED, PS:PASSED

DXC:

GLSLANG: VS:PASSED, PS:PASSED

*/