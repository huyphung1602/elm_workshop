module Picshare exposing (main)

import Browser

import Html exposing (..)
import Html.Attributes exposing (class, src, placeholder, type_, value, disabled)
import Html.Events exposing (onClick, onInput, onSubmit)

baseUrl : String
baseUrl =
    "https://programming-elm.com/"

-- MODEL

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
    , comments = [ "Hoang Do is a bobo boi." ]
    , newComment = ""
    }

-- UPDATE
type Msg
    = ToggleLike
    | UpdateComment String
    | SaveComment

update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleLike ->
            { model | liked = not model.liked }
        UpdateComment comment ->
            { model | newComment = comment }
        SaveComment ->
            saveNewComment model

saveNewComment : Model -> Model
saveNewComment model =
    let
        comment =
            String.trim model.newComment
    in
    case comment of
        "" ->
            model
        _ ->
            { model
                | comments = model.comments ++ [ comment ]
                , newComment = ""
            }

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare" ] ]
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
            [ div [ class "like-button"]
                [ i
                    [ class "fa fa-2x"
                    , class buttonClass
                    , onClick ToggleLike
                    ]
                    []
                ]
            , h2 [ class "caption" ] [ text model.caption ]
            , viewComments model
            ]
        ]

viewComments : Model -> Html Msg
viewComments model =
    div []
        [ viewCommentList model.comments
        , form [ class "new-comment", onSubmit SaveComment]
            [ input
                [ type_ "text"
                , placeholder "Add a comment..."
                , value model.newComment
                , onInput UpdateComment
                ]
                []
            , button [ disabled (String.isEmpty model.newComment) ]
                [ text "Submit" ]
            ]
        ]

viewComment : String -> Html Msg
viewComment comment =
    li []
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
-- MAIN

main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
