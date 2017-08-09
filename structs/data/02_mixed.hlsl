/* See build results at bottom of file */

SamplerState    MySampler : register(s0);
Texture2D       MyTexture : register(t1);
Texture2DArray  MyTextureArray : register(t2);

struct GenericTex {
  Texture2D       tex;
  Texture2DArray  texArray;  
  int         which;
};

GenericTex CreateGeneric(Texture2D tex)
{
  GenericTex ret;
  ret.tex = tex;
  ret.which = 0;
  return ret;
}

GenericTex CreateGeneric(Texture2DArray texArray)
{
  GenericTex ret;
<<<<<<< HEAD
  ret.texArray = texArray;
=======
  ret.tex = texArray;
>>>>>>> 78b8a798dd44efb02987974c573621827fa44ca6
  ret.which = 1;
  return ret;
}

float4 GetSample(GenericTex gen, float2 texCoord)
{
  float4 ret;
  if (gen.which == 0) {
    ret = gen.tex.Sample(MySampler, texCoord);
  }
  else {
    ret = gen.texArray.Sample(MySampler, float3(texCoord, 0));
  }
  return ret;
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
  GenericTex gen = CreateGeneric(MyTexture);
  return GetSample(gen, input.texCoord);
}

/*

Build Results

FXC:

DXC:

GLSLANG: VS:crashes, PS:crashes

*/