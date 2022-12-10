module Route.Blog.Slug_ exposing (ActionData, Data, Model, Msg, route)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html
import Html.Attributes
import Html.Parser
import Html.Parser.Util
import Pages.Msg
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Request exposing (getBlogListRequest, getBlogRequest)
import RouteBuilder exposing (StatelessRoute, StaticPayload)
import Shared
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { slug : String }


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


pages : DataSource (List RouteParams)
pages =
    DataSource.map
        (\blogList ->
            List.map
                (\blog ->
                    { slug = blog.id }
                )
                blogList
        )
        getBlogListRequest


type alias Data =
    { description : String
    , content : String
    }


type alias ActionData =
    {}


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\blog ->
            { description = blog.description
            , content = blog.content
            }
        )
        (getBlogRequest routeParams.slug)


head :
    StaticPayload Data ActionData RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data ActionData RouteParams
    -> View (Pages.Msg.Msg Msg)
view maybeUrl sharedModel static =
    { title = "Placeholder - Blog.Slug_"
    , body =
        [ if not sharedModel.isLogin then
            Html.div []
                [ Html.p [] [ Html.text static.data.description ]
                , Html.p [] [ Html.text "こちらの続きは、ログイン後に見ることができます。" ]
                ]

          else
            Html.div [ Html.Attributes.class "blog" ] <|
                case Html.Parser.run static.data.content of
                    Ok nodes ->
                        Html.Parser.Util.toVirtualDom nodes

                    Err _ ->
                        [ Html.p [] [ Html.text "読み込みエラー" ] ]
        ]
    }
