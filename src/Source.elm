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

På en *miss* antingen misslyckas du eller så blir du förådd av dina antaganden . /Betala Priset/.
"""
