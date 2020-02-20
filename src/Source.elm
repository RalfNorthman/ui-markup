module Source exposing (source)


source : String
source =
    String.trim
        """
|> Header
    Äventyrsdrag

|> SubHeader
    Möta Fara

___När /du försöker någonting riskabelt eller reagerar på ett omedelbart hot,/ föreställ dig din handling och slå.

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
    - Du offrar förnödenheter: utstå //-1 ~förråd~.
    - Du är trött eller sårad: /Uthärda Skada/ (1 ~skada~).
    - Du är modfälld eller rädd: /Uthärda Stress/ (1 ~stress~).
    - Du är sinkad, förlorar ett övertag eller ställs inför ett nytt hot: utstå //-1 ~driv~.

På en *miss* antingen misslyckas du eller så undermineras dina framsteg av en dramatisk och kostsam händelse-utveckling. /Betala Priset/.

|> SubHeader
    Säkra Övertag

___När /du bedömmer en situation, gör förberedelser eller försöker få inflytande,/ föreställ dig din handling och slå.

Om du handlar...

|> List
    - Med charm, lojalitet eller mod: slå +~hjärta~.
    - Med snabbhet, vighet eller precision: slå +~egg~.
    - Med expertis, insikt eller observation: slå +~sinne~.
    - Med bedräglighet, förstulenhet eller list: slå +~skugga~.
    - Med styrka, uthållighet, aggression eller kraftfullt försvar: slå +~järn~.

På en *stark träff* säkrar du ett övertag. Välj en:

|> List
    - Ta kontroll: gör ett till drag omedelbart (ej ett framstegsdrag) med +1.
    - Förbered senare handling: ta +2 ~driv~.

På en *svag träff* är ditt övertag kortlivat. Ta +1 ~driv~.

___På en *miss* antingen misslyckas du eller så blir du förådd av dina antaganden. /Betala Priset./

|> SubHeader
    Samla Information

___När /du finkammar ett område, ställer frågor, genomför en undersökning eller följer ett spår,/ slå +~sinne~. Om du agerar inom ett samhälle eller ställer frågor rörande en person med vilken du delar ~band~, slå med +1.

___På en *stark träff* upptäcker du något användbart och specifikt. Vägen du måste följa eller handlingen du måste utföra för att göra framsteg är klarlagd. Föreställ dig vad du blir varse (/Fråga Oraklet/ om du är osäker) och ta +2 ~driv~.

___På en *svag träff* komplicerar informationen din gärning eller avslöjar en ny fara. Föreställ dig vad du upptäcker (/Fråga Oraklet/ om du är osäker) och ta + 1 ~driv~.

___På en *miss* gräver antingen dina eftersökningar upp ett ödesdigert hot eller så avslöjar du en ovälkommen sanning som underminerar din gärning. /Betala Priset./

|> SubHeader
    Hela

___När /du behandlar ett sår eller åkomma,/ slå +~sinne~. Om du sköter om dina egna sår, slå den lägre av +~sinne~ och +~järn~.

___På en *stark träff* gör din omvårdnad nytta. Om du (eller den allierade som får vård) har statusen /sårad/, så kan du stryka den. Den vårdade får även +2 ~hälsa~.

___På en *svag träff*, som ovan, men du måste även utstå antingen //-1<>~förråd~ eller //-1 ~driv~ (du väljer).

___På en *miss* är din vård verkningslös. /Betala Priset./

|> SubHeader
    Bunkra Upp

___När /du jagar, samlar eller rotar runt,/ slå +~sinne~. 

På en *stark träff* bygger du på dina reserver. Ta +2 ~förråd~.

På en *svag träff* kan du få upp till +2 ~förråd~, men du måste utstå //-1 ~driv~ för varje du tar.

På en *miss* får du inte tag på något tjänligt. /Betala Priset./
"""
