module Main exposing (main)

import Debug
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Mark
import Mark.Error
import Source



---- Colors, descriptive


palePaper =
    rgb255 255 252 235


moss =
    rgb255 105 118 85


darkMoss =
    rgb255 85 98 65


oldGold =
    rgb255 160 145 76


darkOldGold =
    rgb255 140 125 56


darkBrown =
    rgb255 106 91 84



---- Colors, layout elements


backgroundColor =
    palePaper


titleColor =
    darkMoss


creditsColor =
    darkOldGold


headerColor =
    darkBrown


mainTextColor =
    darkBrown


subHeaderColor =
    moss


lessonColor =
    oldGold



---- Scale ----


scaleFloat =
    modular 32 1.618


smallFloat =
    scaleFloat -1


scaleInt =
    scaleFloat
        >> round


xxxs =
    scaleInt -4


xxs =
    scaleInt -3


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


zeroPad =
    { left = 0, right = 0, top = 0, bottom = 0 }



---- Fonts ----


chronicle =
    Font.family
        [ Font.typeface "Chronicle SSm A"
        , Font.sansSerif
        ]


chronicleSC =
    Font.family
        [ Font.typeface "Chronicle SSm SC A"
        , Font.sansSerif
        ]


chronicleConfig =
    { normal = Font.light
    , fat = Font.medium
    , smallCaps = Just chronicleSC
    , nonSC = chronicle
    }


chronicleDisplayCondensed =
    Font.family
        [ Font.typeface "Chronicle Cond A"
        , Font.sansSerif
        ]


chronicleDisplayCondensedConfig =
    { normal = Font.light
    , fat = Font.semiBold
    , smallCaps = Nothing
    , nonSC = chronicleDisplayCondensed
    }


requiemDisplay =
    Font.family
        [ Font.typeface "Requiem Display A"
        , Font.serif
        ]


requiemConfig =
    { normal = Font.regular
    , fat = Font.regular
    , smallCaps = Nothing
    , nonSC = requiemDisplay
    }


knockout70 =
    Font.family
        [ Font.typeface "Knockout 70 A"
        , Font.sansSerif
        ]


knockout68 =
    Font.family
        [ Font.typeface "Knockout 68 A"
        , Font.sansSerif
        ]



---- Styles ----


creditsStyle =
    [ Font.color creditsColor
    , Font.size large
    , Font.center
    , width fill
    , spacing xs
    , paddingEach
        { zeroPad
            | bottom = xs
        }
    ]


headerStyle =
    [ myWidth
    , Font.color headerColor
    , centerX
    , Font.size xl
    , paddingEach
        { zeroPad
            | top = 2 * xl
        }
    ]


subHeaderStyle =
    [ Font.color subHeaderColor
    , myWidth
    , centerX
    , paddingEach
        { zeroPad
            | top = large
        }
    , Font.size large
    ]


lessonStyle =
    [ Font.color lessonColor
    , myWidth
    , centerX
    , paddingEach { zeroPad | bottom = xxs }
    ]


widthInChars =
    65


myWidth =
    width <| px <| widthInChars * xs



---- Document ----


document : Mark.Document (Element msg)
document =
    Mark.document
        (\stuff ->
            textColumn
                [ centerX
                , width fill
                ]
                stuff
        )
        (Mark.manyOf
            [ subHeader
            , header
            , list
            , lesson
            , lessonMore
            , credits
            , Mark.map
                (\x ->
                    el [] <|
                        paragraph
                            [ paddingEach { zeroPad | bottom = xxs }
                            , myWidth
                            , centerX
                            ]
                            x
                )
                myTextChronicle
            ]
        )



---- Blocks ----


header =
    Mark.block "Header"
        (\children ->
            el [] <| paragraph headerStyle children
        )
        (myText requiemConfig)


subHeader =
    Mark.block "SubHeader"
        (\children ->
            el [] <| paragraph subHeaderStyle children
        )
        (myText requiemConfig)


lesson =
    Mark.block "Lesson"
        (\children ->
            el [] <|
                column lessonStyle
                    [ el [ chronicleSC ] <| text "Lärdomar:"
                    , paragraph [] (text "\u{2003}" :: children)
                    ]
        )
        myTextChronicle


lessonMore =
    Mark.block "LessonMore"
        (\children ->
            el [] <| paragraph lessonStyle (text "\u{2003}" :: children)
        )
        myTextChronicle


credits =
    Mark.block "Credits"
        (\children ->
            el [] <| paragraph creditsStyle children
        )
        (myText chronicleDisplayCondensedConfig)



---- Innermost text functions ----


type alias FontConfig msg =
    { normal : Attribute msg
    , fat : Attribute msg
    , smallCaps : Maybe (Attribute msg)
    , nonSC : Attribute msg
    }


myText : FontConfig msg -> Mark.Block (List (Element msg))
myText fontConfig =
    Mark.textWith
        { view = renderStyles fontConfig
        , replacements = myReplacements
        , inlines = []
        }


myTextChronicle =
    myText chronicleConfig


renderStyles fontConfig styles str =
    let
        italicOrNo =
            if styles.italic then
                [ Font.italic ]

            else
                []

        weight =
            if styles.bold then
                fontConfig.fat

            else
                fontConfig.normal

        smallCapsOrNo =
            if styles.strike then
                case fontConfig.smallCaps of
                    Nothing ->
                        fontConfig.nonSC

                    Just sc ->
                        sc

            else
                fontConfig.nonSC

        attrs =
            [ weight, smallCapsOrNo ] ++ italicOrNo
    in
    el attrs <| text str


myReplacements : List Mark.Replacement
myReplacements =
    [ Mark.replacement "..." "…"

    -- normal hyphen
    , Mark.replacement "//-" "-"

    -- em dash
    , Mark.replacement "---" "—"

    -- en dash
    , Mark.replacement "--" "–"
    , Mark.replacement "//" "/"
    , Mark.replacement "/[" "["
    , Mark.replacement " /]" "]"
    , Mark.replacement "'" "’"
    , Mark.replacement "***" "*"

    -- multiplication sign
    , Mark.replacement "**" "×"

    -- swedish quotation
    , Mark.replacement "\"" "”"

    -- non-breaking space
    , Mark.replacement "<>" "\u{00A0}"

    -- em space
    , Mark.replacement "___" "\u{2003}"

    -- non-breaking thin space
    , Mark.replacement "_" "\u{202F}"

    -- soft hyphen
    , Mark.replacement "-" "\u{00AD}"
    ]



---- Tree ----


list =
    Mark.tree "List"
        renderList
        (Mark.map
            (\x -> paragraph [] x)
            myTextChronicle
        )


renderList (Mark.Enumerated enum) =
    el
        [ paddingEach { zeroPad | bottom = xs }
        ]
    <|
        column [ myWidth, centerX ]
            (List.map (renderItem enum.icon) enum.items)


renderSubList (Mark.Enumerated enum) =
    column []
        (List.map (renderItem enum.icon) enum.items)


renderItem icon (Mark.Item item) =
    let
        ( index, _ ) =
            item.index

        viewBullet =
            el [ alignTop ] <| text "\u{2003}• "

        viewNumber nr =
            el [ alignTop ] <| text ("\u{2003}" ++ String.fromInt (nr + 1) ++ ". ")
    in
    row
        [ paddingXY 0 xxxs
        ]
        [ case icon of
            Mark.Bullet ->
                viewBullet

            Mark.Number ->
                viewNumber index
        , column [ width fill ]
            [ textColumn [] item.content
            , renderSubList item.children
            ]
        ]



---- Main ----


viewErrors errors =
    List.map (Mark.Error.toHtml Mark.Error.Light)
        errors


main =
    let
        titleAttrs font size =
            [ Font.size size
            , Font.color titleColor
            , Font.center
            , font
            , width shrink
            ]

        -- Title looks good when the proportions are
        -- width 715 px
        -- knockout68 fontsize 134 px (135 for easier division)
        -- knockout70 fontsize 144 px (145 for easier division)
        -- spacing -32 px (-30 for easier division)
        -- 143 - 27 - 29 - 6
        altTitle x =
            textColumn
                [ centerX
                , spacing (-6 * x)
                , width <| px (143 * x)
                ]
                [ el (titleAttrs knockout68 (27 * x)) <|
                    text "ORMKONUNGARNAS"
                , el (titleAttrs knockout70 (29 * x)) <|
                    text "KATAKOMBER"
                ]

        sizes =
            List.range 5 15 |> List.reverse

        titleList =
            List.map altTitle sizes

        myLayout element =
            layout
                [ Font.variant Font.ligatures
                , Font.size (medium - 6)
                , Font.color mainTextColor
                , Font.alignLeft
                , Background.color backgroundColor
                , padding large
                , width fill
                ]
            <|
                column [ centerX ] <|
                    titleList
                        ++ [ element ]
    in
    case Mark.compile document Source.source of
        Mark.Success element ->
            myLayout element

        Mark.Almost { result, errors } ->
            myLayout <|
                column []
                    [ column [] (List.map html (viewErrors errors))
                    , result
                    ]

        Mark.Failure errors ->
            Html.div [] (viewErrors errors)
