-- module Picshare exposing (main)

-- import Html exposing (..)
-- import Html.Attributes exposing (class, src)

-- baseUrl : String
-- baseUrl =
--     "https://programming-elm.com"

-- viewDetailedPhoto : String -> String -> Html msg
-- viewDetailedPhoto url caption =
--     div [ class "detailed-photo" ]
--         [ img [ src url ] []
--         , div [ class "photo-info" ]
--             [ h2 [ class caption ] [ text caption ]]
--         ]

-- -- START: Main
-- main : Html msg
-- main =
--     div []
--     [ div [ class "header" ]
--         [ h1 [] [ text "Picshare"] ]
--     , div [ class "content-flow" ]
--         [ div [ class "detailed-photo" ]
--             [ viewDetailedPhoto (baseUrl ++ "1.jpg") "Surfing"
--             , viewDetailedPhoto (baseUrl ++ "2.jpg") "The Fox"
--             , viewDetailedPhoto (baseUrl ++ "3.jpg") "Evening"
--             ]
--         ]
--     ]
-- -- END: Main

module Picshare exposing (main)

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
viewLikeButton : Model -> Html Msg
viewLikeButton model =
    let
        buttonClass = 
            if model.liked then
                "fa-heart"
            else
                "fa-heart-o"
    in
    div [ class "like-button"]
        [ i
            [ class "fa fa-2x"
            , class buttonClass
            , onClick ToggleLike
            ]
            []
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
            [ viewLikeButton model
            , h2 [ class "caption" ] [ text model.caption ]
            ]
        ]

view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare"] ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto model ]
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
