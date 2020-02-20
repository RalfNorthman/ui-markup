module Palette exposing (..)

import Color
import Color.Gradient as Gradient exposing (Gradient)
import Color.Interpolate as Interpolate
import Element



---- Colors ----


palePaper =
    Element.rgb255 255 252 235


darkMoss =
    Element.rgb255 85 98 65


moss =
    Element.rgb255 105 118 85


lightOldGold =
    Element.rgb255 170 155 86


oldGold =
    Element.rgb255 160 145 76


darkOldGold =
    Element.rgb255 140 125 56


darkBrown =
    Element.rgb255 106 91 84



---- Ironsworn ----


darkBackground =
    Element.rgb255 0 0 0


lightText =
    Element.rgb255 200 200 200



---- Convert ----


convertIn : Element.Color -> Color.Color
convertIn color =
    color
        |> Element.toRgb
        |> Color.fromRgba


convertOut : Color.Color -> Element.Color
convertOut color =
    color
        |> Color.toRgba
        |> Element.fromRgb



---- Gradient ----


gradient : List Element.Color
gradient =
    let
        palette =
            List.map convertIn
                [ palePaper, darkMoss ]
    in
    case
        Gradient.linearGradient Interpolate.RGB palette 12
    of
        _ :: rest ->
            List.map convertOut rest

        _ ->
            []
