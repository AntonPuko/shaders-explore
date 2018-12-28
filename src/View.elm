module View exposing (view, viewShaderCard)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model)
import ToyShader exposing (Size, viewToyShaderCard)
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
            [ viewShaderCard model (Size 400 400)
            ]
        ]
    }


viewShaderCard : Model -> Size -> Html Msg
viewShaderCard model size =
    div
        [ style "border-radius" "10px"
        , style "overflow" "hidden"
        ]
        [ viewToyShaderCard model size ToyFragments.helloWorld ]
