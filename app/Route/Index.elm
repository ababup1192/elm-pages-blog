module Route.Index exposing (ActionData, Data, Model, Msg, route)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html
import Pages.Msg
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Request exposing (Blog, getBlogListRequest)
import Route
import RouteBuilder exposing (StatelessRoute, StaticPayload)
import Shared
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    { blogList : List Blog
    }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.succeed Data
        |> DataSource.andMap
            getBlogListRequest


head :
    StaticPayload Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = [ "images", "icon-png.png" ] |> Path.join |> Pages.Url.fromPath
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Welcome to elm-pages!"
        , locale = Nothing
        , title = "elm-pages is running"
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data ActionData RouteParams
    -> View (Pages.Msg.Msg Msg)
view maybeUrl sharedModel app =
    { title = "elm-pages is running"
    , body =
        [ Html.h1 [] [ Html.text "Sample Blog System!" ]
        , Html.ul [] <|
            List.map
                (\blog ->
                    Html.li []
                        [ Route.Blog__Slug_ { slug = blog.id }
                            |> Route.link [] [ Html.text blog.title ]
                        ]
                )
                app.data.blogList
        ]
    }
