module CurrentObservationTests exposing (..)

import Test exposing (..)
import Expect
import String
import Decoders
import Json.Decode exposing (int, string, float, Decoder)
import TestUtils exposing (..)


runCurrentObserverDecoder : String -> Result String Decoders.CurrentObservation
runCurrentObserverDecoder json =
    Json.Decode.decodeString
        Decoders.currentObservationDecoder
        json


decodesGoodTemperature : Test
decodesGoodTemperature =
    test "Properly decodes a good temperature" <|
        \() ->
            let
                input =
                    """
                      { "city" : "Boston",
                          "state" : "MA",
                          "temp_f" : 98.6 }
                    """

                decodedOutput =
                    runCurrentObserverDecoder input
            in
                Expect.equal decodedOutput
                    (Ok
                        { city = "Boston"
                        , state = "MA"
                        , tempF = 98.6
                        }
                    )


allowsExtraJsonFields : Test
allowsExtraJsonFields =
    test "Allows extra JSON fields" <|
        \() ->
            let
                input =
                    """
                       { "weather" : "clear",
                          "city" : "Boston",
                          "state" : "MA",
                          "temp_f" : 98.6 }
                    """

                decodedOutput =
                    runCurrentObserverDecoder input
            in
                Expect.equal decodedOutput
                    (Ok
                        { city = "Boston"
                        , state = "MA"
                        , tempF = 98.6
                        }
                    )


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


tests =
    [ decodesGoodTemperature
    , allowsExtraJsonFields
    , failsWithNonNumericTemperature
    , failsIfNoTempSpecified
    ]
