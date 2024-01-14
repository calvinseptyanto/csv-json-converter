port module Main exposing (..)

import Browser
import Html exposing (Html, div, pre, text, input, button)
import Html.Attributes exposing (type_, style)
import Html.Events exposing (onInput, onClick)
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
    { rawLines : List String
    , parsedCsv : String
    , jsonResult : String
    }

-- Define the initial model state
init : () -> ( Model, Cmd Msg )
init _ =
    ( { rawLines = []
      , parsedCsv = ""
      , jsonResult = ""
      }
    , Cmd.none
    )

-- UPDATE

type Msg
    = SetRawLines (List String)
    | SetParsedCsv String
    | SetJsonResult String

-- Define how the model should be updated in response to messages
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetRawLines lines ->
            ( { model | rawLines = lines }
            , Cmd.none
            )

        SetParsedCsv csv ->
            ( { model | parsedCsv = csv }
            , Cmd.none
            )

        SetJsonResult json ->
            ( { model | jsonResult = json }
            , Cmd.none
            )

-- VIEW

-- Define how to render the model as HTML
view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "First Ten Lines of Raw Input:" ]
        , pre [] [ text (String.join "\n" (List.take 10 model.rawLines)) ]
        , div [] [ text "Parsed CSV:" ]
        , pre [] [ text model.parsedCsv ]
        , div [] [ text "JSON Output:" ]
        , pre [] [ text model.jsonResult ]
        , input [ type_ "file", onInput (SetRawLines []), style [ ( "display", "none" ) ] ] []
        , button [ onClick (SetJsonResult "") ] [ text "Download JSON" ]
        ]
        
-- SUBSCRIPTIONS

-- Define subscriptions for your app (none in this case)
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- PORTS

-- Define outbound ports to send data out of Elm
port checkFile : List String -> Cmd msg

port parseCsv : String -> Cmd msg

port downloadJson : Encode.Value -> Cmd msg

-- HELPER FUNCTIONS

-- A helper function to convert JSON values to a formatted string
convertJsonToString : Encode.Value -> String
convertJsonToString jsonValue =
    Encode.encode 2 jsonValue
