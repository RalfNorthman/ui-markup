module Text exposing (compile)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Mark
import Mark.Error
import Palette
import Source
import Titles


type alias FontConfig msg =
    { normal : Attribute msg
    , fat : Attribute msg
    , smallCaps : Maybe (Attribute msg)
    , nonSC : Attribute msg
    }



---- Extras ----


zeroPad =
    { left = 0, right = 0, top = 0, bottom = 0 }



---- Fonts ----


chronicleDeckCondensed =
    Font.family
        [ Font.typeface "Chronicle DeckCond A"
        , Font.sansSerif
        ]


chronicleDeckCondConfig =
    { normal = Font.regular
    , fat = Font.bold
    , smallCaps = Nothing
    , nonSC = chronicleDeckCondensed
    }


requiemDisplay =
    Font.family
        [ Font.typeface "Requiem Display A"
        , Font.serif
        ]


requiemDisplayConfig =
    { normal = Font.regular
    , fat = Font.regular
    , smallCaps = Nothing
    , nonSC = requiemDisplay
    }


requiemText =
    Font.family
        [ Font.typeface "Requiem Text A"
        , Font.serif
        ]


requiemTextConfig =
    { normal = Font.regular
    , fat = Font.regular
    , smallCaps = Nothing
    , nonSC = requiemText
    }


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



---- Innermost text functions ----


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

                    Just smallCapFont ->
                        smallCapFont

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


compile titleSize baseSize sourceArg =
    let
        ---- Colors ----
        backgroundColor =
            Palette.darkBackground

        creditsColor =
            Palette.lightOldGold

        headerColor =
            Palette.lightText

        mainTextColor =
            Palette.lightText

        subHeaderColor =
            Palette.lightText

        lessonColor =
            Palette.lightOldGold

        ---- Scale ----
        base =
            -- 32
            baseSize

        scaleFloat =
            modular base 1.618

        smallFloat =
            scaleFloat -1

        scaleInt =
            scaleFloat
                >> round

        xxxxs =
            scaleInt -5

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

        ---- Styles ----
        creditsStyle =
            [ Font.color creditsColor
            , Font.size <| 2 * small
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
                    , bottom = xxs
                }
            , Font.size large
            ]

        lessonStyle =
            [ Font.color lessonColor
            , myWidth
            , centerX
            , paddingEach { zeroPad | bottom = xxs }
            ]

        ---- Blocks ----
        header =
            Mark.block "Header"
                (\children ->
                    el [] <| paragraph headerStyle children
                )
                (myText requiemDisplayConfig)

        subHeader =
            Mark.block "SubHeader"
                (\children ->
                    el [] <| paragraph subHeaderStyle children
                )
                (myText requiemTextConfig)

        lesson =
            Mark.block "Lesson"
                (\children ->
                    el [] <|
                        column lessonStyle
                            [ el
                                [ chronicleSC
                                , Font.light
                                , paddingEach { zeroPad | bottom = xxxs }
                                ]
                              <|
                                text "Lärdomar:"
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
                (myText chronicleDeckCondConfig)

        ---- Width ----
        widthInChars =
            65

        myWidth =
            width <| px <| widthInChars * xs

        myCustomWidth y =
            width <| px <| (widthInChars - y) * xs

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
                                    [ paddingEach { zeroPad | bottom = small }
                                    , spacing xxs
                                    , myWidth
                                    , centerX
                                    ]
                                    x
                        )
                        myTextChronicle
                    ]
                )

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
                [ paddingEach { zeroPad | bottom = small }
                ]
            <|
                textColumn [ myWidth, centerX ]
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
                , column []
                    [ textColumn [ myCustomWidth 5 ] item.content
                    , renderSubList item.children
                    ]
                ]

        myLayout element =
            layout
                [ Font.variant Font.ligatures
                , Font.size (small + xxxs + xxxxs)
                , Font.color mainTextColor
                , Font.alignLeft
                , Background.color backgroundColor
                , padding large
                , width fill
                , clipX
                ]
            <|
                column [ centerX ] [ element ]

        viewErrors errors =
            List.map (Mark.Error.toHtml Mark.Error.Dark)
                errors
    in
    case Mark.compile document sourceArg of
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
