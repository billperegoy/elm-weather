module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (..)
import Date exposing (..)
import Task exposing (..)
import Http exposing (..)
import Decoders
import ApiKeys
import HttpUtils


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias TemperatureReading =
    { temperature : Float
    , time : Float
    }


type alias Model =
    { lastUpdateTime : Time
    , temperature : Float
    , history : List TemperatureReading
    , error : String
    }


init : ( Model, Cmd Msg )
init =
    Model 0.0 0.0 [] "" ! [ Task.perform UpdateTime Time.now ]



-- Http


getCurrentConditions : Cmd Msg
getCurrentConditions =
    let
        url =
            "http://api.wunderground.com/api/"
                ++ ApiKeys.weatherUnderground
                ++ "/conditions/q/MA/Charlestown.json"
    in
        Http.send UpdateWeather
            (Http.get url Decoders.weatherConditionsDecoder)



-- Update


updateHistory : Model -> Float -> List TemperatureReading
updateHistory model temperature =
    let
        head =
            List.head model.history
    in
        case head of
            Just elem ->
                if temperature /= elem.temperature then
                    TemperatureReading temperature model.lastUpdateTime :: model.history
                else
                    model.history

            Nothing ->
                TemperatureReading temperature model.lastUpdateTime :: model.history


type Msg
    = UpdateTime Time
    | UpdateWeather (Result Http.Error Decoders.WeatherConditions)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTime time ->
            { model | lastUpdateTime = time } ! [ getCurrentConditions ]

        UpdateWeather (Ok weather) ->
            { model
                | temperature = weather.currentObservation.tempF
                , history = updateHistory model weather.currentObservation.tempF
                , error = ""
            }
                ! []

        UpdateWeather (Err error) ->
            { model | error = HttpUtils.errorString error } ! []



-- View


zeroExtend : String -> String
zeroExtend string =
    if String.length string == 1 then
        "0" ++ string
    else
        string


timeToDateString : Time -> String
timeToDateString time =
    let
        date =
            time
                |> Date.fromTime
    in
        (Date.dayOfWeek date |> toString)
            ++ "  "
            ++ (Date.hour date |> toString |> zeroExtend)
            ++ ":"
            ++ (Date.minute date |> toString |> zeroExtend)


errorDisplay : Model -> Html Msg
errorDisplay model =
    if model.error /= "" then
        div
            [ class "alert alert-danger" ]
            [ text (String.slice 0 79 model.error) ]
    else
        div [] []


temperatureHistory : List TemperatureReading -> Html Msg
temperatureHistory readings =
    div []
        [ h1 [] [ text "History" ]
        , table [ style [ ( "width", "200px" ) ], class "table table-striped" ]
            [ tbody []
                (List.map
                    (\elem -> historyElement elem)
                    readings
                )
            ]
        ]


historyElement : TemperatureReading -> Html Msg
historyElement element =
    tr []
        [ td [] [ text (timeToDateString element.time) ]
        , td [] [ text (toString element.temperature) ]
        ]


currentConditions : Model -> Html Msg
currentConditions model =
    div [ class "row" ]
        [ div
            [ class "col-md-4 alert alert-info"
            , style [ ( "width", "200px" ) ]
            ]
            [ text ("Last Update: " ++ timeToDateString model.lastUpdateTime) ]
        , div
            [ class "col-md-4 alert alert-info"
            , style [ ( "width", "200px" ) ]
            ]
            [ text ("Current Temperature: " ++ toString model.temperature) ]
        ]


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ errorDisplay model
        , currentConditions model
        , temperatureHistory model.history
        ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (5 * Time.minute) UpdateTime
