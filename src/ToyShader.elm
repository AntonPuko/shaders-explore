module ToyShader exposing (Size, ToyFragmentShader, ToyUniforms, viewToyShaderCard)

import Html exposing (..)
import Html.Attributes exposing (..)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Model exposing (Model)
import Update exposing (Msg)
import WebGL exposing (Mesh, Shader)


type alias Vertex =
    { position : Vec3
    }



-- todo make opaque?


type alias Size =
    { width : Int
    , height : Int
    }


type alias ToyUniforms =
    { iResolution : Vec3
    , iGlobalTime : Float
    }


type alias ToyFragmentShader =
    Shader {} ToyUniforms { vFragCoord : Vec2 }


toyMesh : Mesh Vertex
toyMesh =
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


toyVertexShader : Shader Vertex ToyUniforms { vFragCoord : Vec2 }
toyVertexShader =
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


viewToyShaderCard : Model -> Size -> ToyFragmentShader -> Html Msg
viewToyShaderCard model size toyFragmentShader =
    div
        [ style "border-radius" "10px"
        , style "overflow" "hidden"
        ]
        [ viewToyShader model size toyFragmentShader ]


viewToyShader : Model -> Size -> ToyFragmentShader -> Html Msg
viewToyShader model size toyFragmentShader =
    WebGL.toHtml
        [ width size.width
        , height size.height
        , style "display" "block"
        ]
        [ WebGL.entity
            toyVertexShader
            toyFragmentShader
            toyMesh
            { iResolution = vec3 (toFloat size.width) (toFloat size.height) 0
            , iGlobalTime = model.time / 1000
            }
        ]
