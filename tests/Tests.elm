module Tests exposing (..)

import Test exposing (..)
import Expect
import CurrentObservationTests


tests : List (List Test)
tests =
    [ CurrentObservationTests.tests
    , otherTests
    ]


otherTests =
    [ test "Dummy Test" <|
        \() ->
            Expect.equal 1 1
    ]


all : Test
all =
    describe "All Decoder Tests"
        (List.concat tests)
