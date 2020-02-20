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
    - Med aggression, kraftfullt försvar, styrka eller uthållighet: slå +~järn~.

På en *stark träff*, lyckas du. Ta +1 ~driv~.

På en *svag träff*, lyckas du, men du ställs också inför en besvärlig kostnad. Välj en:

|> List
    - Du offrar förnödenheter: utstå //-1 ~förråd~.
    - Du är trött eller sårad: /Uthärda Skada/ (1 ~skada~).
    - Du är modfälld eller rädd: /Uthärda Stress/ (1 ~stress~).
    - Du är sinkad, förlorar ett övertag eller ställs inför ett nytt hot: utstå //-1 ~driv~.

På en *miss*, antingen misslyckas du eller dina framsteg undermineras av av en dramatisk och kostsam händelseutveckling. /Betala Priset/.

"""
