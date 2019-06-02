module Main exposing (main)

import Debug
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Mark
import Mark.Error



---- Fonts ----


googleFont : String -> String -> Attribute msg
googleFont fontName weight =
    let
        fontString =
            String.replace " " "+" fontName
    in
    Font.family
        [ Font.external
            { url =
                "https://fonts.googleapis.com/css?family="
                    ++ fontString
                    ++ ":"
                    ++ weight
            , name = fontName
            }
        ]


bookType =
    googleFont "Cormorant" "400i,400,700,700i"


smallCaps =
    googleFont "Cormorant SC" "400"



---- Scale ----


scaleFloat =
    modular 36 1.618


smallFloat =
    scaleFloat -1


scaleInt =
    scaleFloat
        >> round


xs =
    scaleInt -2


small =
    scaleInt -1


medium =
    scaleInt 1


large =
    scaleInt 2


xl =
    scaleInt 3


xxl =
    scaleInt 4



---- Extras ----


grey x =
    rgb x x x


zeroPad =
    { left = 0, right = 0, top = 0, bottom = 0 }



---- Styles ----


titleStyle =
    [ Font.bold
    , Font.size large
    , Font.letterSpacing smallFloat
    ]


italics =
    [ Font.italic ]



---- Document ----


document : Mark.Document (Html msg)
document =
    Mark.document
        (\stuff ->
            layout
                [ bookType
                , Font.size medium
                , Font.alignLeft
                , padding medium
                ]
            <|
                textColumn [] stuff
        )
        (Mark.manyOf
            [ header
            , Mark.map (paragraph []) myText
            ]
        )



---- Blocks ----


header =
    Mark.block "Header"
        (\children ->
            paragraph titleStyle children
        )
        myText


myText : Mark.Block (List (Element msg))
myText =
    let
        ifStyle : Attribute msg -> Bool -> List (Attribute msg)
        ifStyle attr bool =
            if bool then
                [ attr ]

            else
                []
    in
    Mark.textWith
        { view =
            \styles str ->
                el
                    (ifStyle Font.bold styles.bold
                        ++ ifStyle Font.italic styles.italic
                        ++ ifStyle smallCaps styles.strike
                    )
                <|
                    text str
        , replacements = Mark.commonReplacements
        , inlines = []
        }



---- Main ----


viewErrors errors =
    List.map (Mark.Error.toHtml Mark.Error.Light)
        errors


main : Html msg
main =
    case Mark.compile document source of
        Mark.Success html ->
            html

        Mark.Almost { result, errors } ->
            Html.div []
                [ Html.div [] (viewErrors errors)
                , Html.div [] [ result ]
                ]

        Mark.Failure errors ->
            Html.div [] (viewErrors errors)



---- Source ----


source : String
source =
    String.trim
        """
    |> Header
    KÖTTFÄRSÅS

    Vad *är* ~Köttfärssås~ /egentligen/?
    Man hade länge tvivlat på -- men också bävat inför -- möjligheten att detta var sant. De kallade honom för "Tratten", men det gillade han inte.
"""
