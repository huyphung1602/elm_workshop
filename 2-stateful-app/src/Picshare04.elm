module Picshare04 exposing (main)

-- START :import.browser
import Browser
-- END :import.browser

import Html exposing (..)
import Html.Attributes exposing (class, src, placeholder, type_, disabled, value)
import Html.Events exposing(onClick, onInput, onSubmit)

baseUrl : String
baseUrl =
    "https://programming-elm.com/"

-- START : Model
type alias Model =
    { url : String
    , caption : String
    , liked : Bool
    , comments : List String
    , newComment : String
    }

initialModel : Model
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfing"
    , liked = False
    , comments = []
    , newComment = ""
    }
-- END : Model

-- START : View Like Button
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
-- END : View Like Button

-- START : View Comment
viewComment : String -> Html Msg
viewComment comment =
    div []
        [ strong [] [ text "Comment:" ]
        , text (" " ++ comment)
        ]

viewCommentList : List String -> Html Msg
viewCommentList comments =
    case comments of
        [] ->
            text ""
        _ ->
            div [ class "comments" ]
                [ ul []
                    (List.map viewComment comments)
                ]

viewComments : Model -> Html Msg
viewComments model =
    div []
        [ viewCommentList model.comments
        , form [ class "new-comment", onSubmit SaveNewComment ]
            [ input
                [ type_ "text"
                , placeholder "Add your comment"
                , value model.newComment
                , onInput UpdateComment
                ]
                []
            , button [ disabled (String.isEmpty model.newComment) ] [ text "Save" ]
            ]
        ]
-- END : View Comment

-- START : View
viewDetailedPhoto : Model -> Html Msg
viewDetailedPhoto model =
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
            [ viewLikeButton model
            , h2 [ class "caption" ] [ text model.caption ]
            , viewComments model
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
-- END : View

-- START : Save new comment
saveNewComment : Model -> Model
saveNewComment model =
    let
        comment = String.trim model.newComment
    in
    case comment of
        "" ->
            model
        _ ->
            { model | comments = model.comments ++ [ comment ]
            , newComment = ""
            }
-- End : Save new comment

-- START : Update
type Msg
    = ToggleLike
    | UpdateComment String
    | SaveNewComment

update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleLike ->
            { model | liked = not model.liked }
        UpdateComment comment ->
            { model | newComment = comment }
        SaveNewComment ->
            saveNewComment model
-- END : Update

-- START : main
main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
-- END : main
