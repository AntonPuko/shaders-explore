module Init exposing (init)

import Browser.Navigation as Nav
import Model exposing (Model)
import Update exposing (Msg)
import Url


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url 0, Cmd.none )
