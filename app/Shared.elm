port module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import DataSource
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Events exposing (onClick)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)


port updateLoginStatus : (String -> msg) -> Sub msg


port signIn : () -> Cmd msg


port signOut : () -> Cmd msg


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Nothing
    }


type Msg
    = SharedMsg SharedMsg
    | MenuClicked
    | UpdateLoginStatus String
    | SignIn
    | SignOut


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMenu : Bool
    , isLogin : Bool
    }


init :
    Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Effect Msg )
init flags maybePagePath =
    ( { showMenu = False, isLogin = False }
    , Effect.none
    )


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SharedMsg globalMsg ->
            ( model, Effect.none )

        MenuClicked ->
            ( { model | showMenu = not model.showMenu }, Effect.none )

        UpdateLoginStatus status ->
            ( { model | isLogin = status == "signIn" }, Effect.none )

        SignIn ->
            ( model, Effect.Cmd <| signIn () )

        SignOut ->
            ( model, Effect.Cmd <| signOut () )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    updateLoginStatus UpdateLoginStatus


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : List (Html msg), title : String }
view sharedData page model toMsg pageView =
    { body =
        [ Route.Index
            |> Route.link [] [ Html.text "Top" ]
        , Html.div []
            [ if model.isLogin then
                Html.div []
                    [ Html.button [ onClick <| toMsg SignOut ] [ Html.text "SignOut" ]
                    ]

              else
                Html.button [ onClick <| toMsg SignIn ] [ Html.text "SignIn" ]
            ]
        , Html.main_ [] pageView.body
        ]
    , title = pageView.title
    }
