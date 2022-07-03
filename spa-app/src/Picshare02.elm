module Picshare02 exposing (main)

-- START:import.browser
import Browser
-- END:import.browser

import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing(onClick)

baseUrl : String
baseUrl =
    "https://programming-elm.com/"

-- START: Model
type alias Model =
    { url : String
    , caption : String
    , liked : Bool
    }

initialModel : Model
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfing"
    , liked = False
    }
-- END: Model

-- START: View
view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare"] ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto model ]
        ]

viewDetailedPhoto : Model -> Html Msg
viewDetailedPhoto model =
    let
        buttonClass = 
            if model.liked then
                "fa-heart"
            else
                "fa-heart-o"
    in
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
            [ div [ class "like-button" ]
                [ i
                    [ class "fa fa-2x"
                    , class buttonClass
                    , onClick ToggleLike
                    ]
                    []
                ]
            , h2 [ class "caption" ] [ text model.caption ]
            ]
        ]
-- END: View

-- START : Update
type Msg
    = ToggleLike

update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleLike ->
            { model | liked = not model.liked }
-- END : Update

-- START: main
main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
-- END: main
