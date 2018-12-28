module View exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model)
import ToyShader exposing (Size, viewToyShaderCardPreview)
import ToyShader.Fragments as ToyFragments
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
            [ viewToyShaderCardPreview model ToyFragments.helloWorld
            , viewToyShaderCardPreview model ToyFragments.circle
            ]
        ]
    }
