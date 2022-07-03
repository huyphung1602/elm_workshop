module Picshare exposing (main)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)

-- START: Main
main : Html msg
main =
    div [ class "header"]
        [ h1 [] [ text "Picshare" ] ]
-- END: Main
