module Titles exposing (list)

import Element exposing (..)
import Element.Font as Font
import Palette



---- Color ----


titleColor =
    Palette.darkMoss



---- Fonts ----


knockout68 =
    Font.family
        [ Font.typeface "Knockout 68 A"
        , Font.sansSerif
        ]


knockout70 =
    Font.family
        [ Font.typeface "Knockout 70 A"
        , Font.sansSerif
        ]



---- Title ----


titleAttrs : Attribute msg -> Int -> Color -> List (Attribute msg)
titleAttrs font size color =
    [ Font.size size
    , Font.color color
    , Font.center
    , font
    , width shrink
    ]


altTitle : Int -> Color -> Element msg
altTitle size color =
    -- Title looks good when the proportions are
    -- width 715 px
    -- knockout68 fontsize 134 px (135 for easier division)
    -- knockout70 fontsize 144 px (145 for easier division)
    -- spacing -32 px (-30 for easier division)
    -- 143 - 27 - 29 - 6
    textColumn
        [ centerX
        , spacing (-6 * size)
        , width <| px (143 * size)
        ]
        [ el (titleAttrs knockout68 (27 * size) color) <|
            text "ORMKONUNGARNAS"
        , el (titleAttrs knockout70 (29 * size) color) <|
            text "KATAKOMBER"
        ]


sizes : List Int
sizes =
    List.range 5 15 |> List.reverse


list : List (Element msg)
list =
    List.map2 altTitle sizes Palette.gradient
