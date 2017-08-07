
struct PodTest {

};

struct ResTest {

};

struct MixedTest {

};

struct VSOutput {
  float4  Position : SV_POSITION;
  float2  TexCoord  : TEXCOORD;
};

VSOutput VSMain(float4 Position : POSITION, float2 TexCoord : TEXCOORD)
{
  VSOutput ret;
  ret.Position = Position;
  ret.TexCoord = TexCoord;
  return ret;
}

float4 PSMain(VSOutput input)
{
  float4 ret;
  return ret;
}
