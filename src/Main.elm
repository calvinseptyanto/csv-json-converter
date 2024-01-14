port module Main exposing (..)

import Browser
import Html exposing (Html, button, div, pre, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Json.Encode as Encode


-- MAIN

main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL

type alias Model =
    { jsonResult : String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { jsonResult = "" }
    , Cmd.none
    )