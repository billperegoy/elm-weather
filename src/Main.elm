module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Time exposing (..)
import Date exposing (..)
import Task exposing (..)


main : Program Never
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
    Model 0.0 ! [ Task.perform Error UpdateWeather Time.now ]



-- Update


type Msg
    = UpdateWeather Time
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateWeather time ->
            { model | lastUpdateTime = time } ! []

        Error _ ->
            model ! []



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
