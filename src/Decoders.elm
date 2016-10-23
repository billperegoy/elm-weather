module Decoders exposing (..)

import Json.Decode exposing (int, string, float, Decoder)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


-- http://api.wunderground.com/api/c83a6598d579714d/conditions/q/CA/San_Francisco.json
-- Here is an example of the weather underground API output
{--
 { "current_observation" :
   {
     "city" : Boston",
     "state" : "MA",
     "temp_f" : 98.6
   }
 }
--}


type alias WeatherConditions =
    { currentObservation : CurrentObservation
    }


type alias CurrentObservation =
    { city : String
    , state : String
    , tempF : Float
    }


currentObservationDecoder : Decoder CurrentObservation
currentObservationDecoder =
    decode CurrentObservation
        |> Json.Decode.Pipeline.required "city" Json.Decode.string
        |> Json.Decode.Pipeline.required "state" Json.Decode.string
        |> Json.Decode.Pipeline.required "temp_f" Json.Decode.float


weatherConditionsDecoder : Decoder WeatherConditions
weatherConditionsDecoder =
    decode WeatherConditions
        |> Json.Decode.Pipeline.required "current_observation" currentObservationDecoder
