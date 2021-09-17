Shader "Custom/Ground"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Normal("Normal", 2D) = "white" {}
        [Header(Distortion)]
        _Distortion("Distortion", 2D) = "white" {}
        _Scale("Scale", Float) = 1
        _DistortionIntensity("Intensity", Float) = 1
        [Header(Foam)]
        _WaterFoam("WaterFoam", 2D) = "white" {}
        _FoamDistortion("Distortion", 2D) = "white" {}
        _FoamIntensity("Foam Intensity", Float) = 0.3
        _FoamDistortionScale("Distortion Scale", Float) = 1
        _FoamDistortionIntensity("Distortion Intensity", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Normal;
        sampler2D _Distortion;
        sampler2D _WaterFoam;
        sampler2D _FoamDistortion;
        float _Scale;
        float _DistortionIntensity;
        float _FoamIntensity;
        float _FoamDistortionIntensity;
        float _FoamDistortionScale;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Normal;
            float2 uv_WaterFoam;
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //Sand distortion
            float2 offsetUV = IN.uv_Normal;
            offsetUV *= _Scale;
            float4 Distortion = tex2D(_Distortion, offsetUV);
            IN.uv_Normal.x += Distortion.a * _DistortionIntensity;
            IN.uv_Normal.y -= Distortion.a * _DistortionIntensity;

            //Read waterfoam
            float2 foamOffsetUV = IN.uv_WaterFoam;
            foamOffsetUV *= _FoamDistortionScale;
            foamOffsetUV.x -= _Time * 1.4;
            foamOffsetUV.y -= _Time ;

            float4 foamDistortion = tex2D(_FoamDistortion, foamOffsetUV);
            IN.uv_WaterFoam.x += foamDistortion.a * _FoamDistortionIntensity;
            IN.uv_WaterFoam.y -= foamDistortion.a * _FoamDistortionIntensity;

            fixed4 foamC = tex2D(_WaterFoam, IN.uv_WaterFoam);
            fixed4 groundC = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 c = foamC * _FoamIntensity + groundC;

            o.Albedo = c.rgb;
            o.Alpha = c.a;
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
