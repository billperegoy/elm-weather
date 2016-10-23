module TestUtils exposing (..)


success : Result a b -> Bool
success result =
    case result of
        Ok _ ->
            True

        Err _ ->
            False
