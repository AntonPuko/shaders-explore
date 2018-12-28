module Subs exposing (subscriptions)

import Browser.Events exposing (onAnimationFrameDelta)
import Model exposing (Model)
import Update exposing (Msg(..))


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onAnimationFrameDelta TimeDiff ]
