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
    | FileRead String -- Changed to String to receive raw JSON

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FileSelected content ->
            ( model
            , checkFile content
            )

        FileRead jsonString ->
            -- Decode jsonString inside Elm now
            case Decode.decodeString Decode.value jsonString of
                Ok value ->
                    ( { model | jsonResult = Encode.encode 2 value }
                    , Cmd.none
                    )

                Err error ->
                    ( { model | jsonResult = "Could not decode JSON from the file: " ++ Decode.errorToString error }
                    , Cmd.none
                    )

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (FileSelected "") ] [ text "Click to select a CSV file." ]
        , div [] [ pre [] [ text model.jsonResult ] ]
        ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    convertComplete FileRead

-- PORTS

port checkFile : String -> Cmd msg

port convertComplete : (String -> msg) -> Sub msg