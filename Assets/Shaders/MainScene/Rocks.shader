Shader "Scenes/Main/Rocks"
{
        Properties {

       _ColorMap ("ColorMap", 2D) = "white" {}
       _TextureMap ("TextureMap", 2D) = "white" {}

       _PLightMap1 ("PLightMap1", 2D) = "white" {}
       _PLightMap2 ("PLightMap2", 2D) = "white" {}
       _PLightMap3 ("PLightMap3", 2D) = "white" {}
       _PLightMap4 ("PLightMap4", 2D) = "white" {}
    _CubeMap( "Cube Map" , Cube )  = "defaulttexture" {}
    
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off
        Pass
        {

          Stencil
{
Ref 7
Comp always
Pass replace
ZFail keep
}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            #include "UnityCG.cginc"

            #pragma multi_compile_fwdbase
            #pragma fragmentoption ARB_precision_hint_fastest

            #include "AutoLight.cginc"

            #include "../Chunks/Struct16.cginc"


            struct v2f { 
                float4 pos : SV_POSITION; 
                float3 nor : NORMAL; 
                float3 world : TEXCOORD1; 
                float2 uv  : TEXCOORD2; 

// in v2f struct;
LIGHTING_COORDS(5,6)

            };
            float4 _Color;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;


           sampler2D _ColorMap;
            sampler2D _TextureMap;

            sampler2D _PLightMap1;
            sampler2D _PLightMap2;
            sampler2D _PLightMap3;
            sampler2D _PLightMap4;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;
                Vert v = _VertBuffer[_TriBuffer[vid]];
                o.pos = mul (UNITY_MATRIX_VP, float4(v.pos,1.0f));
                o.uv = v.uv;
                o.nor = v.nor;
                o.world = v.pos;


TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            fixed4 frag (v2f v) : SV_Target
            {
float4 p1 = tex2D( _PLightMap1 , v.uv * 3 );
float4 p2 = tex2D( _PLightMap2 , v.uv * 3 );
float4 p3 = tex2D( _PLightMap3 , v.uv * 3 );
float4 p4 = tex2D( _PLightMap4 , v.uv * 3 );

  float3 fNor = normalize(v.nor);
                float m = 1-dot(_WorldSpaceLightPos0.xyz , fNor);

             

///in frag shader;
float atten = LIGHT_ATTENUATION(v);
                //m = 1-pow(-fern,.7);//*fern*fern;//pow( fern * fern, 1);
                //m = saturate( 1-m );

//                m = (-m* atten);

                m = 3 * (m*(1-atten));


                float fLM =  m;


                float4 fLCol = float4(1,0,0,1);
                if( fLM < 1 ){
                    fLCol = lerp( p1 , p2 , fLM );
                }else if( fLM >= 1 && fLM < 2){
                    fLCol = lerp( p2 , p3 , fLM-1 );
                }else if( fLM >= 2 && fLM < 3){
                    fLCol = lerp( p3 , p4 , fLM-2 );
                }else{
                    fLCol = p4;
                }

                // sample the texture
float4 s2 = tex2D( _ColorMap , float2(m* .04+.5, 0) );


                float3 fCol= fLCol*s2;//v.nor * .5 + .5;
                fixed4 col = float4(fCol,1);//fLCol;//float4( i.nor * .5 + .5 , 1);//tex2D(_MainTex, i.uv);
                return col;
            }

            ENDCG
        }

                          // SHADOW PASS

    Pass
    {
      Tags{ "LightMode" = "ShadowCaster" }


      Fog{ Mode Off }
      ZWrite On
      ZTest LEqual
      Cull Off
      Offset 1, 1
      CGPROGRAM

      #pragma target 4.5
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile_shadowcaster
      #pragma fragmentoption ARB_precision_hint_fastest

      #include "UnityCG.cginc"
  

      #include "../Chunks/ShadowCasterPos.cginc"


            struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 debug;
    };



      StructuredBuffer<Vert> _VertBuffer;
      StructuredBuffer<int> _TriBuffer;

      struct v2f {
        V2F_SHADOW_CASTER;
        float3 nor : NORMAL;
      };


      v2f vert(appdata_base input, uint id : SV_VertexID)
      {
        v2f o;
        Vert v = _VertBuffer[_TriBuffer[id]];
        o.nor = normalize( v.nor);
        float4 position = ShadowCasterPos(v.pos, normalize(v.nor));
        o.pos = UnityApplyLinearShadowBias(position);
        return o;
      }

      float4 frag(v2f i) : COLOR
      {
        SHADOW_CASTER_FRAGMENT(i)
      }
      ENDCG
    }


Pass
    {

// Outline Pass
Cull OFF
ZWrite OFF
ZTest ON
Stencil
{
Ref 7
Comp notequal
Fail keep
Pass replace
}
      
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            // make fog work
            #pragma multi_compile_fogV
 #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
    


               struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 debug;
    };


            struct v2f { 
              float4 pos : SV_POSITION; 
            };
            float4 _Color;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;

        
                Vert v = _VertBuffer[_TriBuffer[vid]];
                float3 fPos = v.pos + v.nor * .005;
                o.pos = mul (UNITY_MATRIX_VP, float4(fPos,1.0f));


                return o;
            }

            sampler2D _ColorMap;
            fixed4 frag (v2f v) : SV_Target
            {
              
                fixed4 col = 0;//1;//tex2D(_ColorMap, float2( .8,0));
                return col;
            }

            ENDCG
        }

    
  

  
  
    }

FallBack "Diffuse"
}