# tárgyak

összesen 7 tárgytípus van
random(0..99) dönti el hogy melyik tárgyra van szükség
    0..25  - Potion (26)
    26..61 - Scroll (36)
    62..77 - Food   (16)
    78..84 - Weapon (7)
    85..91 - Armor  (7)
    92..95 - Ring   (4)
    96..99 - Stick  (4)

1. potion - Bájitalok (14 típus)
    Név	                                Esély	Hatás                                           Üzenet
    confusion - Zavarodottság	        7%	    Rossz irányba mozogsz véletlenszerűen           Wait, what's going on here. Huh? What? Who?
    hallucination - Hallucináció	    8%	    A szörnyek véletlen betűkként jelennek meg      Oh, wow! Everything seems so cosmic!
    poison - Méreg	                    8%	    1-3 pont erővesztés                             You feel very sick now
    gain strength - Erőnövelés	        13%	    +1 erő, garantáltan                             You feel stronger, now. What bulging muscles!
    see invisible - Láthatatlan-látás	3%	    Látod a láthatatlan szörnyeket                  This potion tastes like ... juice
    healing - Gyógyítás	                13%	    Visszaad HP-t                                   You begin to feel better
    monster  - Szörny-észlelés	        6%	    Látod a szörnyeket a falakon át                 ((you see the monsters on the current level))
    magic detection - Mágia-észlelés	6%	    Megmutatja a mágikus tárgyakat a szinten        You sense the presence of magic on this level
    raise level - Szintemelés	        2%	    Azonnali szintlépés                             You suddenly feel much more skillful
    extra healing - Extra gyógyítás	    5%	    Nagyobb HP-visszaadás, max HP-t is növelheti    You begin to feel much better
    haste self - Gyorsítás	            5%	    Gyorsabb mozgás/cselekvés                       You feel yourself moving much faster
    restore  - Erő-visszaállítás	    13%	    Visszaállítja az erőt az eredeti maximumra      Hey, this tastes great. It make you feel warm all over
    blindness - Vakság	                5%	    Ideiglenesen vak leszel                         A cloak of darkness falls around you
    levitation - Levitáció	            6%	    Lebegsz — átmész csapdák/lávák felett           You start to float in the air

2. scroll - Tekercsek (18 típus)
    Név	                                                    Esély	Hatás                                           Üzenet
    monster confusion - Szörny-zavarás	                    7%	    Összezavarod a szörnyet                         Your hands begin to glow ...
    magic mapping - Térképezés	                            4%	    Feltárja a szint teljes térképét                Oh, now this scroll has a map on it
    hold monster - Fogvatartás	                            2%	    Megfagyasztja a közeli szörnyeket               The monster(s around you) freeze(s) -or- You feel a strange sense of loss
    sleep - Elaltatás	                                    3%	    Téged altat el — veszélyes!                     You fall asleep
    enchant armor - Páncélbűvölés	                        7%	    +1 a páncélodhoz                                Your armor glows ... for a moment -or- ((nothing))
    identify potion - Potion-azonosítás	                    10%	    Felfedi egy bájital típusát                     This scroll is an identify potion scroll
    identify scroll - Tekercs-azonosítás	                10%	    Felfedi egy tekercs típusát                     This scroll is an identify scroll scroll
    identify weapon - Fegyver-azonosítás	                6%	    Felfedi egy fegyver bónuszát                    This scroll is an identify weapon scroll
    identify armor - Páncél-azonosítás	                    7%	    Felfedi egy páncél bónuszát                     This scroll is an identify armor scroll
    identify ring, wand or staff - Gyűrű/pálca-azonosítás	10%	    Felfedi egy gyűrű/pálca típusát                 This scroll is an identify ring, wand or staff scroll
    scare monster - Szörny-elriasztás	                    3%	    A szörnyek elmenekülnek                         You hear maniacal laughter in the distance
    food detection - Étel-észlelés	                        2%	    Megérzed, van-e étel a szinten                  Your nose tingles and you smell food. -or- Your nose tingles
    teleportation - Teleportálás	                        5%	    Véletlen helyre ugrasz a szinten                ((you jump to a randomly spot on the current level))
    enchant weapon - Fegyverbűvölés	                        8%	    +1 a fegyveredhez                               Your ((name of armor)) glows ... for a moment -or- You feel a strange sense of loss
    create monster - Szörny-teremtés	                    4%	    Melléd generál egy szörnyet (kockázatos!)       ((a monster appears next to you)) -or- You hear a faint cry of anguish in the distance
    remove curse - Átok-eltávolítás	                        7%	    Levehetővé teszi az átkozott tárgyaidat         You feel as if somebody is watching over you -or- You feel in touch with the Universal Onenes -or- There is nothing on it to read
    aggravate monsters - Felbőszítés	                    3%	    Az egész szinten felébreszti a szörnyeket       You hear a high pitched humming noise
    protect armor - Páncélvédelem	                        2%	    Megvédi a páncélt az Aquator rozsdásításától    Your armor is covered by a shimmering ... shield -or- You feel a strange sense of loss

3. weapon - Fegyverek (9 típus)
    Név 	                            Esély	Kézben  Hajítva
    mace - Buzogány	                    11%	    2x4	    1x3
    long sword - Hosszúkard	            11%	    3x4	    1x2
    short - Rövid íj	                12%	    1x1	    1x1
    arrow - Nyílvessző (11 db)	        12%	    1x1	    2x3
    dagger - Tőr (4 db)	                8%	    1x6	    1x4
    two handed sword - Kétkezes kard    10%	    4x4	    1x2
    dart - Dobótőr (10 db)	            12%	    1x1	    1x3
    shuriken - Shuriken (11 db)	        12%	    1x2	    2x4
    spear - Lándzsa	                    12%	    2x3	    1x6
- minden fegyver kap egy támadás módosítót ami lehet
    - 5% eséllyel (+) enhanced (elvarázsolt: a támadás erősödik +1..+3)
    - 85% esélyel (n) normal (normál: nincs változás)
    - 10% esélyel (-) reduced (csökkentett: a támadás gyengül -1..-3)
- emellett van egy sebzés módosító is ami alapból mindíg 0, de varázstekerccsel ez módoítható

4. armor - Páncélok (8 típus)
    Név                                             Esély	Védelem
    leather armor - Bőrpáncél                       20%	    2
    ring mail - Láncing                             15%	    3
    studded leather armor - Szegecselt bőrpáncél    15%	    3
    scale mail - Pikkelypáncél                      13%	    4
    chain mail - Láncszemes páncél                  12%	    5
    splint mail - Hasított páncél                   10%	    6
    banded mail - Szalagos páncél                   10%	    6
    plate mail - Lemezpáncél                        5%	    7
- itt a magasabb Védelem érték a jobb
- minden páncél kap egy módosítót ami lehet
    - 8% eséllyel (+) enhanced (elvarázsolt: a védelem javul +1..+3-mal)
    - 72% eséllyel (n) normal (normál: nincs módosító)
    - 20% eséllyel (-) cursed (átkozott: a védelem romlik -1..-3-mal)
- átkozott páncélt nem lehet levenni, csak miután a "remove curse" scroll-lal levesszük az átkot róla (a negatív értékek ezután is megmaradnak a páncélon)

5. staff - Pálcák/botok (14 típus)
    Név	                                    Esély	Hatás
    light - Fény                            12%	    Kivilágítja a szobát
    invisibility - Láthatatlanná tétel      6%	    A szörny láthatatlanná válik
    lightning - Villám	                    3%	    6d6 sebzés, visszapattan a falakról
    fire - Tűz	                            3%	    6d6 sebzés, visszapattan a falakról
    cold - Fagy	                            3%	    6d6 sebzés, visszapattan a falakról
    polymorph - Átalakítás	                15%	    Más szörnnyé változtatja
    magic missile - Mágikus lövedék	        10%	    1d4 sebzés
    haste monster - Gyorsítás (szörny)	    10%	    A szörnyet gyorsítja
    slow monster - Lassítás (szörny)	    11%	    A szörnyet lassítja
    drain life - Életerő-elszívás	        9%	    Elszívja a saját HP-d felét, ugyanannyit von le minden közeli szörnytől
    nothing - Semmi	                        1%	    Teljesen hatástalan
    teleport away - Elteleportálás	        6%	    A szörnyet máshova teleportálja
    teleport to - Magamhoz-teleportálás	    6%	    A szörnyet magadhoz rántja
    cancellation - Képesség-eltörlés	    5%	    Elveszi a szörny speciális képességét

6. ring - Gyűrűk (14 típus)
    Név	                                Esély	Étel/kör	Hatás
    protection - Védelem	            9%	    +1	        Jobb páncél és mentődobás
    add strength - Erőnövelés	        9%	    +1	        Nagyobb erő
    sustain strength - Erő-fenntartás	5%	    +1	        Véd a méreg/kígyó erővesztése ellen
    searching - Keresés	                10%	    −3	        Segít csapdát/titkos ajtót találni
    see invisible - Láthatatlan-látás	10%	    −5	        Látod a Fantomokat
    adornment - Dísz	                1%	    0	        Csak 10 arany értékű, nincs hatása
    aggravate monster - Felbőszítés	    10%	    0	        Mindig átkozott - a szörnyek agresszívabbak lesznek
    dexterity - Ügyesség	            8%	    −3	        Jobb találati esély
    increase damage - Sebzésnövelés	    8%	    −3	        Nagyobb sebzés
    regeneration - Regeneráció	        4%	    +2	        +1 HP/kör
    slow digestion - Lassú emésztés	    9%	    −2	        ~50%-kal kevesebb étel fogy (két ilyen gyűrű kioltja az éhezést)
    teleportation - Teleportálás	    5%	    0	        Mindig átkozott - véletlenszerűen teleportál a térképen
    stealth - Lopakodás	                7%	    +1	        Nem ébreszted fel az alvó szörnyeket
    maintain armor - Páncél-fenntartás	5%	    +1	        Véd az Aquator rozsdásítása ellen
- bal és jobb kézebn lehet gyűrűt hordani
- hatás + étel-fogyasztás
- a negatív "étel/kör" azt jelenti: a gyűrű ad étel-tartalékot, nem fogyaszt
- van 4 gyűrű amik lehetnek enhanced (+1 vagy +2) vagy cursed (-1) ami úgy dől el hogy mod=random(0..2) és ha 0 akkor mod=-1
    - protection
    - add strength
    - dexterity
    - increase damage
- van 2 gyűrű ami mindig cursed, de nem módósítanak semmilyen statot
    - aggravate monster
    - teleportation
- a cursed gyűrűket nem lehet levenni csak ha már levettük róluk az átkot

7. food - Étel
- A játékos gyomra max. 2000 egység ételt tárolhat.
    - 300 alatt: éhes lesz
    - 150 alatt: gyenge lesz
    - Negatívba fordulva: ájuldozik
    - −850 alatt: éhenhal
- Étkezéskor 1100–1500 közötti véletlen mennyiség kerül a játékos gyomrába.
- 90% eséllyel "sima" étel (70%-ban rossz ízű, de ez nem árt, sőt XP-t ad!), 10%-ban "finom" gyümölcs.
- Biztonsági háló: ha 3 szinten át nem generálódott étel, a következő tárgygenerálás kényszerítve étel lesz.



## tárolás / általános mezők

Az eredeti Rogue-ban minden tárgy ugyanazt a fix méretű rekordot használja, mint amit a hős/szörny is - csak más mezőnevekkel:

    type      - kategória (POTION, SCROLL, WEAPON, ARMOR, RING, STICK, FOOD, GOLD, AMULET)
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

- eredetileg minden tárgy tartalmazza az összes mezőt...
