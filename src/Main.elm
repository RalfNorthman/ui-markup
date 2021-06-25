module Main exposing (main)

import Browser
import Browser.Dom as Dom
import Browser.Events
import Html
import Html.Lazy
import Source
import Task
import Text


initialScreenSize =
    Task.perform ScreenSize Dom.getViewport


type alias Model =
    Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( 0, initialScreenSize )


emptyViewport =
    Dom.Viewport { width = 0, height = 0 }
        { x = 0, y = 0, width = 0, height = 0 }


type Msg
    = Resize Int Int
    | ScreenSize Dom.Viewport


calculateSize width =
    let
        cutoff =
            920

        step =
            cutoff // 4
    in
    if width > cutoff + step then
        6

    else if width > cutoff then
        5

    else if width > cutoff - step then
        4

    else if width > cutoff - 2 * step then
        3

    else if width > cutoff - 3 * step then
        2

    else
        1


update msg model =
    case msg of
        Resize width _ ->
            ( calculateSize width, Cmd.none )

        ScreenSize record ->
            ( calculateSize (round record.viewport.width), Cmd.none )


view model =
    if model == 0 then
        Html.div [] []

    else
        Html.div []
            (List.map
                (\x ->
                    Html.Lazy.lazy3
                        Text.compile
                        model
                        (toFloat model * 5.8)
                        x
                )
                [ Source.source
                |> String.replace "\u{000D}\n" "\n" 
                ]
            )


subscriptions _ =
    Browser.Events.onResize Resize


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
