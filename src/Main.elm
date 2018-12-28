module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Init exposing (init)
import Model exposing (Model)
import Subs exposing (subscriptions)
import Update exposing (Msg(..), update)
import View exposing (view)


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
