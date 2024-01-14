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

-- UPDATE

type Msg
    = FileSelected String
    | FileRead (Result Decode.Error Encode.Value)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FileSelected content ->
            ( model
            , checkFile content
            )

        FileRead result ->
            case result of
                Ok value ->
                    ( { model | jsonResult = Encode.encode 2 value }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | jsonResult = "Could not decode JSON from the file." }
                    , Cmd.none
                    )

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (FileSelected "") ] [ text "Select CSV File" ]
        , div [] [ pre [] [ text model.jsonResult ] ]
        ]