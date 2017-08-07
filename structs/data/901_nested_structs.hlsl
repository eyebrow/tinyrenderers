/* See build results at bottom of file */

struct Outer {
  struct Inner {
    float4  InnerScale;
  };

  Inner   Nested;
  float4  OuterScale;
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
  float4 ret = float4(input.TexCoord, 0, 1);
  return ret;
}

/* Build Results */
/*

FXC: FAILED:VS, FAILED:PS
  901_nested_structs.hlsl(4,10-14): error X3000: syntax error: unexpected token 'Inner'

DXC:

GLSLANG: FAILED:VS, FAILED:PS
  ERROR: 901_nested_structs.hlsl:6: 'member name' : Expected
  ERROR: 901_nested_structs.hlsl:6: 'struct member declarations' : Expected
  901_nested_structs.hlsl(6): error at column 4, HLSL parsing failed.
  ERROR: 3 compilation errors.  No code generated.

*/
