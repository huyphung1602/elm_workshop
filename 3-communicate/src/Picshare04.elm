module Picshare04 exposing (main, photoDecoder)

-- START :import.browser
import Browser
-- END :import.browser

import Html exposing (..)
import Html.Attributes exposing (class, src, placeholder, type_, disabled, value)
import Html.Events exposing(onClick, onInput, onSubmit)
import Json.Decode exposing (Decoder, bool, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, required)
import Http

baseUrl : String
baseUrl =
    "https://programming-elm.com/"

-- START : photoDecoder
photoDecoder : Decoder Photo
photoDecoder =
    succeed Photo
        |> required "id" int
        |> required "url" string
        |> required "caption" string
        |> required "liked" bool
        |> required "comments" (list string)
        |> hardcoded ""
-- END : photoDecoder

-- START : fetchFeed
fetchFeed : Cmd Msg
fetchFeed =
    Http.get
        { url = baseUrl ++ "feed/1"
        , expect = Http.expectJson LoadFeed photoDecoder
        }
-- END : fetchFeed

-- START : Model
type alias Id =
    Int

type alias Photo =
    { id : Id
    , url : String
    , caption : String
    , liked : Bool
    , comments : List String
    , newComment : String
    }

type alias Model =
    { photo : Maybe Photo
    }

initialModel : Model
initialModel =
   { photo = Nothing}

-- END : Model

-- START : init
init : () -> ( Model, Cmd Msg)
init () =
    ( initialModel, fetchFeed )
-- END : init

-- START : View Like Button
viewLikeButton : Photo -> Html Msg
viewLikeButton photo =
    let
        buttonClass = 
            if photo.liked then
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

viewComments : Photo -> Html Msg
viewComments photo =
    div []
        [ viewCommentList photo.comments
        , form [ class "new-comment", onSubmit SaveNewComment ]
            [ input
                [ type_ "text"
                , placeholder "Add your comment"
                , value photo.newComment
                , onInput UpdateComment
                ]
                []
            , button [ disabled (String.isEmpty photo.newComment) ] [ text "Save" ]
            ]
        ]
-- END : View Comment

-- START : View
viewDetailedPhoto : Photo -> Html Msg
viewDetailedPhoto photo =
    div [ class "detailed-photo" ]
        [ img [ src photo.url ] []
        , div [ class "photo-info" ]
            [ viewLikeButton photo
            , h2 [ class "caption" ] [ text photo.caption ]
            , viewComments photo
            ]
        ]

viewFeed : Maybe Photo -> Html Msg
viewFeed maybePhoto =
    case maybePhoto of
        Just photo ->
            viewDetailedPhoto photo
        Nothing ->
            div [ class "loading-feed" ]
                [ text "Loading Feed ..." ]

view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare"] ]
        , div [ class "content-flow" ]
            [ viewFeed model.photo ]
        ]
-- END : View

-- START : Save new comment
saveNewComment : Photo -> Photo
saveNewComment photo =
    let
        comment = String.trim photo.newComment
    in
    case comment of
        "" ->
            photo
        _ ->
            { photo | comments = photo.comments ++ [ comment ]
            , newComment = ""
            }
-- End : Save new comment

-- START : Update
type Msg
    = ToggleLike
    | UpdateComment String
    | SaveNewComment
    | LoadFeed (Result Http.Error Photo)

toggleLike : Photo -> Photo
toggleLike photo =
    { photo | liked = not photo.liked }

updateComment : String -> Photo -> Photo
updateComment comment photo =
    { photo | newComment = comment }

updateFeed : (Photo -> Photo) -> Maybe Photo -> Maybe Photo
updateFeed updatePhoto maybePhoto =
    case maybePhoto of
        Just photo ->
            Just (updatePhoto photo)
        Nothing ->
            Nothing

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleLike ->
            ( { model
                | photo = updateFeed toggleLike model.photo
              }
            , Cmd.none
            )
        UpdateComment comment ->
            ( { model
                | photo = updateFeed (updateComment comment) model.photo 
              }
            , Cmd.none
            )
        SaveNewComment ->
            ( { model
                | photo = updateFeed saveNewComment model.photo
              }
            , Cmd.none
            )
        LoadFeed (Ok photo) ->
            ( { model | photo = Just photo }
            , Cmd.none
            )
        LoadFeed (Err _) ->
            ( model, Cmd.none )
-- END : Update

-- START : subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
-- END : subscriptions

-- START : main
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
-- END : main
