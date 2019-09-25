Shader "Scenes/SpacePup/Body"
{
    Properties {

       _ColorMap ("ColorMap", 2D) = "white" {}
       _TextureMap ("TextureMap", 2D) = "white" {}
       _PLightMap1 ("PLightMap1", 2D) = "white" {}
       _PLightMap2 ("PLightMap2", 2D) = "white" {}
       _PLightMap3 ("PLightMap3", 2D) = "white" {}
       _PLightMap4 ("PLightMap4", 2D) = "white" {}
       _PLightMap5 ("PLightMap5", 2D) = "white" {}

    _CubeMap( "Cube Map" , Cube )  = "defaulttexture" {}
    
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


            struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 offset;
      float4 debug;
      float3 connections[16];
    };


            struct v2f { 
                float4 pos : SV_POSITION; 
                float3 nor : NORMAL; 
                float debug : TEXCOORD0; 
                float3 eye : TEXCOORD1; 
                float2 uv : TEXCOORD3; 
                float3 world : TEXCOORD2; 
                float4 screenPos : TEXCOORD4; 
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
            sampler2D _PLightMap5;

      samplerCUBE _CubeMap;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;
                Vert v = _VertBuffer[_TriBuffer[vid]];
            
            
                o.world = v.pos;
                o.uv = v.uv;
                o.pos = mul (UNITY_MATRIX_VP, float4(v.pos,1));
                o.nor = v.nor;//normalize(cross(v0.pos - v1.pos , v0.pos - v2.pos ));
                o.debug = v.debug;
                o.eye = v.pos - _WorldSpaceCameraPos;
                o.screenPos = ComputeScreenPos(float4(v.pos,1));
                return o;
            }

            fixed4 frag (v2f v) : SV_Target
            {


                float4 t1 = tex2D(_TextureMap , v.world.zy * .1 ) * abs(v.nor.x);
                float4 t2 = tex2D(_TextureMap , v.world.xz * .1 ) * abs(v.nor.y);
                float4 t3 = tex2D(_TextureMap , v.world.xy * .1 ) * abs(v.nor.z);

                float4 t = tex2D(_TextureMap , v.uv * 4 );


               //float4 p1 = tex2D( _PLightMap1 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
               //float4 p2 = tex2D( _PLightMap2 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
               //float4 p3 = tex2D( _PLightMap3 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
               //float4 p4 = tex2D( _PLightMap4 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
               //float4 p5 = tex2D( _PLightMap5 , (v.debug * .3 + 1) * (v.screenPos.yx / v.screenPos.w) * 4 );
           
 float4 p1 = tex2D( _PLightMap1 , v.uv * 10 );
 float4 p2 = tex2D( _PLightMap2 , v.uv * 10 );
 float4 p3 = tex2D( _PLightMap3 , v.uv * 10 );
 float4 p4 = tex2D( _PLightMap4 , v.uv * 10 );
 float4 p5 = tex2D( _PLightMap5 , v.uv * 10 );
                float4 tFinal = t1 + t2 + t3;


                float3 fNor = v.nor;// + .9*float3( t1.x , t2.x, t3.x);
                fNor = normalize( fNor );

                float3 refl = reflect( normalize( v.eye ), fNor );
                float m = dot(_WorldSpaceLightPos0.xyz , fNor);

                float fern = dot( normalize( v.eye ), normalize(fNor) );
 
                m = 1-pow(fern,.7);//*fern*fern;//pow( fern * fern, 1);
                //m = saturate( 1-m );
                m = 5 * m;

                float4 fLCol = float4(1,0,0,1);
                if( m < 1 ){
                    fLCol = lerp( p1 , p2 , m );
                }else if( m >= 1 && m < 2){
                    fLCol = lerp( p2 , p3 , m-1 );
                }else if( m >= 2 && m < 3){
                    fLCol = lerp( p3 , p4 , m-2 );
                }else if( m >= 3 && m < 4){
                    fLCol = lerp( p4 , p5 , m-3 );
                }else if( m >= 4 && m < 5){
                    fLCol = lerp( p5 , p5 , m-4 );
                }else{
                    fLCol = p5;
                }






                float4 s = texCUBE( _CubeMap , refl );
                float4 s2 = tex2D( _TextureMap , float2(s.x  * .2   + .9, 0) );

                float fVal = (fLCol * .7 + .3) * s2;

                float4 fCol = s;//tex2D(_ColorMap , float2(saturate(fVal * .2 + .4 - .1*v.debug),0)) * (1-fVal) * s;//(v.debug * .4+.3);
               
                fCol.xyz = fNor * .5 + .5;//s*fLCol;//saturate( -fCol );
                // sample the texture
                fixed4 col = fCol;//(fLCol * .7 + .3) * s2;//(fLCol.x  * .8 + .2) * s2 * s;//float4( fNor * .5 + .5 , 1);//tex2D(_MainTex, i.uv);
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
      float2 offset;
      float4 debug;
      float3 connections[16];
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

        float4 position = ShadowCasterPos(v.pos, -v.nor);
        o.pos = UnityApplyLinearShadowBias(position);
        return o;
      }

      float4 frag(v2f i) : COLOR
      {
        SHADOW_CASTER_FRAGMENT(i)
      }
      ENDCG
    }
    }
}