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
    googleFont "Cormorant SC" "400, 700"



---- Scale ----


scaleFloat =
    modular 32 1.618


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
    , Font.size xxl
    , paddingEach { zeroPad | bottom = medium }
    , Font.letterSpacing <| -(scaleFloat -4)
    ]


headerStyle =
    [ Font.bold
    , Font.size xl
    , paddingEach { zeroPad | bottom = small }
    , Font.letterSpacing <| -(scaleFloat -5)
    ]


subHeaderStyle =
    [ Font.bold
    , Font.size large
    ]


subHeaderStyleAlt =
    [ Font.bold
    , Font.size large
    , Font.letterSpacing smallFloat
    ]



---- Document ----


document : Mark.Document (Html msg)
document =
    Mark.document
        (\stuff ->
            layout
                [ bookType
                , Font.size medium
                , Font.alignLeft
                , padding large
                ]
            <|
                textColumn [ centerX ] stuff
        )
        (Mark.manyOf
            [ subHeader
            , header
            , title
            , list
            , Mark.map
                (paragraph
                    [ paddingEach { zeroPad | bottom = small } ]
                )
                myText
            ]
        )



---- Blocks ----


title =
    Mark.block "Title"
        (\children ->
            paragraph titleStyle children
        )
        myText


header =
    Mark.block "Header"
        (\children ->
            paragraph headerStyle children
        )
        myText


subHeader =
    Mark.block "SubHeader"
        (\children ->
            paragraph subHeaderStyle children
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



---- Tree ----


list =
    Mark.tree "List" renderList (Mark.map (paragraph []) myText)


renderList (Mark.Enumerated lst) =
    let
        group =
            case lst.icon of
                Mark.Bullet ->
                    \str -> el [] <| text ("* " ++ str)

                Mark.Number ->
                    \str -> el [] <| text ("1 " ++ str)
    in
    column [] (List.map renderItem lst.items)


renderItem (Mark.Item item) =
    column []
        [ column [] item.content
        , renderList item.children
        ]



---- Main ----


viewErrors errors =
    List.map (Mark.Error.toHtml Mark.Error.Light)
        errors


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


source2 : String
source2 =
    String.trim
        """
|> Title
    Spöklinjerna

|> Header
    Spelarnas drag

|> SubHeader
    KRAFT

    /När du brukar kraft,/ slå+~kraft~ och välj bland alternativen. 
    På 12+, tre. På 10--11, två. På 7--9, ett.

|> SubHeader
    FINESS

    /När du använder finess,/ slå+~finess~ och välj bland alternativen.
    På 12+, tre. På 10--11, två. På 7--9, ett.

    Nästa stycke.
"""


source : String
source =
    String.trim
        """
|> Title
    Ormkonungarnas Katakomber

|> Header
    Introduktion

    När du först startar Super Mario Bros så ger inte spelet dig några instruktioner. Första banan är designad för att ge dig reglerna: hoppa ovanpå fienderna, plocka upp svampar, ta mynt, undvik avgrunder. Det finns ingen handledning. Spelet själv är en handledning. 

    Alla kan namnge ett klassiskt grottkomplex – Tomb of Horrors, Barrier Peaks, Ravenloft – men för att dessa moduler ska vara förståeliga behöver det finnas en slags introduktion. Tomb of Horrors och Death Frost Doom är båda reaktioner /på någonting/, men vad de är reaktioner /på/ finns inte riktigt som utgiven produkt.

    Det är som om alla moduler vi har är Bach-konserter. Folk skriver verk vilka besitter häpnadsväckande genialitet, men någon måste skriva en bok om hur man spelar piano.

|> Header
    Den här modulen är för:

|> List
    -- Erfarna ~sl~ med nya spelare.
    -- ~Sl~ som vill lära sig om design av dungar.
    -- Erfarna ~sl~ med erfarna spelare, men vilka är nykomlingar till ~osr~-innehåll.

    Som en helt ny ~sl~ kan du ändå använda den här grottkomplexet och lära dig mycket från den, men den kommer omedelbart pröva dina färdigheter. Modulen kan även uppskattas av erfarna spelare.

|> Header
    Jag håller inte med om…

    Chansen är stor att erfarna ~sl~ inte kommer hålla med om vissa lektioner, fällor eller möten i den här grottkomplexet. Det är helt okej! Det här är inte menat att vara en manual  över /det rätta sättet/ att köra en nybörjargrotta. Det är bara /ett/ sätt att göra det.

    Om du tycker att diplomati är ett nödvändigt element, placera en hjälpsam, men feg vätte som heter Smä i *7: Falskt tempel*. Om du tycker att tidspress och en känsla av hotande fara är viktigt, lägg till Strövande Väsen till alla nivåer i grottkomplexet, inte bara Nivå 3. Lägg till troper från folksägner. Lägg till dina favoritfällor eller ta bort fällorna helt och hållet.

    Genom att inte hålla med så lär du dig i alla fall något om dina egna preferenser. Det är värdefull kunkap. Att lära sig vad man inte gillar är lika värdefullt som som att lära sig vad man gillar. Kanske kan den här modulen inspirera dig att skriva din egen introduktionsgrotta.

|> Header
    Gruppstorlek och balans

    Den här grottkomplexet är designat för nivå 1 rollpersoner. Jag har försökt att göra den här modulen så systemneutral som möjligt. Du kan köra grottkomplexet med en rollperson eller tio. Mötena är inte balanserade. De har inte svårighetsnivåer. Det finns väldigt få belöningar för strid och många för att genomföra en god plan.

    Värdet på skatterna är balanserade runt tanken att 200 guldmynt är tillräckligt för att en rollperson ska kunna gå upp en nivå. I slutet bör överlevande rollpersoner vara nivå 2 eller 3, om vi antar vanliga nivåer av utnötning, förluster och panik. Justera värdet på skatterna därefter. Stora grupper kommer ha det lättare (och få mindre skatter per rollperson). En ensam rollperson som överlever kommer vara rik.

    Skadeangivelserna är skalade efter rollpersoner som har 4 till 16 kroppspoäng och dolkar som ger 1T6 i skada. Räddningskast är angivna i ett generellt format (Räddningskast mot Gift, Räddningskast för att Ducka, etc).

    En grupp rollpersoner på mellannivå spelade av erfarna spelare kan tillintetgöra den här grottkomplexet på rekordtid. De kan ändå ha kul. En grupp rollpersoner på låg nivå spelade av nybörjarspelare kommer förhoppningsvis ha jätteroligt.

    Beroende på spelstil, sidoäventyr, avbrott och andra distraktioner, kan det ta mellan 12 och 24 timmar speltid att fullständigt utforska grottkomplexet. På ett första spelmöte som involverar rollpersonsskapande bör sällskapet kunna utforska Nivå 1 helt.

|> Header
    Innan du börjar:

    Läs hela modulen.
    Gör anteckningar över saker du gillar och inte gillar.
    Skriv ut sida XXoch kartan på sida XX.
    Byt ut monstren på sida XX till motsvarande från ditt val av system.
    Justera skatternas värde där det behövs.

|> Header
    Locka rollpersonerna

    Här är några sätt att locka rollpersonerna till grottkomplexet, givet att de startar panka och vet att katakomber innehåller skatter. Du kan placera den här grottkomplexet var som helst.
    De hittar en uråldrig karta till ett länge sedan bortglömt gravvalv.
    Ett jordskred avslöjar ingången till graven.
    Vättarna kidnappar någon som står rollpersonerna nära.
    Xiximanters experiment framkallar märkliga drömmar.
    De hittar ingången till graven av ren slump.
    De är utsända av en mäktig mecenat att utforska de nyligen funna katakomberna.
    
|> Header
    Lärdomar

    Alltigenom texten finns små rutor utspridda. Varje rum, fälla eller möte är designat för att lära nya spelare (och spelledare) en användbar läxa. Några är allmäna lärdomar, medan andra är specifika för den här grottkomplexet. Grottkomplexets struktur, beskaffenhet och faror bör sakta bli förutsägbara och möjliga att utnyttja. Dessa lärdomar kan te sig triviala för en erfaren spelledare, men jag tycker det är lämpligt att räkna upp dem ändå.

|> Header
    Struktur

    Ormkonungarnas Katakomber är ett grottkomplex med 3 nivåer och 4 tematiska huvudområden. Jag har tagit med väldigt minimala beskrivningar i texten och sektionen med snabbreferenser (sid 16-17). Det finns inga texter som ska läsas högt.

|> SubHeader
    Nivå 1: Den Falska Kryptan

    Introducerar grunderna i utforming av grottkomplex och utforskning av 7 rum. Den är precis rätt storlek för ett första spelmöte, givet att skapandet av rollpersoner går hyfsat fort och att du ger rollpersonerna en god anledning till att utforska katakomben.

|> SubHeader
    Nivå 2: Den Övre Kryptan

    Fortfarande linjärt, men med fler förgrenande rum och några terrängrelaterade faror. Det finns fortfarande en klar väg “framåt,” men sidorummen är frestande. Det är i den här sektionen som lärdomarna från Nivå 1 sätts på prov och tillämpas. Den kan ta två eller tre spelmöten att utforska och det kan möjligen behövas en färd tillbaka till civilisationen för att fylla på förnödenheter.

|> SubHeader
    Nivå 3: De Lägre Kryptorna

    Det finns två horisontella och tre vertikala huvudleder. Grottkomplexet förgrenar sig och bildar öglor. Du kan nå ytan. Du kan gå djupare. Du kan hamna där du började. Den här nivån är betydligt farligare än de föregående. Diplomati och handel blir också aktuellt, liksom strövande väsen. Du kan utforska Nivå 1 och 2 i lugn och ro, men spenderar du för mycket tid på Nivå 3 tar du en allvarlig risk. Nivå 3 är öppen. Du kan lägga till material för att utöka grottkomplexet så långt du vill. I det här läget, om du är en ny spelledare eller ovan med ~osr~-spel, bör du vara redo att skriva ditt eget material.

|> Header
    Tematiska områden

|> SubHeader

    Den Falska Kryptan

    Representerar upptäckarlust, aha-upplevelsen och spänningen av att kunna hitta skatter. Kom ihåg att berömma spelare som listar ut att det är en falsk krypta. Klokskap ska belönas. Grottkomplexet blir också märkligare och mindre jordnära ju lägre ner man går. Till en början bryter ni upp träkistor för att roffa åt er pyttesmå amuletter. Nära slutet gräver ni er igenom svampvättarnas dynga efter kungakronor, bedriver handel med en död ormman eller släpar skattkistor med guld upp till ytan.

    Beskriv det här området med ord som skraltig, kantstött och fuktig. Det är en jordkällare. Det sticker ner små vita rötter från taket och det är grus på golvet.

|> SubHeader
    Den Riktiga Kryptan

    Representerar makt och osagda hot. Statyer hänger över er. Tingestar skälver i låsta kistor. Jätteödlor lurpassar på er i mörkret, odödliga trollkarlar köpslår med er och oövervinnerlig odöd sörja glider efter er.

    Beskriv det här området med ord som enorm och överhängande och kall. Det här området är byggt av en civilisation äldre, visare och grymmare än rollpersonernas. Ju djupare de går desto nervösare bör de bli.

|> SubHeader
    Avgrunden

    Representerar det okända och den förundran den medför. Det skulle kunna finnas vadsomhelst därnere. Den kan sträcka sig ner till jordens mitt. Det skulle fortfarande kunna finnas ormmän som lever obekymrade liv därnere. Det är ett blankt ark där spelledaren kan lägga till saker till modulen.

    Beskriv avgrunden med ord som bottenlös och oroande, det är som om världen bara faller bort och tysta, rastlösa ljud om ni är tålmodiga. Rollpersonerna bör inte vilja stanna någon längre tid i avgrundens närhet.

|> SubHeader
    Vättegyttret

    Representerar en spegel av rollpersonerna. De lever i smuts, de återuppstår och gör samma misstag. De är hungriga, dåraktiga, vidskepliga, mordiska och på något sätt sympatiska. Gyttret är ett intrång av livskraftig och högljudd barbarism in i en kall och utdöende civilisation.

    Beskriv gyttret med lukter och ljud. Det stinker. Ni kommer själva stinka om ni tillbringar någon tid här och Ormkonungarnas Katakomber har inga fria bad. Pyttesmå röda vätteögon glöder i mörkret. Klapprande tänder och skarpa knivar väntar i mörkret.
    """


blah =
    """
    Nivå 1
    1: Vestibul
    En lång korridor med 4 öppna rum, 2 på varje sida. Hallen slutar vid en stor, tillbommad dörr som leder till 6: Falsk Gravkammare.
    2: Vakternas gravar
    De här 2 små rummen är identiska till storlek och innehåll. Bägge rymmer en likkista av trä med en lerstaty föreställande en ormfolkskrigare inuti. Statyerna är ihåliga och varje innehåller en guldamulett värd 1 ~gm~, ett torkat ormskelett och ett moln av giftgas (T6 i skada, kan bara reducera en rollperson till 0 kp). 
    Lärdomar: grottkomplexet är organiserat. Det finns mönster. Det finns gömda skatter. Det finns också gömda faror.

    Rollpersonerna kommer förmodligen närma sig kista nummer 2 med mer försiktighet och få sin belöning (guld) utan faran (gift) genom att använda sina hjärnor (och en sten eller lång pinne).
    3: Den lärdes grav
    Snarlik 2: Vakternas gravar, men likkistan innehåller en lerstaty föreställande en av ormfolkets lärda. Dess skriftrullar har brytits ner till stoft. Statyn innehåller samma amulett, ormskelett och gift som de andra.
    4: Svartkonstnärens grav
    Snarlik 2: Vakternas gravar, men likkistan innehåller en lerstaty föreställande en av ormfolkets svartkonstnärer med en silverring på sig. Om rollpersonerna inte redan har lärt sig att de andra statyerna är ihåliga, kommer de alldeles säkert försöka lirka av ringen, bryta upp statyn och avslöja giftgasen och amuletten.

    Ringen är magisk, men det vilar också en förbannelse över den. Om den bärs på ett finger så blir fingernageln lång, kluven i tu och spetsiga som ett tvillingpar av huggtänder. Den kan användas som en förgiftad dolk, men varje morgon måste bäraren Räddningskast mot Gift eller ta T6 skada. Om bäraren tar 6 skada på samma gång från giftringen faller deras finger av och förvandlas till en orm.
    Lärdomar: gömda skatter kan vara magiska, användbara och ibland bära på förbannelser.
    5: Dörr/Hammarfälla
    En stor dörr, reglad med en tvärslå av sten som hänger på 2 järnfästen på vardera sida av dörrposterna. För att lyfta bommen krävs minst 3 rollpersoner (eller allihopa om sällskapet är mindre). När bommen lyfts från järnfästena aktiveras en fälla. En väldig stenhammare svingar ner från taket, med sikte rakt på de nu fångade rollpersonernas ryggar. Den fyller närapå korridorens bredd, men det finns en liten glipa på vardera sida. Rollpersonerna kan:
    Slå Räddningskast för att Ducka eller
    Använda en annan rollperson som språngbräda och få +2 på sitt kast men ge den knuffade rollpersonen -2 på sitt.
    En träffad rollperson dör (eller tar allvarlig skada, typ 2T6+4).

    Fällan kan identifieras genom att granska dörren eller fästena, genom att upptäcka att fästena höjs när bommen lyfts eller genom att undersöka taket. Om bommen snabbt byts ut, fästena hålls ner eller om fällans mekanism i taket är skadad så kommer inte fällan lösa ut.
    Lärdomar: det finns dödliga fällor. Grottkomplexet kan vara livsfarlig.
    Hammaren dras långsamt tillbaka upp i taket såvida den inte blockeras. Den kan återaktiveras genom att lyfta upp järnfästena, antingen för hand eller med rep. När den aktiveras första gången slås den stora dörren som leder in till 6: Falsk kungagrav upp av kollsionen.
    6: Falsk kungagrav
    Gravkammare tillhörande ormfolkets kung och hans två gemåler. Längs norra väggen står 3 kistor av trä, den i mitten uppenbarligen större och mer utsmyckad. Inuti finns 3 Skelett (Nivå 2, Moral 12, Attack 1T6 [klor]) vilka kommer anfalla omedelbart om deras vila blir störd.
    Lärdomar: det finns odöda i grottkomplexet. De tar lägre skada från huggvapen. Rollpersonerna kan använda omgivningen mot dem (lura in dem i hammarfällan).

    7: Falskt tempel
    Det här rummet domineras av en enorm staty föreställande en ohygglig ormfolksgud. Vatten som läcker in i kryptan har vittrat sönder golvet vilket blottar en hemlig gång under statyn som leder till nivå 2.
    Lärdomar: det finns hemliga gångar. De är associerade med statyer. Det här kan vara en falsk krypta.

    Genomgående i den här grottkomplexet kommer statyer vara associerade med hemliga gångar och skatter.
    Nivå 2
    8: Hemlig gång
    Det här rummet ligger direkt nedanför 7: Falskt tempel. Det är en smal nischliknande passage som snabbt vidgar sig till att övergå till 9: Statyernas hall.
    9: Statyernas hall
    En lång och bred korridor. Sex väldiga statyer föreställande tungt beväpnade och bepansrade ormmän överskuggar salen och stirrar ilsket på sällskapet. En av statyerna står lite ur fas jämfört med de andra: den kan flyttas för att blotta 10: Hemligt vaktrum.
    Lärdomar: sällskapet ska ha lärt sig i 7: Falskt tempel att statyer ibland döljer hemliga gångar. 
    Ljus från ytan kan inte tränga igenom så här långt ner. Hädanefter måste rollpersonerna förlita sig på andra ljuskällor.
    10: Hemligt vaktrum
    Det här rummet var en gång ett dolt vaktrum för templets lönnmördare. Nu står det tyst och mörkt. Möblemanget har ruttnat så bara spillror återstår. På väggen hänger två krokförsedda glavar som fortfarande är användbara, tillsammans med en symbol av silver värd 5 ~gm~.
    Lärdomar: hemliga rum innehåller mer skatter.
    11: Kryptatrium
    Hallen öppnar upp sig till en stor åttasidig kammare, även den omgärdad av stirrande ormfolksstatyer. Några bär vapen, andra håller i redskap för tortyr eller lantbruk. Dörrarna till rum 12-16 är gjorda av tung sten men kan rubbas med hävstång utan större problem. Rum 15 har en olåst trädörr. Rum 18 har en stendörr, men den är mycket mer utsmyckad än de andra. Det ser ut som en gång var ett schakt i rummets mitt, men vatten som droppat från ytan har fyllt den till bredden med mörkt, oljigt vatten som luktar lakrits. Den är 3 meter djup.

    Inuti bassängen finns 2 Mumiespillror (Nivå 2, Moral 12, Attack 1T4 [Klo] eller 1T6 [Strypning] ). De kommer  hoppa upp och angripa alla som kommer nära schaktet.
    Lärdomar: det finns dolda monster. Vissa monster sprider sjukdomar. Det är väldigt svårt att träffa ett monster som klamrar sig fast vid din väns strupe.
    Att bara beröra vattnet orsakar inte mumiesjuka, men att dricka det eller få det i öppna sår gör det. Om sällskapet kan dräpa eller oskadliggöra mumiespillrorna, kan de försöka dragga eller söka igenom bassängen.  Den innehåller:
    ett rasande och fullständigt vansinnigt mumiehuvud.
    en tung guldkedja värd 35 ~gm~.
    en magisk silverring.
    ett magiskt nyttoting som SL väljer, ett slumpmässigt magiskt föremål eller smycken värda 2T10 ~gm~.
    Silverringen är Fjärrögats Ring. När den bärs, ramlar ett av nyttjarens ögon ut och blir hårt som glas. Ögat kan fortfarande se normalt. 
    Lärdomar: leta efter skatter på botten av schakt och bassänger. Magiska föremål kan lösa problem. 
    12: Xisor den Grönes krypta
    Passagen in till den här kryptan rymmer en tryckplatta som utlöser en åskvigg-besvärjelse med sikte längs med korridoren. Den utdelar 4T6 skada (Räddningskast för hälften) och löser bara ut en gång. Elektrumskivan den avfyras från är värd 10 ~gm~. Det finns också en formelrulle (ögongift eller någon annan giftbaserad besvärjelse) inut Xisors likkista.
    Lärdomar: ibland är golven gillrade med fällor. Fällor är ofta dödliga. Behandla okända rum med försiktighet. 
    13: Sparamanturs krypta
    Den här kryptan är delvis ihoprasad: takets block har störtat in. Om rollpersonerna börjar gräva ut rummet, kommer de höra Sparamantur, ett ormfolks-skelett (Nivå 3, Moral 12, Attack 1T8 [Skarprättarbila]),  ragla omkring och banka på andra sidan den blockerade passagen. Han är inte subtil och kommer hugga så fort han får syn på en levande varelses huvud. Hans grannlåt är värd 10 ~gm~.
    Lärdomar: lyssna vid dörrar. Ni kan höra vissa montster innan ni ser dem. Vissa rum är det bäst att lämna ifred.

    14: Franbinzars krypta
    Det här rummet är primitivare än de andra och har enklare målningar och ornament. Det rymmer en stor stenkista med de dåligt mumifierade kvarlevorna av Franbinzar, fästets sista makthavare. Mumifieringen gick inte bra. Kvarlevorna räknas som en Svart Smet (Nivå 5, Moral 12, Attack 1T6 [Slag] eller 3T6 [Längre Kontakt]) och kommer slänga sig emot och angripa den som öppnar kistan. Hans gravgods är kopior av lera, men han har ringar värda 2 ~gm~ inneslutna i sig. Om han dräps kommer han regenera efter 1T20 timmar såvida inte han bränns upp. Om han kommer lös i grottkomplexet, lägg till honom i Tabellen över Strövande Väsen (sida XX),  där han ersätter ett av förebudsresultaten. 
    Lärdomar: sörjor bor i dungar. De är svåra att klubba, precis som skeletten var svåra att hugga. Ni kan använda omgivningen till er fördel (genom att springa runt schaktet i 11: Kryptatrium, genom att stänga stendörrar för sörjan, genom att locka sörjan till övervåningen och slå till den med hammarfällan, etcetera).
    15: Prästrum
    Det här rummet användes av övre kryptans präster. Det rymmer tre sängar, några ruttna hyllor och en ormgudssymbol av silver och smaragder värd 20 gm. Utspridda skriftrullar återger instängda mumiers  osammanhängande svammel på ett glömt språk.
    Lärdomar: värdeföremål tar okonventionella former. Svamlet kan vara värdefullt om det översätts eller säljs till lättlurade.
    16: Ofärdig krypta
    Det här rummet är tomt, sånär som på några kasserade verktyg för stenarbete som ligger och rostar på golvet. Det kan bli en bra tillflyktsort i ett nödläge eller någonstans att gömma förnödenheter.
    Lärdomar: en del rum är tomma.
    17: Lerkrigarnas rum
    En samling av arton lerstatyer föreställande ormfolkskrigare i naturlig storlek i tre rader med sex i varje. Deras svärd är sönderrostade till obrukbarhet. Varje staty är ihålig, men innehåller inte någonting. Statyn längst bort i det södra hörnet står ovanpå en hemlig gång vilken leder till 38: Basilisksalen.
    Lärdomar: vissa rum ser mer hotfulla ut än de är. Titta under statyer för gömda passager.

    18: Trappor
    Den här passagen värnas av en väldigt ornamenterad port, utsirad med bilder av ormar som regnar ner från himlen. Trappor leder ner i mörkret. Ett svagt vinddrag kan kännas här.

    Det tredje trappsteget ovanifrån är gillrad med en fälla. Om det läggs någon tyngd på den, kommer trappstegen vikas ner och bli en slät stenramp. Spetsar fälls ut ur golvet vid rampens botten när fällan löser ut. En rollperson som glider ner tar T6 i skada (Räddningskast för hälften). Fällan återaktiveras efter 5 rundor.
    Lärdomar: Kolla golvet. Fällor kan flytta er, inte bara ge skada.
    19: Granitväktarens arena
    Det här är ett stort arenaliknande rum (identiskt med 11: Kryptatrium i storlek och form) helt täckt med sköldar från stammar besegrade av ormfolket. Några av sköldarna har ruttnat sönder, men minst 5 är fortfarande i användbart skick. Om de skrapas och tas isär är silvertråden i dem värd 2 ~gm~.

    Precis i mitten av rummet står Granitväktaren (se sida 11). Den angriper så fort den får syn på en rollperson.
    20: Avgrund och avsats
    En smal avsats längs en bottenlös avgrund. Avsatsen tynar bort in i berget mot norr och leder till resten av katakomberna till söder. Avsatsen är 3 meter bred och en aning hal: springa eller  hoppa kräver ett tämligen lätt räddningskast. Avgrunden är 18m bred och motstående sida syns inte såvida inte sällskapet använder eldpilar eller en mycket kraftfull ljuskälla. Om sällskapet retar upp svampvättarna så kommer det här vara platsen där de helst ligger i bakhåll. Vättarna är klibbiga och kan ignorera att stengolvet är halt.

    Som spelledare är avgrunden din att forma och utöka. Du kan lägga till trappor som leder ner till andra nivåer. Du kan lägga till en bro, precis efter 21: Grottkoraller till en slutstrid på andra sidan, med 29: Skattkammare som ett sätt att komma runt korallerna. Du kan till och med använda Veins of the Earth för att generera ett helt grottsystem. Valet är ditt.
    Lärdomar: välj era strider noga.

    21: Grottkoraller
    Här är gångstigen full av grottkoraller. Dessa stentäckta mollusker slukar alla varmblodiga varelser som passerar dem. Rollpersoner som spenderat tid i kryptor, grottor och tunnlar känner igen och vet att undvika dessa odjur.
    Lärdomar: den här vägen är stängd. Tänk ut en lösning (förgiftat kött, exploderande grodor, etcetera) och kom tillbaka senare.
    Nivå 3
    Det finns 5 huvudområden på Nivå 3.
    Yttre salarna (22-26)
    Kvadersten, en aning fuktigt, mögel och slem på den lägre delen av väggarna. Luften är kall, speciellt nära avgrunden. Vissa torra och dammiga ställen. Allt har uthuggna eller målade ormmotiv på sig.
    Offergrop (27-30)
    Kvadersten med bättre mosaik. Luften är varm och syrefattig och blir sämre när ni närmar er 30: Offergrop.
    Xiximanters tillhåll (43-46)
    Fint huggen sten täckt av damm och spindelnät. Purpurfärgat ljus och bubblande alkemiska kolvar. Glittret av glas och slamret av ben.
    Vättegyttret (47-52)
    Grävd genom sammanstörtade tunnlar och rum eller genom naturliga grottor. Smutsigt. Golvet är tjockt av träck, skalbaggar och förruttnelse. Ni kan inte höra om tjattret kommer från skalbaggar eller vättar.

    Den här nivån innehåller även Strövande Väsen. De dras till ljud, ljus och värme. De börjar förflyttar sig tilll de övre lagren av grottkomplexet först när Granitväktaren blivit besegrad.










    22. Stendörr
    Nedsänkt 12 cm in i väggen och hålls stängd av en tung stenbom. Bommen är på sidan vänd mot avgrunden. Dörren kan inte öppnas om man kommer från andra hållet utan att ha sönder stora delar av den. Den rymmer samma typ av hammarfälla som i 5: Dörr/Hammarfälla, men hammaren svingar bort från dörren, snarare än mot den. Detta gör den lättare att ducka (+2 på Räddningskastet), men alla rollpersoner som träffas måste slå igen för att inte kastas ner i avgrunden.
    Lärdomar: fällor upprepar sig i dungar. Var försiktig i närheten av bottenlösa avgrunder.
    23: Ceremonirum
    Använd av ormfolkets präster för att förbereda sig och meditera. Rymmer flera låga bänkar, urgamla väggbonader och en torr fontän. Vättar har lirkat bort guldstatyn från fontänen och gömt den i sitt tronrum. Några guldfragment värda 1 ~gm~ ligger kvar.
    Lärdomar: vissa rum är ofarliga. Titta efter vad som kan saknas.
    24: Korridor
    En lång och smal korridor som lutar nedåt mot söder. Rymmer 1 Skelettsylta (Nivå 1, Moral 12, Attack 1T4 [Slag] som rör sig mot oväsen.
    Strövande Väsen
    Kolla varje halvtimme på Nivå 3 eller närhelst rollpersonerna gör mycket oväsen. Slå 1T8:
    Förebud om basilisken. Rasslandet av en kedja som kastas av och an, dragen genom sten och damm.
    Förebud om sylta. Vått slaskande på avstånd.
    Förebud om vättarna. Tjatter, till hälften fnitter, hälften tandgnissel och slickande om läppar. Glittret av röda ögon i fjärran. En pust av svampröta.
    Fladdermus. Inte fientlig, men uppskakande. Fladdrar runt och flyger mot avgrunden.
    Stor spindel. Stor som en knytnäve. Här för att äta fladdermöss, inte rollpersoner. Giftig (1T4 i giftskada) men räddhågsen. Anses vara en delikatess av vättarna.
    1T6 Svampvättar. Se sida 12. I en spejartrupp. Ytterligare 1T6 vättar lurar runt hörnet.
    1 Skelettsylta. Se sida 12.
    1T10+5 Svampvättar. Se sida 12. I en plundrings- patrull. 1 vätte har ett skrattretande opraktiskt bestickspjut (T6 skada, räckvidd). 


    25: Schaktfälla
    Det här rummet har ett falskt golv av tunna stenplattor. En 3o cm bred kant längs med väggarna är säker, men alla andra plattor hålls upp pinnar och tunna metallstänger. En rollperson som stiger in i rummet måste slå Räddningskast för att Ducka eller ta 1T6 skada från fallet och slå igen för att inte ta ytterligare 1T6 från spetsarna på bottnen. De falska plattorna är lätta att upptäcka. En saknas till och med.

    Schaktet rymmer åtskilliga vanliga människoskelett och en guldring värd 2 ~gm~. Vättarna använder schaktet för att fånga mat och ersätter nedfallna plattor varje dag.
    Lärdomar: kolla golvet.
    26: Korridor
    En liten passage förgrenar sig från huvudkorridoren och leder till en låst dörr. Låset har farit illa av tidens tand och dörren kan lätt öppnas.
    27: Slavrum
    Här är luften varm och syrefattig, och det hörs ett tydligt väsande ljud från söder. Rummet användes en gång för att hålla slavar och ett par järnbojor ligger fortfarande kvar på golvet. Bojorna är förtrollade så att de låser sig runt benen på någon som går inom 30 cm från dem, men den rostiga metallen är klen och kan bändas bort med ett lätt Styrkekast.
    Lärdomar: alla fällor är inte dödliga. Se upp för strövande väsen och dröjsmål.
    28: Kupolsal
    En ståtlig kupolsal med en låst järnport till söder. Nyckeln till porten är innesluten i basiliskens hals. Porten är inte magisk, men det skulle ta ett arbetslag timmar eller dagar för att bända upp den eller spräcka dess gångjärn. Till väster finns en sönderslagen stendörr.
    29: Skattkammare
    Det här rummet rymmer… vadhelst du vill placera i slutet av ditt grottkomplex: en slutstrid, ett sällsynt föremål, högar med guld, ledtrådar till vidare äventyr, trappor till fler nivåer av grottkomplexet. Allra minst bör den innehålla skatter av olika slag till ett värde av 200 ~gm~.




    30: Offergrop
    Offergropen består av en nedsjunken, evig flamma i mitten av en uthuggen, 4½ meter djup grop. Sidorna på gropen lutar nedåt. Flamman får bränsle från naturgas ledd från en djup och uråldrig gruva. Det finns en 60 cm bred avsats runt gropen. Förkolnade ben täcker bottnen. Även om luften är syrefattig här, så är den inte farlig för någonting utanför själva gropen. Varelser i gropen måste slå Räddningskast varje runda eller ta 1T6 temporär Konstitutionsskada. Medvetslösa rollpersoner glider ner till flamman och tar 2T6 skada av elden varje rond.

    Det finns rinniga strimmor av guld runt flamman och ett fåtal kolbelagda ädelstenar (värda 50 ~gm~ totalt) glittrar i det brandgula ljuset. Alla offer var inte fattiga.
    Lärdomar: vissa faror är osynliga.
    31: Bevakad sal
    Två statyer föreställande ormmän står i de södra hörnen av denna ståtliga sal. De här statyerna är oerhört naturtrogna och mycket mer detaljrika än något annat stenarbete i katakomberna. I realiteten är de förstenade ormmän placerade här som bestraffning. Om de skulle oförstenas störtar de ner i mordiskt ursinne i 10 minuter, för att sedan sakta ge efter till förtvivlan. Statyerna är värda 50 ~gm~ styck om de säljs i en större stad eller tio gånger mer till en trollkarl som inser deras beskaffenhet.
    Lärdomar: försök hitta förklaringar till saker som verkar malplacerade.
    32: Åkallelserum
    Ett långt och trångt rum med en stor hög med bråte (trasiga sköldar, böjda svärd, ljusstakar och trädgrenar) vid ingången. Att rensa bort högen tar en halvtimme och för ett fasligt oväsen. Rummet innanför var en gång en kammare för åkallan. Det rymmer en fjättrad Succuba (sida 11) åkallad av ormfolket för att svara på frågor om de lägre helvetena. Hon ser ut att vara en ung botanist av samma art som den första rollpersonen hon ser och av lämpligt kön. Hon kommer påstå att hon blivit tillfångatagen av vättarna. Bojan runt hennes fotled är ett bländverk. Allt hon behöver är att någon stiger över cirkeln (som är täckt av damm och till större delen dold) som fjättrar henne.

    Rummet rymmer även ett litet altare, 2 gyllene skålar värda 15 ~gm~ styck, en magisk dolk (+1) och en vågformad orm av sten som varseblivs som magisk. Ormen kan användas till att öppna porten till 46: Tronrum. Succubin är inte fientlig mot rollpersonerna, men hon kommer att försöka isolera och kyssa en av dem (lyckas med Räddningskast eller dö, annars 1T6 permanent KP och Kon skada samt åldras 1T10 år. +10 på slaget om hon gillar dig) så hon kan fylla på sina reserver och fly iväg. Hennes sanna namn (Baltoplat) är nedskrivet i en skriftrulle i 15: Prästrum. Vättarna är rädda för henne. Xiximanter känner till hennes sanna natur, men antar att sällskapet också vet. Hon är immun mot förstening och är synnerligen bra på att ducka och undvika. Hon kommer omedelbart att fly från alla konflikter. Om hon tvingas förhandla kan hon varsebli gift, avslöja forntida hemligheter eller komma överens om att dräpa en vanlig dödlig rollpersonerna kan namnet på. Hon är tålmodig och listig, men håller sitt ord.
    Lärdomar: vissa monster har dolda agendor. Det finns bländverk. Låt dig inte bli isolerad. För inte oväsen.
    33: Tempelnisch
    En alkov vilken rymmer en helgedom tillägnad en av ormfolkets många kobrahövdade gudar. Statyn har två hål i sin bas stora nog för en mänsklig arm. Statyn kan inte lyftas, men kommer skramla och kan lätt vridas. Nästan vilken ansträngning, granskning eller åtgärd som helst kommer vrida den något. Vridning 90◦ moturs löser ut en giftgasfälla (T6 skada i ett 9m moln). Vridning 90◦ medur får en massa guld (2T100+10 ~gm~) att spilla och rulla ut över golvet. Några mynt kommer rulla in i 35: Korridor med klingfälla.
    Lärdomar: skatter är gömda bakom statyer. Vissa fällor följer mönster.



    34: Prästernas vilorum
    Användes av ormfolkets präster för att vila och meditera. Dörren är bortruttnad sedan flera århundranden. Rummet innehåller fem blodsfläckade, ruttna och sönderstrimlade sidenkuddar samt tre stenägg. Äggen är magiska. Om de täcks med färskt däggdjursblod kommer de bli behagligt varma och kan användas som varmvattenflaskor. En enskild nedblodning håller ett ägg varmt i 8 timmar. De kan torkas rena efter första applikationen.
    Lärdomar: vissa magiska föremål är till för vardagliga ändamål.
    35: Korridor med klingfälla
    Den här korridoren är gillrad med en fälla. Taket är veckat som strupen på en orm. Band av stenplattor vindlar längs golvet. Om man stiger på någon av de upphöjda plattorna aktiveras 4 svängande blad vilka skär ner från taket. Rollpersoner måste lyckas med ett Räddningskast för att Undvika eller ta 1T6 skada. All förflyttning genom de markerade rutorna kräver ytterligare Räddningskast i 3 rundor efter att fällan löst ut. Om en rollperson misslyckas med detta tar de 1T6 skada och förflyttar sig inte under innevarande rond. Rollpersoner som står still tar ingen skada. På fjärde ronden brakar hela fällan ner i ett virrvarr av sten, klingor och fjädrar, vilket ger 2T6 skada till alla som är kvar i det markerade området.
    Lärdomar: fällor är inte alltid tillförlitliga. Rör er snabbt bort från fara. Kolla golvet.
    36: Vestibul
    Delvis förruttnade väggbonader ligger på golvet, vilket är  uthugget i geometriska mönster. Någon som står pressad mot den västra väggen kan inte ses av Basilisken. En korridor sluttar ner till 37: Schaktfälla.
    37: Schaktfälla
    En schaktfälla identisk med 25: Schaktfälla. Ormfolket ville verkligen inte att deras ritualoffer skulle fly till resten av katakomberna. Det här schaktet innehåller inget av värde.
    38: Basilisksal
    En väldig stenkammare fylld av förfallna pelare (åtta totalt, i två rader längs varje sida av salen). Taket försvinner i mörkret. Fladdermöss håller till däruppe. Golvet är belamrat av sönderslagna statyer, inklusive väldigt noggrant uthuggna fladdermöss, spindlar och vättar.

    Basilisken (sida 14) lurar i mörkret. En tjock järnkätting kedjar fast den med taket. Den kan inte lämna salen.
    Lärdomar: vissa monster har okonventionella attacker. Använd lagarbete för att besegra en varelse eller kringgå den helt. Lyssna efter hot.
    39: Lönngång
    En dold passage vilken leder från 17: Lerkrigarnas rum till 38: Basilisksal. Dörren på salens sida var omärkbar i sitt original- skick, men med tiden har mosaikplattor fallit bort, vilket nu röjer dörrens konturer.
    Lärdomar: dungar har öglor och genvägar.
    40: Lönngång
    Den här passagen är dold bakom en annan lönndörr och den här är oskadd och svår att hitta. Den är på precis motsatt sida av Basiliskens sal från 39: Lönngång och i samma stil, så slipade spelare kommer snabbt lokalisera den. Även om väggarna är släta och gedigna, så stinker luften och golvet är tjockt av vättars sörja.
    41: Trappa upp till ytan
    En trappa upp till ytan. Den mynnar ut i det fria under ett träds rötter. Människostora varelser kan krypa igenom, men för att röja en större passage krävs yxor och tid.
    Lärdomar: dungar har öglor och genvägar. Monster har ekologier.
    42: Cylinderrum
    En roterande stencylinder med ett uthugget stycke stort nog för två personer (föreställ er en tillbucklad tunna). Vrid den moturs för att aktivera en fälla med stötande spjut (1T6 skada per person och rond tills de är roterade till säkerhet). Vrid den medurs för att blotta en avgudabild av sten med två gyllene skålar värda 10 ~gm~ styck. Vrid ett halvt varv för att nå 47: Vättegytter.
    Lärdomar: vissa fällor följer mönster. Speja framåt.

    43: Xiximanters förrum
    Ett utsökt huggen hall, veckad som insidan av en varelses strupe, upplyst av purpurfärgade, magiska ljus inlagda i väggarna. Xiximanter (sida 12) är en uråldrig ormfolksmagiker, rubbad men odödlig. Han ser ut som ett uttorkat människolik (med huggtänder) sammansmällt med en ormsvans vid midjan. Han bär en skrud som hänger i trasor och hans ögon är röda nålstick. Han är inte oresonlig och kommer hälsa sällskapet med “Var hälsade, tvåbeningar” när de kommer in i hans tillhåll. Xiximanter vill ha levande varelser, gärna intelligenta och allra helst magiker. Han är helt övertygad om att han är nära ett genombrott. Han tror också att ormfolkets imperium fortfarande härskar ovanför honom, att katakomberna är fulla av präster och att sällskapet måste vara barbariska besökare på kringvandring. Om han blir visad bevis på motsatsen blir han ursinnig.
    """


rest =
    """
    44: Ingrediensförråd
    Tunnor med urgamla örter och pulver står bredvid fat med syra och unket vatten. En kolv innehåller pulvriserad saffran (till ett värde av 200 ~gm~), medan en pytteliten flaska rymmer 1T10 frön från en nu utrotad växt (värd 30 ~gm~ styck för en samlare eller driftig bonde). Xiximanter kommer inte byta bort dessa om inte han kan få ännu mer sällsynta eller värdefulla ingredienser från sällskapet. Inget de hittar i katakomberna lär kittla hans intresse. Det är också här Xiximanter förvarar sina offer. Sex fånghålor med mässingslock, som vintankar nedsänkta i golvet, är utspridda i rummet. Schakten innhåller för närvarande 1T10 eländiga Svampvättar (1 KP, Moral 7, Attack 1T6 [Svärd eller Tänder]) nedstuvade i samma schakt.
    45: Elixirlaboratorium
    Alkemiska kolvar, dammiga verktyg och glänsande hyllor fulla av vackra flaskor står utefter väggarna. Rollpersonerna kommer inte tillåtas komma förbi förrummet såvida de inte går med på att bli Xiximanters lärjungar (eller offer). Hans mest kraftfulla elixir tar årtionden att brygga. Han kan tänka sig byta dekokter mot levande varelser, besvärjelser, sällsynta ingredienser och lärjungar. Han tar inte emot mynt eller skatter. Om sällskapet öppet bär föremål plundrade från katakomberna kommer han bli misstänksam och försöka förgifta, fånga eller manipulera dem. Förrutom en samling slumpmässiga trollbrygder (10+1T10 stycken), rymmer hans hyllor alltid:
    2 besvärjelsemutationsbrygder
    1 dryck för blygsam odödlighet (förlänger naturliga livslängden med 20+1T100 år)
    1 oförnimbart gift (smakar som en slumpmässig dekokt, men dödar (inget Räddningskast) på 1 minut.
    2 helande drycker
    Lärdomar: använd diplomati. Vissa fiender kan resoneras med. Du kan bedriva handel i ett grottkomplex. Du kan förråda dina vänner.
    46: Tronrum
    Den stora porten i änden av Basilisksalen är tillverkad av omslingrade stenormar. En orm saknas. Den kan hittas i 32: Åkallelserum. Om den sätts tillbaka, slingrar sig porten upp och blottlägger ett rum av röd sten, guld och speglar. De 8 handflatestora speglarna på trästativ är värda 10 ~gm~ styck om de säljs i en större stad. Tronen är värd 250 ~gm~, men att lyfta den kräver minst 3 personer. Den som sätter sig på den måste lyckas med ett Räddningskast mot Sinneskontroll eller åtrå landområden och erövring.

    Xiximanter har en lönngång från tronrummet till sitt tillhåll, men han har inte använt den på årtionden. Lönndörren i tronrummet är dold bakom en rutten väggbonad. Ingången på Xiximanters sida är bakom några lådor. Passagen är tjock med damm. Om rollpersonerna använder den kommer Xiximander bli förvånad och möjligen rasande om de inte kommer på en rimlig ursäkt.
    Lärdomar: alla lönngångar är inte säkra. Rum i dungar är sammanlänkade. Det finns berg av skatter.
    47: Vättegytter
    Det här rummet är en del av Vättegyttret. Det är en låg grotta (1½m hög). Det står klart att de här rummen störtade samman för århundranden sedan och blivit urgröpta av vättarna. De använder det här rummet för till förvaring av fjädrar, trasor och byttor med flott. En grundlig genomsökning av bråten täcker en rollperson upp till halsen med träck och skalbaggsskal och får fram 2T6 silverknivar (värda 1sm styck) och ett tillknycklat mässings- armband (värdelöst).
    48: Vättarnas ynglingsgrop
    Passagen in i det här rummet är bara 60 cm hög. Den rymmer vättarnas ynglingsgrop: en vedervärdig sörja av svamp, djurkadaver och uppsvällda, vätskefyllda säckar. Rollpersoner måste lyckas med ett Räddningskast mot Illamående eller fly på grund av vämjelse. Gropen reinkarnerar döda vättarns själar och är ett av Xiximanters misslyckade odödlighetsexperiment. Det finns inga skatter här, men om inte det här rummet bränns kommer antalet vättar i grottkomplexet alltid vara för många.
    Lärdomar: Det är svårt att fullständigt rensa ett grottkomplex. Eld är användbart.




    49: Vättarnas tronrum
    Vättarnas tronrum. För det mesta rymmer det här rummet 1T6 (exploderar på 6) Svampvättar som äter fladdermöss, slåss eller tillber deras nuvarande kung. Om de inte nyligen har hittat en levande varelse att kröna, gör de en avgudabild av pinnar och lera. Vättekronan är tillverkad av böjda bestick och kvistar. De har haft en riktig krona, men tappat bort den.
    Lärdomar: använd diplomati och taktik. Vättarna kommer kringränna er och hugga er i mörkret.
    50: Vättarnas odlingar
    Vättarna planterar allt möjligt här för att se om det växer. Sjukliga växter ruttnar i mörkret, tillsammans med begravda fingrar, vapen och guld. Muddring av detta rum uppenbarar 2T10 ~gm~, en rubin värd 30 ~gm~ och Ormkonungarnas Krona. Bara materialen kronan är tillverkad av har ett värde av 300 ~gm~. Den är gjord av 8 små ihopslingrade ormar av guld och platina, med smaragdögon och diamantänder. Kronan är även magisk. Någon som bär den som inte är en ormman måste slå mot rädsla. Om de misslyckas spenderar de nästa timme med att babbla och hoa i ren skräck. Om tre på varandra följande timmar spenderas i detta tillstånd, är effekten permanent. Kronan kan avlägsnas av en annan person. Om de lyckas med räddningsslaget händer ingenting. Garvade förgiftare eller trollkarlar kanske känner igen de blå svamparna här som grottgurkor, som kan bota förstening om de skivas och gnids på huden. Personen kommer att återhämta sig inom 1T6 dagar.
    Lärdomar: Titta efter skatter på märkliga ställen. Vättar är usla bönder.
    51: Vättarnas rabalderrum
    Detta rum tjänar inget särskilt syfte för vättarna, men vid godtycklig tidpunkt kommer 1T6 (exploderande på 6) Svampvättar (sida 12) vara närvarande på natten och 3T6 + 10 (exploderar på en 6) på dagen. Vättarna kommer sova i bägge fallen, men kommer att vakna 2 rundor efter att rollpersonerna har gjort betydande oväsen i något intilliggande rum. De är nästan osynliga i skräpet. 
    Lärdomar: Smyg förbi dina fiender. Grottkomplexet förändras beroende på om det är dag eller natt.
    52: Vättarnas vaktrum
    Ett till större delen kollapsat rum som används av vättarna för att förvara vapen. Den innehåller 2 högafflar, en hög med silver- bestick (värde 20sm) och dussintals tillspetsade pinnar. En Svampvätte är satt på vakttjänst. Han har en stor sopkvast som han använder för att fösa bort skelettsyltorna. Om rollpersonerna kommer in från 28: Kupolsal genom att öppna den sönderslagna stendörren, föser han dem tillbaka med kvasten under protester . Om de kommer från 51: Vättarnas rabalderrum, springer han iväg skrikande.
    Lärdomar: Fiender kan använda udda vapen av en anledning. Att jaga vättar i mörker är ingen höjdare.
    Monster
    Svart Smet
    Återfinns i: 14: Franbinzars krypta
    Egenskaper: som black pudding
    Utseende: 100 kg svart slem; tjock som sirap
    Vill ha: ha mat, gärna inträngd i ett hörn; rädd för eld
    Rustning: som läder
    Stridstärningar: 5
    Förflyttning: ¼ av normal
    Moral: 12
    Skada: 1T6. Vid långvarig konakt (inträngd i ett hörn eller omsluten) 3T6

    Tar ingen skada av krossvapen.

    Den svarta smeten kan angripa samtliga rollpersoner bredvid sig varje rond, med en vanligt attackslag för varje. Om den tränger in en rollperson i ett hörn börjar den omsluta hen och gör 3T6 skada per rond. Metall- eller trävapen som träffar den löses upp i 10% av fallen.
    Mumiespillror
    Återfinns i: 11: Kryptatrium
    Egenskaper: som crawling claws
    Utseende: sönderfallande svarta armar med klolika fingrar
    Vill: strypa saker, krossa de levande
    Rustning: som läder
    Stridstärningar: 2
    Förflyttning: ½  av normal
    Moral: 12
    Skada: slag 1T4, strypning 1T6

    De sprattlar, klättrar på din kropp och försöker strypa dig.
    Granitväktaren
    Återfinns i: 19: Granitväktarens arena
    Egenskaper: som en ogre i tung rustning
    Utseende: en stenriddare klädd i uthuggen rustning med kobramotiv. Den svingar ett enormt svärd fullt med hack. Dess andra hand är fri när striden börjar.
    Vill: skydda resten av Ormkonungarnas Katakomber och döda alla inkräktare.
    Rustning: som plåt
    Stridstärningar: 6
    Förflyttning: normal
    Moral: 12
    Skada: se Attacker nedan
    Attacker: Varje rond kan Granitväktaren använda ett av följande tre attackmönster:
    Tillkalla sköld: Väktaren kallar på en sköld hängandes på arenans vägg. Skölden ger 1T6 skada – räddningskast för att ducka – till varje varelse mellan den och Väktaren. Väktaren håller skölden i sin tomma hand vilket ger den +1 i Försvar. Skölden kan offras som normalt (reducerar inkommande skada med 1T12 och skölden blir förstörd).
    Hoppa och slå ner: Väktaren hoppar upp i luften och slår ner mellan 1½ till 6 meter bort från sitt startläge. Den landar inte direkt på varelser, men varje närliggande varelse tar 1T4 skada – räddningskast för att undvika. Varelser som tar skada slås omkull till liggande.
    Tvillinghugg: Väktaren hugger efter två mål med sitt svärd. Målen måste vara i samma “kvadrant” (framför, höger sida, vänster sida, bakom) och vara närliggande till Väktaren. Väktaren slår en normal, separat attack mot varje mål och ger 1T8+Styrkebonus i skada vid varje träff.
    Rummet är utformat så att rollpersonerna kan flankera Väktaren, fly uppför trappan (där den inte får plats), knuffa ner Väktaren i avgrunden eller fly förbi den och hoppas att den inte följer efter; det kommer Väktaren göra, men bara tills den inte längre kan se eller höra rollpersonerna. Sköldarna på väggarna kan även användas av rollpersonerna.
    Succuba (Baltoplat)
    Återfinns i: 32: Åkallelserum
    Egenskaper: som succubus
    Utseende: se sida 8
    Vill:  se sida 8
    Rustning: som plåt med sköld
    Stridstärningar: 8
    Förflyttning:  normal, kan teleportera 3 m varje runda

    Flyr strid (vill inte riskera det) och återvänder inte.
    Skelett
    Återfinns i: 6: Falsk gravkammare och 13: Sparamanturs krypta
    Egenskaper: som skeleton
    Utseende: huggtandsförsett människoskelett med lindade bandage runt kroppen och ett rostigt metallvapen i hand. 
    Vill: skydda resten av Ormkonungarnas Katakomber och döda alla inkräktare.
    Stridstärningar: 2 (3 om Sparamantur)
    Förflyttning:  normal
    Moral: 12
    Skada: 1T6 med huggtänder eller svärd (1T8 om storyxa)

    Tar halv skada från hugg och stickvapen. De rasslar och knakar; lika mordiska som obevekliga.
    Svampvättar
    Återfinns i: Vättegyttret och som Strövande Väsen
    Egenskaper: som goblins, men klibbiga
    Utseende: Bleka, förkrympta varelser med gigantiska ovala huvuden fulla med tänder och två pyttesmå röda ögon alldeles för tätt ihop. Konsistens som bakad potatis blandad med trälim.
    De har bestick som klädsel och vill ha mat.
    Vill: ha en kung, mat, blanka föremål och mer mat.
    Stridstärningar: 0 (1 KP)
    Förflyttning:  normal, klättrar även som normal förflyttning
    Moral: 7
    Skada: 1T6 med svärd, tänder, klor eller bestick

    Svampvättarna är inte fientliga till en början och kommer försöka kröna någon till Vättekonung. De kommer följa honom lojalt till nästa fullmåne; då kommer de omringa och myllra över sin kung, släpa honom till ett altare på en kulle och slakta honom. De talar en tjattrande och begränsad vättedialekt och är lätta att muta. Vättarna kommer varna sällskapet för Basilisken, men känner inte till 39: Lönngång eller något om de övre nivåerna – Granitväktaren håller dem därifrån. Vättarna använder 41: Trappa upp till ytan för att smyga upp ur underjorden om natten. Om rollpersonerna skulle döda någon av dem eller bete sig fientligt, då flyr vättarna och börjar förbereda det första av många bakhåll.

    Svampvättarna är listiga och tålmodiga. De kan (långsamt) klättra upp för väggarna och överfalla sällskapet ovanifrån. De kommer använda spannar med vatten för att släcka facklor, rep för att snärja och grottornas existerande fällor för att stympa och isolera gruppen. Vättarna kommer också ansätta gruppens läger på natten, bita av benen på deras hästar och stjäla glänsande föremål. Såvida inte 48: Vättarnas ynglingsgrop är bränd, kommer antalet vättar i grottkomplexet alltid vara för många. Svampvättarna är experiment som flytt. Även om Xiximanter inte har något emot att få tillbaka dem, är de inte honom till någon större nytta.
    Skelettsylta
    Återfinns i: 24: Korridor och som Strövande Väsen
    Egenskaper: som ett väldigt svagt skeleton som är fullständigt immunt mot skada.
    Utseende:  Ett skelett täckt med bärnstensfärgad gelé. Odödligt och närapå oförstörbart. Varje attack som normalt skulle göra 4 eller mer skada knuffar istället tillbaka det 1½ meter.
    Vill: klämma huvuden och göra fler skelettsyltor.
    Stridstärningar: 2, men med oändlig kp. Du kan inte reducera deras kp med skada, magi, eld, syra, böner, elaka förolämpningar eller beröringen från liemannen själv. De är för enfaldiga för att leva och för trögfattade för att dö.
    Förflyttning: ½ normal – men även uppför väggar, om de inte kommer fram på annat vis. 
    Moral: 12
    Skada: 1T4, vanligtvis genom att greppa ditt huvud.
    Lösningar: Spring iväg, få Basilisken att förstena dem, putta ner dem i Avgrunden, bind fast dem, lås in dem i ett rum eller fånga dem i 25: Schaktfälla eller 37: Schaktfälla.

    Det finns totalt 4 skelettsyltor i grottkomplexet. Om sällskapet skulle lyckas med att fullständigt oskadliggöra alla fyra – ta då bort dem från Strövande Väsen-tabellen. Skelettsyltorna kommer så småningom kravla sig fria från schaktfällor och repknyten. Varje levande varelse som dräps av dem återuppstår som en skelettsylta inom 10 minuter – svampvättar är dock immuna mot detta.
    Xiximanter
    Återfinns i: Xiximanters tillhåll
    Egenskaper: som en lich 
    Utseende:  Överkroppen hos ett uttorkat människolik i ämbetsdräkt; underkropp från ett ormskelett. Förtrollade talismaner och krimskrams runt halsen. Två röda ögon – brännande som nålstick av eld. En orms huggtänder. Aldrig oartig.
    Vill: ha levande varelser och trollformler samt sällsynta ingredienser till sina olika brygder.
    Rustning: som plåt med sköld
    Stridstärningar: 10
    Förflyttning: 1½ × normal 
    Moral: 12
    Skada: 1T6 med huggtänder och kloförsedda händer

    När Xiximanter blir rasande kommer hans forntida vanvett och uppblossande trolldomskraft tvinga alla åskådare att lyckas med ett Räddningskast mot Rädsla eller fly. Xiximanter besvärjer som en fruktansvärt kraftfull trollkarl – han har ⅙ chans att ignorera varje besvärjelse med honom som mål: om han gör det har han 50% chans att reflektera tillbaka besvärjelsen mot dess kastare. Xiximanter är immun mot all sinnespåverkande magi. Han kan se igenom illusioner, men roas av att låtsas som han inte gör det. 

    Typiska besvärjelser: Eldmur, Animera död, Försvagningsstråle, Energistråle × 3, Mörker, Gasform, Dödsstråle × 2, Sömn × 2. Lägg till så många andra fasansfulla och unika besvärjelser som ditt system tillåter.
    """
