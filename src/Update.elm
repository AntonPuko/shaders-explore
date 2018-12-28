module Update exposing (Msg(..), update)

import Browser
import Browser.Navigation as Nav
import Model exposing (Model)
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | TimeDiff Float


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
