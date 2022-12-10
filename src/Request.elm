module Request exposing (..)

import DataSource exposing (DataSource)
import DataSource.Http
import Json.Decode as JD exposing (Decoder)


microCMStoken =
    "トークンを入れたら動く"


getBlogListRequest : DataSource (List Blog)
getBlogListRequest =
    DataSource.Http.request
        { url = "https://ababupdownba.microcms.io/api/v1/blogs"
        , method = "GET"
        , headers =
            [ ( "X-MICROCMS-API-KEY", microCMStoken )
            ]
        , body = DataSource.Http.emptyBody
        }
        (DataSource.Http.expectJson blogListDecoder)


getBlogRequest : String -> DataSource Blog
getBlogRequest slug =
    DataSource.Http.request
        { url = "https://ababupdownba.microcms.io/api/v1/blogs/" ++ slug
        , method = "GET"
        , headers =
            [ ( "X-MICROCMS-API-KEY", microCMStoken )
            ]
        , body = DataSource.Http.emptyBody
        }
        (DataSource.Http.expectJson blogDecoder)


type alias Blog =
    { id : String
    , title : String
    , description : String
    , content : String
    }


blogListDecoder : Decoder (List Blog)
blogListDecoder =
    JD.field "contents" <|
        JD.list blogDecoder


blogDecoder : Decoder Blog
blogDecoder =
    JD.map4 Blog
        (JD.field "id" JD.string)
        (JD.field "title" JD.string)
        (JD.field "description" JD.string)
        (JD.field "content" JD.string)
