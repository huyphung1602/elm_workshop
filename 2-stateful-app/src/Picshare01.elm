module Picshare01 exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class, src)

baseUrl : String
baseUrl =
    "https://programming-elm.com/"

-- START : Model
type alias Model =
    { url : String
    , caption : String
    }

initialModel : Model
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfing"
    }
-- END : Model

-- START : View
view : Model -> Html msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare"] ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto model ]
        ]

viewDetailedPhoto : Model -> Html msg
viewDetailedPhoto model =
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
            [ h2 [ class "caption" ] [ text model.caption ]]
        ]
-- END : View

-- START : main
main : Html msg
main =
    view initialModel
-- END : main