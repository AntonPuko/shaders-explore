module ToyShader.Fragments exposing (circle, helloWorld)

import Math.Vector2 as Vec2 exposing (Vec2)
import ToyShader exposing (ToyFragmentShader)
import WebGL exposing (Shader)


helloWorld : ToyFragmentShader
helloWorld =
    [glsl|
        precision mediump float;
        varying vec2      vFragCoord;
        uniform vec3      iResolution;
        uniform float     iGlobalTime;

        void mainImage( out vec4 fragColor, in vec2 fragCoord) {
            vec2 uv = fragCoord.xy / iResolution.xy;
            float aspectRatio = iResolution.x / iResolution.y;

            uv.x *= aspectRatio;

            vec3 color =  vec3(uv.x, uv.y, abs(sin(iGlobalTime))); 

            fragColor = vec4(color, 1.0);
        }

        void main() {
            mainImage(gl_FragColor, vFragCoord);
        }
    |]


circle : ToyFragmentShader
circle =
    [glsl|
        precision mediump float;
        varying vec2      vFragCoord;
        uniform vec3      iResolution;
        uniform float     iGlobalTime;

        void mainImage( out vec4 fragColor, in vec2 fragCoord) {
            vec2 uv = fragCoord.xy / iResolution.xy;
            float aspectRatio = iResolution.x / iResolution.y;
            uv.x *= aspectRatio;

            uv -= 0.5;

            float distance = length(uv);
            float radius = abs(sin(iGlobalTime) / 2.0 + 0.1);

            float col = 1.0 - smoothstep(radius, radius + 0.01, distance);
            fragColor = vec4(vec3(col), 1.0);
        }

        void main() {
            mainImage(gl_FragColor, vFragCoord);
        }
    |]
