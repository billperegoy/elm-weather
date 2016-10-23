module Tests exposing (..)

import Test exposing (..)
import CurrentObservationTests
import WeatherConditionsTests


tests : List (List Test)
tests =
    [ CurrentObservationTests.tests
    , WeatherConditionsTests.tests
    ]


all : Test
all =
    describe "elm-weather tests"
        (List.concat tests)
