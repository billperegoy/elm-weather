module CurrentObservationTests exposing (..)

import Test exposing (..)
import Expect
import String
import Decoders
import Json.Decode exposing (int, string, float, Decoder)


success : Result a b -> Bool
success result =
    case result of
        Ok _ ->
            True

        Err _ ->
            False


runCurrentObserverDecoder json =
    Json.Decode.decodeString
        Decoders.currentObservationDecoder
        json


runWeatherConditionsDecoder json =
    Json.Decode.decodeString
        Decoders.weatherConditionsDecoder
        json


decodesGoodTemperature : Test
decodesGoodTemperature =
    test "Properly decodes a good temperature" <|
        \() ->
            let
                input =
                    """ { "temp_f" : 98.6 } """

                decodedOutput =
                    runCurrentObserverDecoder input
            in
                Expect.equal decodedOutput (Ok { tempF = 98.6 })


allowsExtraJsonFields : Test
allowsExtraJsonFields =
    test "Allows extra JSON fields" <|
        \() ->
            let
                input =
                    """ { "weather" : "clear", "temp_f" : 98.6 } """

                decodedOutput =
                    runCurrentObserverDecoder input
            in
                Expect.equal decodedOutput (Ok { tempF = 98.6 })


failsWithNonNumericTemperature : Test
failsWithNonNumericTemperature =
    test "Fails if temperature is not a number" <|
        \() ->
            let
                input =
                    """ { "temp_f" : "not a float" } """

                decodedOutput =
                    runCurrentObserverDecoder input
            in
                Expect.equal (success decodedOutput) False


failsIfNoTempSpecified : Test
failsIfNoTempSpecified =
    test "Fails if temp_f field is not there" <|
        \() ->
            let
                input =
                    """ { "temp" : 98.6 } """

                decodedOutput =
                    runCurrentObserverDecoder input
            in
                Expect.equal (success decodedOutput) False


goodWeatherConditions : Test
goodWeatherConditions =
    test "Properly processes weather conditions" <|
        \() ->
            let
                input =
                    """ { "current_observation" : { "temp_f" : 98.6 }} """

                decodedOutput =
                    runWeatherConditionsDecoder input
            in
                Expect.equal decodedOutput
                    (Ok
                        { currentObservation =
                            { tempF =
                                98.6
                            }
                        }
                    )


badWeatherConditions : Test
badWeatherConditions =
    test "Properly processes weather conditions" <|
        \() ->
            let
                input =
                    """ { "no_current_observation" :
                           { "temp_f" : 98.6 }
                        } """

                decodedOutput =
                    runWeatherConditionsDecoder input
            in
                Expect.equal (success decodedOutput) False


tests =
    [ decodesGoodTemperature
    , allowsExtraJsonFields
    , failsWithNonNumericTemperature
    , failsIfNoTempSpecified
    , goodWeatherConditions
    , badWeatherConditions
    ]
