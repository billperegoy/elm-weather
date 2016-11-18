module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (..)
import Date exposing (..)
import Task exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { lastUpdateTime : Time }


init : ( Model, Cmd Msg )
init =
    Model 0.0 ! [ Task.perform UpdateWeather Time.now ]



-- Update


type Msg
    = UpdateWeather Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateWeather time ->
            { model | lastUpdateTime = time } ! []



-- View


view : Model -> Html Msg
view model =
    p []
        [ text
            (model.lastUpdateTime
                |> Date.fromTime
                |> toString
            )
        ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.minute UpdateWeather
