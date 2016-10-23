module WeatherConditionsTests exposing (..)

import Test exposing (..)
import Expect
import String
import Decoders
import Json.Decode exposing (int, string, float, Decoder)
import TestUtils exposing (..)


runWeatherConditionsDecoder json =
    Json.Decode.decodeString
        Decoders.weatherConditionsDecoder
        json


goodWeatherConditions : Test
goodWeatherConditions =
    test "Properly processes weather conditions" <|
        \() ->
            let
                input =
                    """
                      { "current_observation" :
                          { "city" : "Boston",
                            "state" : "MA",
                            "temp_f" : 98.6 }
                      }
                    """

                decodedOutput =
                    runWeatherConditionsDecoder input
            in
                Expect.equal decodedOutput
                    (Ok
                        { currentObservation =
                            { city = "Boston"
                            , state = "MA"
                            , tempF = 98.6
                            }
                        }
                    )


badWeatherConditions : Test
badWeatherConditions =
    test "Properly processes weather conditions" <|
        \() ->
            let
                input =
                    """
                      { "no_current_observation" :
                           { "temp_f" : 98.6 }
                      }
                    """

                decodedOutput =
                    runWeatherConditionsDecoder input
            in
                Expect.equal (success decodedOutput) False


tests =
    [ goodWeatherConditions
    , badWeatherConditions
    ]
