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
    Név	                                Esély	Ár      Időtartam       Hatás
    confusion - Zavarodottság	        7%	    5       20 kör          ISHUH állapot
    hallucination - Hallucináció	    8%	    5       850 kör         A szörnyek véletlen betűkként jelennek meg
    poison - Méreg	                    8%	    5       -               1-3 pont erővesztés
    gain strength - Erőnövelés	        13%	    150     -               +1 erő, garantáltan
    see invisible - Láthatatlan-látás	3%	    100     850 kör         CANSEE állapot
    healing - Gyógyítás	                13%	    130     -               hpt += ROLL(lvl, 4), de csak a maxhp-ig
    monster detection - Szörny-észlelés 6%	    130     20 kör          SEEMONST állapot
    magic detection - Mágia-észlelés	6%	    105     ???             megmutatja a mágikus tárgyakat a szinten
    raise level - Szintemelés	        2%	    250     -               Azonnali szintlépés
    extra healing - Extra gyógyítás	    5%	    200     -               hp += ROLL(lvl, 8) - a max_hp-t is növelheti
    haste self - Gyorsítás	            5%	    190     ???             ISHASTE állapot
    restore strength - Erővisszaállítás 13%	    130     -               Visszaállítja az erőt az eredeti maximumra
    blindness - Vakság	                5%	    5       850 kör         ISBLIND állapot
    levitation - Levitáció	            6%	    75      30 kör          ISLEVIT állapot

- SCROLL - Tekercsek (18 típus)
    Név	                                                    Esély	Ár      Idötartam               Hatás
    monster confusion - Szörny-zavarás	                    7%	    140     következő sikeres ütés  CANHUH állapot
    magic mapping - Térképezés	                            4%	    150     -                       Feltárja a teljes szint elrendezését (ajtók, folyosók, csapdák)
    hold monster - Fogvatartás	                            2%	    180     -                       2 mezős körzetben lévő, épp üldöző (ISRUN) szörnyek ISHELD-et kapnak
    sleep - Elaltatás	                                    3%	    5       ???                     Elaltatja a játékost
    enchant armor - Páncélbűvölés	                        7%	    160     -                       javítja a páncélt (-1 védelem) és eltávolítja az átkot
    identify potion - Potion-azonosítás	                    10%	    80      -                       Felfedi egy bájital típusát
    identify scroll - Tekercs-azonosítás	                10%	    80      -                       Felfedi egy tekercs típusát
    identify weapon - Fegyver-azonosítás	                6%	    80      -                       Felfedi egy fegyver bónuszát
    identify armor - Páncél-azonosítás	                    7%	    100     -                       Felfedi egy páncél bónuszát
    identify ring, wand or staff - Gyűrű/pálca-azonosítás	10%	    115     -                       Felfedi egy gyűrű/pálca típusát
    scare monster - Szörny-elriasztás	                    3%	    200     ???                     ??? A szörnyek elmenekülnek ???
    food detection - Étel-észlelés	                        2%	    60      -                       Megmutatja, hol van étel a szinten
    teleportation - Teleportálás	                        5%	    165     -                       Véletlen helyre teleportál a szinten
    enchant weapon - Fegyverbűvölés	                        8%	    150     -                       Eltávolítja az átkot, majd 50-50% eséllyel növeli eggyel vagy a fegyver támadás módosítóját vagy a sebzés módosítóját
    create monster - Szörny-teremtés	                    4%	    75      -                       Szörnyet generál közvetlenül a játékos mellé (a 8 szomszédos mező egyikén)
    remove curse - Átok-eltávolítás	                        7%	    105     -                       a páncélról, fegyverről és mindkét gyűrűről leveszi az átkokat
    aggravate monsters - Felbőszítés	                    3%	    20                              a teljes szinten minden szörny feléd indul, az alvó ISMEAN szörnyek is felébrednek
    protect armor - Páncélvédelem	                        2%	    250                             ISPROT flag kerül a páncélra, védi az Aquator rozsdásítása ellen

- FOOD  - Étel
    - A játékos gyomra max. 2000 egység ételt tárolhat.
        - 300 alatt: éhes lesz
        - 150 alatt: gyenge lesz
        - Negatívba fordulva: ájuldozik
        - −850 alatt: éhenhal
    - Étkezéskor 1100–1500 közötti véletlen mennyiség kerül a játékos gyomrába.
        - 10%-ban "finom" gyümölcs
        - 90% eséllyel "sima" étel
            - ilyenkor 30%-ban rossz ízű, de ártalmatlan, viszont 1 XP jár érte
    - Biztonsági háló: ha 3 szinten át nem generálódott étel, a következő tárgygenerálás kényszerítve étel lesz.

- WEAPON - Fegyverek (9 típus)
    Név 	                            Esély   Ár      Kézben  Hajítva
    mace - Buzogány	                    11%	    8       2x4	    1x3
    long sword - Hosszúkard	            11%	    15      3x4	    1x2
    short - Rövid íj	                12%	    15      1x1	    1x1
    arrow - Nyílvessző (11 db)	        12%	    1       1x1	    2x3
    dagger - Tőr (4 db)	                8%	    3       1x6	    1x4
    two handed sword - Kétkezes kard    10%	    75      4x4	    1x2
    dart - Dobótőr (10 db)	            12%     2       1x1	    1x3
    shuriken - Shuriken (11 db)	        12%     5       1x2	    2x4
    spear - Lándzsa	                    12%	    5       2x3	    1x6
    (a 10. bejegyzés NULL, 0 — ez a sárkány-lehelet "hamis" placeholdere, sosem generálódik)

    - minden fegyver kap egy támadás módosítót ami lehet
        - 5% eséllyel (+) enhanced (elvarázsolt: a támadás erősödik +1..+3)
        - 85% esélyel (n) normal (normál: nincs változás)
        - 10% esélyel (-) reduced (csökkentett: a támadás gyengül -1..-3)
    - emellett van egy sebzés módosító is ami alapból mindíg 0, de varázstekerccsel ez módoítható

- ARMOR - Páncélok (8 típus)
    Név                                             Esély	Ár      Alap védelem
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

- RING - Gyűrűk (14 típus)
    Név	                                Esély	Étel/kör	Ár      Hatás
    protection - Védelem	            9%	    +1	        400     1/3 eséllyel −1/átok, 2/3-ban +1 vagy +2 hozzáadódik a páncélhoz
    add strength - Erőnövelés	        9%	    +1	        400   ? Nagyobb erő (chg_str(o_arm))
    sustain strength - Erő-fenntartás	5%	    +1	        280     Véd a méreg/kígyó erővesztése ellen
    searching - Keresés	                10%	    −3	        420     Segít csapdát/titkos ajtót találni
    see invisible - Láthatatlan-látás	10%	    −5	        310     CANSEE állapot
    adornment - Dísz	                1%	    0	        10      nincs hatása
    aggravate monster - Felbőszítés	    10%	    0	        10    ? Mindig átkozott - a szörnyek agresszívabbak lesznek
    dexterity - Ügyesség	            8%	    −3	        440   ? Jobb találati esély (o_arm a találati bónuszhoz adódik)
    increase damage - Sebzésnövelés	    8%	    −3	        400   ? Nagyobb sebzés (o_arm a sebzéshez adódik)
    regeneration - Regeneráció	        4%	    +2	        460     körönként +1 HP maxhp-ig
    slow digestion - Lassú emésztés	    9%	    −2	        240     50%-kal kevesebb étel fogy (két ilyen gyűrű kioltja az éhezést)
    teleportation - Teleportálás	    5%	    0	        30      Mindig átkozott - körönként 1/50 eséllyel véletlen helyre visz a szinten
    stealth - Lopakodás	                7%	    +1	        470     Nem ébrednek fel az alvó ISMEAN szörnyek
    maintain armor - Páncél-fenntartás	5%	    +1	        380     Véd az Aquator rozsdásítása ellen

    - bal és jobb kézen lehet gyűrűt hordani
    - hatás + étel-fogyasztás
    - a negatív "étel/kör" azt jelenti: a gyűrű ad étel-tartalékot, nem fogyaszt
    - van 4 gyűrű amik lehetnek enhanced (+1 vagy +2) vagy cursed (-1) ami úgy dől el hogy mod=random(0..2) és ha 0 akkor mod=-1
        - protection
        - add strength
        - dexterity
        - increase damage
    - a cursed gyűrűket nem lehet levenni csak ha már levettük róluk az átkot

- STICK - Pálcák/botok (14 típus)
    Név	                                    Esély	Ár      Hatás
    light - Fény                            12%	    250   ? Kivilágítja a szobát
    invisibility - Láthatatlanná tétel      6%	    5     ? A szörny láthatatlanná válik
    lightning - Villám	                    3%	    330     6d6 sebzés, visszapattan a falakról
    fire - Tűz	                            3%	    330     6d6 sebzés, visszapattan a falakról
    cold - Fagy	                            3%	    330     6d6 sebzés, visszapattan a falakról
    polymorph - Átalakítás	                15%	    310   ? Más szörnnyé változtatja
    magic missile - Mágikus lövedék	        10%	    170     1d4 sebzés
    haste monster - Gyorsítás (szörny)	    10%	    5     ? A szörnyet gyorsítja
    slow monster - Lassítás (szörny)	    11%	    350   ? A szörnyet lassítja
    drain life - Életerő-elszívás	        9%	    300     Elszívja a játékos HP-jának a felét, ugyanannyit von le a közeli szörnyekből
    nothing - Semmi	                        1%	    5       nincs hatása
    teleport away - Elteleportálás	        6%	    340     A szörnyet máshova teleportálja
    teleport to - Magamhoz-teleportálás	    6%	    50    ? A szörnyet a játékos magához rántja
    cancellation - Képesség-eltörlés	    5%	    280   ? Elveszi a szörny speciális képességét

    - Minden "mágia-típus" vagy bot (staff), vagy pálca (wand) formában jelenik meg - sosem mindkettőben egy játékon belül.
    - 3-7 töltés, kivéve a Fény típust, ami 10-19 töltéssel jön.
    - Bot: 2d3 közelharci sebzés. Pálca: 1d1 közelharci/hajítási sebzés.
    - A Csapás (magic missile?) típus külön 1d8, +3/+3 bónuszt visel — ha ezzel ütsz/hajítasz, elhasználja a töltéseit.

- GOLD
    - nincs különösebb jelentősége (lehet gyűjteni)
    - az ork minig az aranyra megy és ráül (őrzi) ha a szobában van arany

- AMULETT
    - a játék célja ezt a tárgyat kihozni a dungeon-ból
    - ha a játékos megszerezte akkor a lépcsőkön már lehet menni felelé is
    - viselése esetén az alap éhség 0



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
    flags     - bitflagek: ISCURSED (átkozott, nem vehető le), ISKNOW (azonosítva), ISMISL (hajítható), ISMANY (kötegben jelenik meg), ISFOUND (már felfedezett - ugyanaz a bit mint a szörnyeknél), ISPROT (páncél tartósan védett)
    group     - csoport-azonosító (kötegelt hajítható tárgyaknál)
    label     - a hős saját elnevezése ('c' - call parancs)

- eredetileg minden tárgy tartalmazza az összes tulajdonságmezőt...
