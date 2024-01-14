port module Main exposing (..)

import Browser
import Html exposing (Html, div, pre, text, button)
import Html.Attributes exposing (style, id)
import Html.Events exposing (onClick)
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

-- MESSAGES

type Msg
    = ReceiveRawContent String
    | ReceiveParsedCsv String
    | ReceiveJsonResult String
    | RequestDownloadJson

-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveRawContent content ->
            let
                lines = List.take 10 (String.split "\n" content)
            in
            ( { model | rawLines = lines }
            , Cmd.none
            )

        ReceiveParsedCsv csvHtml ->  -- Use 'csvHtml', not 'content'
            ( { model | parsedCsv = csvHtml }, Cmd.none )

        ReceiveJsonResult content ->
            ( { model | jsonResult = content }, Cmd.none )

        RequestDownloadJson ->
            ( model
            , downloadJson (Encode.string model.jsonResult)
            )

view : Model -> Html Msg
view model =
    div []
        [ div [ style "height" "200px"
              , style "overflow" "auto"
              , style "border" "1px solid #ccc"
              , style "padding" "8px"
              ]
            [ div [] [ text "First Ten Lines of Raw Input:" ]
            , pre [] [ text (String.join "\n" (List.take 10 model.rawLines)) ]
            ]
        , div [ style "display" "flex" ]
            [ div [ style "flex" "1"
                  , style "height" "200px"
                  , style "overflow" "auto"
                  , style "border" "1px solid #ccc"
                  , style "padding" "8px"
                  , style "margin-right" "8px"
                  ]
                [ div [] [ text "Parsed CSV:" ]
                , div [ id "csv-content" ] [] -- Placeholder for the CSV content
                ]
            , div [ style "flex" "1"
                  , style "height" "200px"
                  , style "overflow" "auto"
                  , style "border" "1px solid #ccc"
                  , style "padding" "8px"
                  ]
                [ div [] [ text "JSON Output:" ]
                , pre [] [ text model.jsonResult ] -- JSON is displayed with `pre` for formatting
                ]
            ]
        , button [ onClick RequestDownloadJson
                 , style "display" (if model.jsonResult == "" then "none" else "inline-block")
                 , style "margin-top" "16px"
                 ] [ text "Download JSON" ]
        ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ rawContentReceived ReceiveRawContent
        , parsedCsvContentReceived ReceiveParsedCsv
        , jsonContentReceived ReceiveJsonResult
        ]

-- PORTS

port rawContentReceived : (String -> msg) -> Sub msg
port parsedCsvContentReceived : (String -> msg) -> Sub msg
port jsonContentReceived : (String -> msg) -> Sub msg
port downloadJson : Encode.Value -> Cmd msg