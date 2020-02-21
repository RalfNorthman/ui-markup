module Source exposing (source)


source : String
source =
    String.trim
        """
|> Header
    Äventyrsdrag

|> SubHeader
    Möta Fara

När /du försöker någonting riskabelt eller reagerar på ett omedelbart hot,/ föreställ dig din handling och slå.

Om du handlar...

|> List
    - Med charm, lojalitet eller mod: slå +~hjärta~.
    - Med snabbhet, vighet eller precision: slå +~egg~.
    - Med expertis, insikt eller observation: slå +~sinne~.
    - Med bedräglighet, förstulenhet eller list: slå +~skugga~.
    - Med styrka, uthållighet, aggression eller kraftfullt försvar: slå +~järn~.

På en *stark träff* lyckas du. Ta +1 ~driv~.

På en *svag träff* lyckas du, men du ställs även inför en bekymmersam kostnad. Välj en:

|> List
    - Du offrar förnödenheter: lid //-1 ~förråd~.
    - Du är trött eller sårad: /Uthärda Skada/ (1 ~skada~).
    - Du är modfälld eller rädd: /Uthärda Stress/ (1 ~stress~).
    - Du är sinkad, förlorar ett övertag eller ställs inför ett nytt hot: lid //-1 ~driv~.

På en *miss* antingen misslyckas du eller så undermineras dina framsteg av en dramatisk och kostsam händelse-utveckling. /Betala Priset./

|> SubHeader
    Säkra Övertag

När /du bedömmer en situation, gör förberedelser eller försöker få inflytande,/ föreställ dig din handling och slå.

Om du handlar...

|> List
    - Med charm, lojalitet eller mod: slå +~hjärta~.
    - Med snabbhet, vighet eller precision: slå +~egg~.
    - Med expertis, insikt eller observation: slå +~sinne~.
    - Med bedräglighet, förstulenhet eller list: slå +~skugga~.
    - Med styrka, uthållighet, aggression eller kraftfullt försvar: slå +~järn~.

På en *stark träff* säkrar du ett övertag. Välj en:

|> List
    - Ta kontroll: gör omedelbart ett till drag med +1 (ej<>ett<>framstegsdrag).
    - Förbered senare handling: ta +2 ~driv~.

På en *svag träff* är ditt övertag kortlivat. Ta +1 ~driv~.

På en *miss* antingen misslyckas du eller så blir du förådd av dina antaganden. /Betala Priset./

|> SubHeader
    Samla Information

När /du finkammar ett område, ställer frågor, genomför en undersökning eller följer ett spår,/ slå +~sinne~. Om du agerar inom ett samhälle eller ställer frågor rörande en person du har ~band~ till, slå med +1.

På en *stark träff* upptäcker du något användbart och specifikt. Vägen du måste följa eller handlingen du måste utföra för att göra framsteg är klarlagd. Föreställ dig vad du blir varse (/Fråga Oraklet/ om du är osäker) och ta +2 ~driv~.

På en *svag träff* komplicerar informationen ditt kall eller avslöjar en ny fara. Föreställ dig vad du upptäcker (/Fråga Oraklet/ om du är osäker) och ta +1 ~driv~.

På en *miss* gräver antingen dina eftersökningar upp ett ödesdigert hot eller så avslöjar du en ovälkommen sanning som underminerar ditt kall. /Betala Priset./

|> SubHeader
    Hela

När /du behandlar ett sår eller åkomma,/ slå +~sinne~. Om du sköter om dina egna sår, slå den lägre av +~sinne~ och +~järn~.

På en *stark träff* gör din omvårdnad nytta. Om du (eller den allierade som får vård) har statusen /sårad,/ så kan du stryka den. Den vårdade får även +2 ~hälsa~.

På en *svag träff*, som ovan, men du måste även lida antingen //-1<>~förråd~ eller //-1 ~driv~ (du väljer).

På en *miss* är din vård verkningslös. /Betala Priset./

|> SubHeader
    Bunkra Upp

När /du jagar, samlar eller rotar runt,/ slå +~sinne~. 

På en *stark träff* bygger du på dina reserver. Ta +2 ~förråd~.

På en *svag träff* kan du få upp till +2 ~förråd~, men du måste lida //-1 ~driv~ för varje du tar.

På en *miss* får du inte tag på något tjänligt. /Betala Priset./

|> SubHeader
    Slå Läger

När /du vilar och återhämtar dig under åtskilliga timmar ute i vildmarken,/ slå +~förråd~. 

På en *stark träff* väljer du och dina allierade två var. På en *svag träff* välj en var.

|> List
    - Förbereda: När du bryter lägret, slå med +1 på /Vandra./
    - Samla kraft: ta +1 ~hälsa~ för dig och dina följeslagare.
    - Inta föda: lid //-1 ~förråd~ och ta +1 ~hälsa~ för dig och dina följeslagare.
    - Fokusera: ta +1 ~driv~.
    - Slappna av: ta +1 ~anda~.

På en *miss* får du ingen respit. /Betala Priset./

|> SubHeader
    Vandra

När /du vandrar genom förrädiska eller obekanta trakter,/ ange rangen på din färd.

|> List
    - En besvärlig vandring: 3 framsteg per etapp.
    - En farlig vandring: 2 framsteg per etapp.
    - En formidabel vandring: 1 framsteg per etapp.
    - En extrem vandring: 2 streck per etapp.
    - En episk vandring: 1 streck per etapp.

Sedan: för varje etapp på din vandring, slå +~sinne~. Om du ger dig av från ett samhälle som du har ~band~ till, slå ditt första slag med +1.

På en *stark träff* når du slutet på etappen. Om den här deldestinationen är okänd för dig, föreställ dig den (/Fråga<>Oraklet/ om du är osäker). Sedan väljer du en:

|> List
    - Du är sparsam med dina resurser: markera framsteg.
    - Du färdas utan dröjsmål: markera framsteg och ta<>+1<>~driv~, men lid //-1 ~förråd~.

På en *svag träff*, når du slutet på etappen och markerar framsteg, men lider //-1 ~förråd~.

På en *miss* blir du fördröjd av ett missöde eller en vådlig incident. /Betala Priset./

|> SubHeader
    Nå Din Slutdestination

/*Framstegsdrag*/

När /din vandring lider mot sitt slut,/ slå prövnings-tärn-ing-arna och jämför med dina framsteg. ~Driv~<>ignoreras vid detta slag.

På en *stark träff* är läget vid din destination i din favör. Välj<>en:

|> List
    - Gör ett till drag genast (ej ett framstegsdrag) med +1.
    - Ta +1 ~driv~.

På en *svag träff* anländer du, men ställs inför en oförutsedd risk eller komplikation. Föreställ dig vad du möter (/Fråga Oraklet/ om du är osäker).

På en *miss* har du gått hopplöst vilse, ditt mål är förlorat eller så har du blivit vilseledd om din destination. Om din vandring fortsätter, radera alla framsteg utom ett och höj vandringens rang med ett steg (om inte redan episk).

|> Header
    Relationsdrag

|> SubHeader
    Intala

När /du försöker intala någon att göra något,/ föreställ dig ditt tillvägagångssätt och slå. Om du...

|> List
    - Charmar, blidkar, köpslår eller övertalar: slå +~hjärta~ (med +1 om ni har ~band~ till varandra).
    - Ljuger eller vilseleder: slå +~skugga~.
    - Hotar eller sporrar: slå +~järn~.

På en *stark träff* gör de som du vill eller delar med sig vad de vet. Ta +1 ~driv~. Om du använder det här utbytet till att /Samla Information,/ gör det draget nu med +1.

På en *svag träff*, som ovan, men de kräver något i utbyte. Föreställ dig vad de vill (/Fråga Oraklet/ om du är osäker).

På en *miss* vägrar de eller ställer krav som står dig dyrt. /Betala Priset./

|> SubHeader
    Vistas

När /du tillbringar tid i ett samhälle och försöker få hjälp där,/ slå<>+~hjärta~. Om du har ~band~ till samhället, slå med +1.

På en *stark träff* kan du och dina allierade välja två var från punkterna i kategorierna nedan. På en *svag träff*, välj en. Om du har ~band~ till samhället, välj ytterligare en.

På en *träff* kan du och dina allierade var och en välja att fokusera på en av era valda punkter och slå<>+~hjärta~ igen. Om du delar ~band~ med samhället, slå<>med +1. På en stark träff, ta ytterligare +2 på den punkten. På en svag träff, ta ytterligare +1. På en miss går det åt skogen och du förlorar all gagn av den punkten.

~*Slippa Ett Tillstånd*~

|> List
    - Läka sig: radera /sårad/ och ta +1 ~hälsa~.
    - Samla sig: radera /uppriven/ och ta +1 ~anda~.
    - Utrusta sig: radera /nödställd/ och ta +1 ~förråd~.

~*Återhämtning*~

|> List
    - Tillfriskna: ta +2 ~hälsa~ för dig och dina följeslagare.
    - Bunkra: ta +2 ~förråd~.
    - Planera: ta +2 ~driv~.
    - Umgås: ta +2 ~anda~.

~*Erbjud Hjälp*~

|> List
    - Finn ett nytt kall: föreställ dig vad det här samhället behöver eller vilka svårigheter de står inför (/Fråga Oraklet/ om du är osäker). Om du väljer att hjälpa till, /Svär En Järned/ med +1.

På en *miss* finner du ingen hjälp här. /Betala Priset./

|> SubHeader
    Dra Cirkeln

När /du utmanar någon på formell tvekamp eller antar en utmaning,/ slå<>+~hjärta~. Om du har ~band~ till samhället ni vistas i, slå med +1.

På en *stark träff*, ta +1 ~driv~. Du kan även välja upp till två skrytsamheter och ta +1 ~driv~ för varje.

På en *svag träff* kan du välja en skrytsamhet och få +1 ~driv~.

|> List
    - Försaka första slaget: din motståndare har initiativet.
    - Håll inget järn: du strider utan vapen -- din ~skada~ är 1.
    - Blottlägg dig själv: dra ingen fördel av varken rustning eller sköld -- din motståndares ~skada~ får +1.
    - Till döds: envigen kan bara sluta med döden.
    - Bloda dig själv: /Lid Skada/ (1 ~skada~).

På en *miss* börjar du tvekampen i underläge. Din<>motståndare har initiativet. /Betala Priset./

Sedan: gör drag för att avgöra kampen. Om du står som segrare kan du göra en rättmätig begäran och din mot-stånd-are måste foga sig eller förverka sin ställning och heder. Om du avböjer utmaningen, ger dig eller blir besegrad ställer de krav på dig istället.

|> Header
    Stridsdrag

|> SubHeader
    Ta Strid

När /du ger dig in i stridens hetta,/ ange rangen på var och en av dina motståndare.

|> List
    - En besvärlig motståndare: 3<>framsteg<>per<>~skada~<>--<>utdelar<>1<>~skada~.
    - En farlig motståndare: 2<>framsteg<>per<>~skada~<>--<>utdelar<>2<>~skada~.
    - En formidabel motståndare: 1<>framsteg<>per<>~skada~<>--<>utdelar<>3<>~skada~.
    - En extrem motståndare: 2<>streck<>per<>~skada~<>--<>utdelar<>4<>~skada~.
    - En episk motståndare: 1<>streck<>per<>~skada~<>--<>utdelar<>5<>~skada~.

Sedan: slå för att avgöra vem som har kontroll. Om du...

|> List
    - Står öga mot öga med motståndaren: slå +~hjärta~.
    - Rör dig i position mot en aningslös motståndare eller slår till utan varning: slå +~skugga~.
    - Är utsatt för ett bakhåll: slå +~sinne~.

På en *stark träff*, ta +2 ~driv~. Du har initiativet.

På en *svag träff*, välj en:

|> List
    - Stärk din position: ta +2 ~driv~.
    - Gå till handling: ta initiativet.

På en *miss* börjar du striden i underläge. Din<>motståndare har initiativet. /Betala Priset./

|> Header
    <>

|> Header
    <>
"""
