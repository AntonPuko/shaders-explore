module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onResize)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Vector4 as Vec4 exposing (Vec4, vec4)
import Url
import WebGL exposing (Mesh, Shader)


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , time : Float
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | TimeDiff Float


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        TimeDiff delta ->
            ( { model | time = model.time + delta }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onAnimationFrameDelta TimeDiff ]


view : Model -> Browser.Document Msg
view { time } =
    { title = "Shaders Explore"
    , body =
        [ div [] [ text "time: ", text (String.fromFloat (time / 1000)) ]
        , WebGL.toHtml
            [ width 500
            , height 500
            , style "display" "block"
            ]
            [ WebGL.entity
                vertexShader
                fragmentShader
                mesh
                { iResolution = vec3 (toFloat 500) (toFloat 500) 0
                , iGlobalTime = time / 1000
                , iMouse = vec4 (toFloat 0) (toFloat 0) 0 0
                }
            ]
        ]
    }


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
    , iMouse : Vec4
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
        uniform vec4      iMouse;
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
