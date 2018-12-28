module View exposing (Size, Uniforms, Vertex, fragmentShader, mesh, vertexShader, view, viewShader, viewShaderCard)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Model exposing (Model)
import Update exposing (Msg)
import WebGL exposing (Mesh, Shader)


view : Model -> Browser.Document Msg
view model =
    { title = "Shaders Explore"
    , body =
        [ div []
            [ text "time: "
            , text (String.fromFloat (model.time / 1000))
            ]
        , div [ style "display" "flex" ]
            [ viewShaderCard model (Size 400 400)
            ]
        ]
    }


type alias Size =
    { width : Int
    , height : Int
    }


viewShaderCard : Model -> Size -> Html Msg
viewShaderCard model size =
    div
        [ style "border-radius" "10px"
        , style "overflow" "hidden"
        ]
        [ viewShader model size ]


viewShader : Model -> Size -> Html Msg
viewShader model size =
    WebGL.toHtml
        [ width size.width
        , height size.height
        , style "display" "block"
        ]
        [ WebGL.entity
            vertexShader
            fragmentShader
            mesh
            { iResolution = vec3 (toFloat size.width) (toFloat size.height) 0
            , iGlobalTime = model.time / 1000
            }
        ]


type alias Vertex =
    { position : Vec3
    }


mesh : Mesh Vertex
mesh =
    WebGL.triangles
        [ ( Vertex (vec3 -1 1 0)
          , Vertex (vec3 1 1 0)
          , Vertex (vec3 -1 -1 0)
          )
        , ( Vertex (vec3 -1 -1 0)
          , Vertex (vec3 1 1 0)
          , Vertex (vec3 1 -1 0)
          )
        ]


type alias Uniforms =
    { iResolution : Vec3
    , iGlobalTime : Float
    }


vertexShader : Shader Vertex Uniforms { vFragCoord : Vec2 }
vertexShader =
    [glsl|
        precision mediump float;
        attribute vec3 position;
        varying vec2 vFragCoord;
        uniform vec3 iResolution;
        void main () {
            gl_Position = vec4(position, 1.0);
            vFragCoord = (position.xy + 1.0) / 2.0 * iResolution.xy;
        }
    |]


fragmentShader : Shader {} Uniforms { vFragCoord : Vec2 }
fragmentShader =
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
