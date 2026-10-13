# tárgyak

összesen 7 tárgytípus van
random(0..99) dönti el hogy melyik tárgyra kerül a választás
    0..25  - Potion (26)
    26..61 - Scroll (36)
    62..77 - Food   (16)
    78..84 - Weapon (7)
    85..91 - Armor  (7)
    92..95 - Ring   (4)
    96..99 - Staff  (4)

ezeken kívül van még
    gold
    amulett

- POTION - Bájitalok (14 típus)
    Név	                                Esély	Érték   Időtartam                   Hatás
    confusion - Zavarodottság	        7%	    5       19..20 spread(20) kör       ISHUH állapot
    hallucination - Hallucináció	    8%	    5       808..892 spread(850) kör    A szörnyek véletlen betűkként jelennek meg
    poison - Méreg	                    8%	    5       -                           1-3 pont erővesztés
    gain strength - Erőnövelés	        13%	    150     -                           +1 erő, garantáltan
    see invisible - Láthatatlan-látás	3%	    100     808..892 spread(850) kör    CANSEE állapot
    healing - Gyógyítás	                13%	    130     -                           hpt += ROLL(lvl, 4), ha meghaladná a maxhp-t akkor a maxhp 1gyel nő és ugyanennyi lesz a hp, leveszi a vakságot
    monster detection - Szörny-észlelés 6%	    130     20 kör                      SEEMONST állapot
    magic detection - Mágia-észlelés	6%	    105     -                           megáll az idő, egy teljesen üres képernyőn megmutatja a mágikus tárgyakat (azokat is amik a szörnyeknél vannak) a szinten $ jelekként, keypress után eltűnnek a jelek és visszatér a normál képernyő
    raise level - Szintemelés	        2%	    250     -                           Azonnali szintlépés
    extra healing - Extra gyógyítás	    5%	    200     -                           hp += ROLL(lvl, 8), ha meghaladja maxhp-t, de kevesebb mint maxhp+jatekos_szint+1 akkor a maxhp 1gyel nő, ha annál is több lesz akkor a maxhp 2vel nő, ilyenkor a hp=maxhp, leveszi a vakságot és a hallucinációt
    haste self - Gyorsítás	            5%	    190     random(4..7) kör            ISHASTE állapot -> ha már gyorsított állapotban issza meg, a hatás megszűnik és a játékos random(0..7) körre elájul
    restore strength - Erővisszaállítás 13%	    130     -                           Visszaállítja az erőt az eredeti maximumra
    blindness - Vakság	                5%	    5       808..892 spread(850) kör    ISBLIND állapot
    levitation - Levitáció	            6%	    75      29..31 spread(30) kör       ISLEVIT állapot

- SCROLL - Tekercsek (18 típus)
    Név	                                                    Esély	Érték   Idötartam               Hatás
    monster confusion - Szörny-zavarás	                    7%	    140     következő sikeres ütés  CANHUH állapot
    magic mapping - Térképezés	                            4%	    150     -                       Feltárja a teljes szint elrendezését (ajtók, folyosók, csapdák)
    hold monster - Fogvatartás	                            2%	    180     -                       a játékos körüli 2 mezős körzetben (5x5) lévő, épp üldöző (ISRUN) szörnyek ISHELD-et kapnak és lejön róluk az ISRUN
    sleep - Elaltatás	                                    3%	    5       random(4..8) kör        Elaltatja a játékost
    enchant armor - Páncélbűvölés	                        7%	    160     -                       javítja a páncélt (-1 védelem) és eltávolítja az átkot
    identify potion - Potion-azonosítás	                    10%	    80      -                       Felfedi egy bájital típusát
    identify scroll - Tekercs-azonosítás	                10%	    80      -                       Felfedi egy tekercs típusát
    identify weapon - Fegyver-azonosítás	                6%	    80      -                       Felfedi egy fegyver bónuszát
    identify armor - Páncél-azonosítás	                    7%	    100     -                       Felfedi egy páncél bónuszát
    identify ring, wand or staff - Gyűrű/pálca-azonosítás	10%	    115     -                       Felfedi egy gyűrű/pálca típusát
    scare monster - Szörny-elriasztás	                    3%	    200     -                       elolvasva csak "you hear maniacal laughter in the distance" üzenet és elporlad, a szörnyek nem lépnek rá és nem is születhetnek arra a mezőre ahol ott van ez a tekercs, ha már egyszer fel lett véve majd eldobva akkor a másodszori felvételkor szintén elporlad
    food detection - Étel-észlelés	                        2%	    60      -                       Megmutatja, hol van étel a szinten
    teleportation - Teleportálás	                        5%	    165     -                       Véletlen helyre teleportál a szinten
    enchant weapon - Fegyverbűvölés	                        8%	    150     -                       Eltávolítja az átkot, majd 50-50% eséllyel növeli eggyel vagy a fegyver támadás módosítóját vagy a sebzés módosítóját
    create monster - Szörny-teremtés	                    4%	    75      -                       Szörnyet generál közvetlenül a játékos mellé (a 8 szomszédos mező egyikén), ha ott nincs hely akkor semmi nem jön létre -> "faint cry of anguish"
    remove curse - Átok-eltávolítás	                        7%	    105     -                       a páncélról, fegyverről és mindkét gyűrűről leveszi az átkokat
    aggravate monsters - Felbőszítés	                    3%	    20      -                       a teljes szinten minden szörny feléd indul (ISRUN állapotba kerülnek), az alvó ISMEAN szörnyek is felébrednek, az ISHELD is feloldódik (ua. mint a gyűrű)
    protect armor - Páncélvédelem	                        2%	    250     -                       ISPROT flag kerül az éppen viselt páncélra (blokkolja az Aquator és a rozsda-csapda rozsdásítását)

- FOOD  - Étel
    - ha 3 szinten át nem generálódott étel, a következő tárgygenerálás kényszerítve étel lesz.

- WEAPON - Fegyverek (9 típus)
    Név 	                                Esély   Érték   Kézben  Hajítva
    mace - Buzogány	                        11%	    8       2x4	    1x3
    long sword - Hosszúkard	                11%	    15      3x4	    1x2
    short bow - Rövid íj	                12%	    15      1x1	    1x1
    arrow - Nyílvessző (random(8-15) db)	12%	    1       1x1	    2x3     -> íj kell a kézben, a nyíl a csomagban marad és onnan dobod, akkor 2x3, egyébként 1x1
    dagger - Tőr (random(2..5) db)	        8%	    3       1x6	    1x4
    two handed sword - Kétkezes kard        10%	    75      4x4	    1x2
    dart - Dobótőr (random(8..15) db)	    12%     2       1x1	    1x3
    shuriken - Shuriken (random(8..15) db)	12%     5       1x2	    2x4
    spear - Lándzsa	                        12%	    5       2x3	    1x6
    (a 10. bejegyzés NULL, 0 — ez a sárkány-lehelet "hamis" placeholdere, sosem generálódik)

    - minden fegyver kap egy támadás módosítót ami lehet
        - 5% eséllyel (+) enhanced (elvarázsolt: a támadás erősödik +1..+3)
        - 85% esélyel (n) normal (normál: nincs változás)
        - 10% esélyel (-) reduced (csökkentett (átkozott, azaz nem lehet lecserélni): a támadás gyengül -1..-3)
    - emellett van egy sebzés módosító is ami alapból mindíg 0, de varázstekerccsel ez módoítható

- ARMOR - Páncélok (8 típus)
    Név                                             Esély	Érték   Alap védelem
    leather armor - Bőrpáncél                       20%	    20      8
    ring mail - Láncing                             15%	    25      7
    studded leather armor - Szegecselt bőrpáncél    15%	    20      7
    scale mail - Pikkelypáncél                      13%	    30      6
    chain mail - Láncszemes páncél                  12%	    75      5
    splint mail - Hasított páncél                   10%	    80      4
    banded mail - Szalagos páncél                   10%	    90      4
    plate mail - Lemezpáncél                        5%	    150     3

    - az alacsonyabb védelem érték a jobb
    - minden páncél kap egy módosítót ami lehet
        - 8% eséllyel (+) enhanced (elvarázsolt: a védelem javul +1..+3-mal)
        - 72% eséllyel (n) normal (normál: nincs módosító)
        - 20% eséllyel (-) cursed (átkozott: a védelem romlik -1..-3-mal)
    - átkozott páncélt nem lehet levenni, csak miután a "remove curse" scroll-lal levesszük az átkot róla (a negatív értékek ezután is megmaradnak a páncélon)
    - nem lehet használni fegyverként

- RING - Gyűrűk (14 típus)
    Név	                                Esély	Étel/kör    Érték   Hatás
    protection - Védelem	            9%	    +1	        400     nagyobb védelem -> a mod (o_arm) értéke hozzáadódik a védelemhez, a varázsmentődobást is javítja
    add strength - Erőnövelés	        9%	    +1	        400     Felvéve a mod (o_arm) értékét hozzáadja az erőhöz
    sustain strength - Erő-fenntartás	5%	    +1	        280     Véd a méreg/kígyó erővesztése ellen
    searching - Keresés	                10%	    −3	        420     Segít csapdát/titkos ajtót találni -> ajtó 1/5, csapda 1/2, rejtett folyosó 1/3, hallucinációnál +3, vakságnál +2 a nevezőbe, körönként hívódik
    see invisible - Láthatatlan-látás	10%	    −5	        310     CANSEE állapot
    adornment - Dísz	                1%	    0	        10      nincs hatása
    aggravate monster - Felbőszítés	    10%	    0	        10      Mindig átkozott - Felvételkor a teljes szinten minden szörny feléd indul (ISRUN állapotba kerülnek), az alvó ISMEAN szörnyek is felébrednek, az ISHELD is feloldódik (ua. mint a scroll) - viselése közben az újonnan létrejövő szörnyek is a játékos felé indulnak
    dexterity - Ügyesség	            8%	    −3	        440     Jobb találati esély -> mod (o_arm) a találati bónuszhoz adódik, csak a kézben tartott fegyverre érvényes, a dobottra nem
    increase damage - Sebzésnövelés	    8%	    −3	        400     Nagyobb sebzés -> mod (o_arm) a sebzéshez adódik, csak a kézben tartott fegyverre érvényes, a dobottra nem
    regeneration - Regeneráció	        4%	    +2	        460     körönként +1 HP maxhp-ig
    slow digestion - Lassú emésztés	    9%	    −2	        240     50% eséllyel körönként 1 egység étel visszaadódik (átlagosan 0,5-del kevesebb fogy körönként, két ilyen gyűrű átlagosan kioltja az éhezést)
    teleportation - Teleportálás	    5%	    0	        30      Mindig átkozott - körönként 1/50 eséllyel véletlen helyre visz a szinten
    stealth - Lopakodás	                7%	    +1	        470     Nem ébrednek fel az alvó ISMEAN szörnyek
    maintain armor - Páncél-fenntartás	5%	    +1	        380     Véd az Aquator rozsdásítása ellen

    - bal és jobb kézen lehet gyűrűt hordani
    - van 4 gyűrű amik lehetnek enhanced (+1 vagy +2) vagy cursed (-1) ami úgy dől el hogy mod=random(0..2) és ha 0 akkor mod=-1
        - protection
        - add strength
        - dexterity
        - increase damage
    - a cursed gyűrűket nem lehet levenni csak ha már levettük róluk az átkot
    - a gyűrűkben lévő köveknek külön értéke van
    - a gyűrűk minden körben éhséget okoznak
        - alap fogyasztás körönként 1 egység (`food_left -= ring_eat(LEFT) + ring_eat(RIGHT) + 1 - amulet`), ehhez adódik a gyűrűk fogyasztása
        - pozitív érték: körönként pontosan ennyi egység extra étel fogy (minden körben, biztosan)
        - negatív érték: körönként 1/|n| eséllyel fogy 1 extra egység (`rnd(-n) == 0`)
        - 0: nem fogyaszt extra ételt
        - slow digestion: 50% eséllyel -1 (azaz visszaad 1 egységet)

- STICK - Pálcák/botok (14 típus)
    Név	                                    Esély	Érték   Hatás
    light - Fény                            12%	    250     Sötét szobában eltávolítja az ISDARK flaget, így a szoba a szint végéig világos marad, folyosón csak a "the corridor glows and then fades" üzenet jelenik meg
    invisibility - Láthatatlanná tétel      6%	    5       A lövés útjában lévő első szörny ISINVIS flaget kap, a hatás a szörny eltűnéséig, átalakulásáig vagy Cancellation-ig tart (CANSEE mellett továbbra is látható)
    lightning - Villám	                    3%	    330     Legfeljebb 6 mezőnyi sugár, falról vagy ajtóról visszapattan. A szörny varázsmentést dob: siker esetén a sugár elkerüli és továbbhalad, sikertelenségnél 6d6 sebzést okoz és ott megáll. A visszapattanó sugár a játékost is eltalálhatja.
    fire - Tűz	                            3%	    330     A Villám-pálcához hasonló, visszapattanó sugár; 6d6 sebzés. A szörny varázsmentést dob, siker esetén a sugár továbbhalad. A sárkány a lángot visszaveri, sebzést nem kap. A visszapattanó sugár a játékost is eltalálhatja.
    cold - Fagy	                            3%	    330     A Villám-pálcához hasonló, visszapattanó sugár; 6d6 sebzés. A szörny varázsmentést dob, siker esetén a sugár továbbhalad. Nem fagyaszt, csak sebez. A visszapattanó sugár a játékost is eltalálhatja.
    polymorph - Átalakítás	                15%	    310     A lövés útjában lévő első szörny véletlen szörnytípussá alakul; új statokat és típus-flageket kap, a nála lévő tárgyakat megtartja
    magic missile - Mágikus lövedék	        10%	    170     Irányba kilőtt lövedék; a szörny varázsmentő dobást kap, és sikeres mentésnél elkerüli. Sikertelen mentésnél a lövedék +100 találati bónusszal támad. Ha a játékosnak van kézben fegyvere, a sebzés 1d4+1 + az erőmódosító + a fegyver sebzésmódosító értéke (fegyver nélkül nem sebez, de ez valószínüleg csak egy bug)
    haste monster - Gyorsítás (szörny)	    10%	    5       A lövés útjában lévő első szörnyre hat, üldözővé teszi (ISRUN), ha lassított volt, leveszi róla az ISSLOW-t, különben ISHASTE-et kap, így körönként két lépést tehet
    slow monster - Lassítás (szörny)	    11%	    350     A lövés útjában lévő első szörnyre hat, üldözővé teszi (ISRUN), ha gyorsított volt, leveszi róla az ISHASTE-et, különben ISSLOW-t kap, így minden második körben lép
    drain life - Életerő-elszívás	        9%	    300     a játékos aktuális szobájában (vagy folyosón, a hozzá tartozó területen) lévő szörnyeket érinti. Ha van célpont, a játékos aktuális HP-ja felére csökken, ezt a levont mennyiséget egyenlően elosztja a szörnyek között; ha nincs célpont, nem történik elszívás. ha a hp < 2 akkor "too weak" és nem történik semmi, a töltés sem fogy
    nothing - Semmi	                        1%	    5       nincs hatása
    teleport away - Elteleportálás	        6%	    340     A lövés útjában lévő első szörnyre hat - egy véletlen, járható szobamezőre helyezi, ahol nincs másik szörny (tárgy lehet), ISRUN flaget kap, de a pálca nem törli a célpont esetleges ISHELD flagjét
    teleport to - Magamhoz-teleportálás	    6%	    50      A lövés útjában lévő első szörnyre hat - a játékos melletti, kiválasztott irányú mezőre helyezi, ISRUN flaget kap, de a pálca nem törli a célpont esetleges ISHELD flagjét
    cancellation - Képesség-eltörlés	    5%	    280     A lövés útjában lévő első szörny ISCANC flaget kap - láthatóvá válik, elveszíti zavaró képességét, speciális támadási hatásai (pl. Aquator rozsda, Rattlesnake méreg, Wraith/Vampire szívás, Medusa pillantása, sárkánytűz) nem működnek, a szörny átalakulásáig vagy eltűnéséig tart

    - Minden "mágia-típus" vagy bot (staff), vagy pálca (wand) formában jelenik meg - sosem mindkettőben egy játékon belül.
    - random(3..7) töltés, kivéve a Fény típust, ami random(10...19) töltéssel jön, csak azonosítás után derül ki hogy mennyi van benne
    - Bot: 2x3 közelharci sebzés. Pálca: 1x1 közelharci sebzés. Mindkettő: 1x1 hajítási sebzés
    - A varázsmentődobás egy 1d20-as próba, nem a találati dobás: a szörny akkor menti meg magát, ha legalább 17 - (szörny szintje / 2, lefelé kerekítve) az eredmény. Nagyobb szintű szörny könnyebben ment; a játékos varázsmentését a védőgyűrűk javítják. A visszapattanó elemi sugár ellen a játékos is dobhat mentést; sikertelenségnél 6d6 sebzést kap. Használatonként 1 töltés fogy.
    - Ha az Invisibility, Polymorph, Teleport Away, Teleport To vagy Cancellation pálcával Venus Flytrapot célzol, a közös kódág törli a játékos ISHELD flagjét, tehát kiszabadítja a játékost. Ez nem törli a szörny saját ISHELD flagjét.

- GOLD
    - nincs különösebb jelentősége (lehet gyűjteni)
    - az ork minig az aranyra megy és ráül (őrzi) ha a szobában van arany

- AMULETT
    - a játék célja ezt a tárgyat kihozni a dungeon-ból
    - ha a játékos megszerezte akkor a lépcsőkön már lehet menni felelé is
    - ha megvan akkor az alap éhség 0



## tárgyak általános tulajdonságmezői

Az eredeti Rogue-ban minden tárgy ugyanazt a fix méretű rekordot használja, mint amit a hős/szörny is - csak más mezőnevekkel:

    type      - kategória (POTION, SCROLL, FOOD, WEAPON, ARMOR, STAFF, RING, GOLD, AMULET)
    pos       - hol fekszik a padlón
    text      - felirat (pl. tekercs neve, amíg nincs azonosítva)
    launch    - mivel lőhető ki (pl. nyílnál: BOW)
    packch    - milyen betűvel jelenik meg a csomagban (a-z)
    damage    - kézben tartva ekkora a sebzése ("NxM")
    hurldmg   - eldobva ekkora a sebzése
    count     - darabszám (pl. 30 nyílvessző egy kötegben)
    which     - melyik konkrét fajta a kategórián belül
    hplus     - találat-módosító (fegyvernél)
    dplus     - sebzés-módosító (fegyvernél)
    arm       - TÖBBCÉLÚ mező: páncélnál védelmi érték, pálcánál töltésszám (charges), aranynál az érték (goldval)
    flags     - bitflagek: ISCURSED (átkozott, nem vehető le), ISKNOW (azonosítva), ISMISL (hajítható), ISMANY (csoportos tárgy: nyílvessző/dobótőr/shuriken/arany köteg), ISFOUND (már felfedezett - ugyanaz a bit mint a szörnyeknél), ISPROT (páncél tartósan védett)
    group     - csoport-azonosító (kötegelt hajítható tárgyaknál)
    label     - a hős saját elnevezése ('c' - call parancs)

- eredetileg minden tárgy tartalmazza az összes tulajdonságmezőt...

- mágikus tárgynak számít (a magic detection és a nymph használja): potion/scroll/stick/ring/amulet mindig, páncél ha `ISPROT` vagy módosított, fegyver ha hplus/dplus != 0



## flag-ek (bitflagek)
    ISCURSED    Átkozott tárgy. páncél/fegyver esetén nem lehet levetni
    ISKNOW      A tárgy azonosítva van, a bónuszokat és a töltésszámot fedi fel
    ISMISL      Hajítható / missile típusú tárgy. (csak a nyílnál (íjjal) és a magic missile lövedékénél van jelentősége)
    ISMANY      Csoportosított tárgyakra vonatkozik: nyílvessző, dobótőr, shuriken és arany köteg. Ez nem általános "minden többes tárgy" flag.
    ISFOUND     A tárgy már felfedezett / megkeresett, hasonlóan a szörnyeknél használt jelzéshez (de leginkább nem jó semmire)
    ISPROT      azt jelöli hogy Páncél tartósan védett, de csak a rozsdásodást blokkolja
