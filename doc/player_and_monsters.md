## általános statok:
    	játékosnál	                            szörnynél
str	    erő, fegyverbónuszhoz	                ritkán változik, de számít pl. Rattlesnake mérgénél
exp	    jelenlegi tapasztalat	                mennyi XP-t kapsz, ha megölöd
lvl	    karakterszint	                        hit dice / nehézségi szint - ez megy be a támadás értékbe at_lvl-ként
arm	    páncél (a felszerelt tárgy felülírja)   a szörny natúr páncélértéke
dmg     fegyver nélküli ütés sebzése ("1x2")	több támadás is lehet egyszerre, /-lel elválasztva (pl. egy sárkánynál karom/karom/harapás)
hpt     jelenlegi életpont                      jelenlegi életpont
maxhp	életpont	                            életpont

pos     aktuális koordináta (x,y)               ...
room    aktuális szoba                          ...
flags   állapotjelzők (bitflagek)               ...
pack    tárgylista (max 23 tárgy)               tárgylista (nincs rá limit a kódban, de gyakorlatban sosem sok)

oldch   mi volt a mezőn mielőtt ráállt          ...

## szörnyek extra statjai
name        a szörny neve
carry       mekkora eséllyel kap egy tárgyat (Hordoz %) generáláskor
dest        hova igyekszik (a játékos pozíciója, vagy egy a szintjén heverő tárgy pozíciója)
disguise    mimic (Xeroc) esetén mire hasonlít, egyébként megegyezik a típusával
turn        ha le van lassítva, ez a kör számít-e nála

## szörnyek alap statjai
        name	                            carry	    flags	                str	    exp	    lvl	    arm	    dmg             special attack
A	    aquator (vízi lény)	                0%	        ISMEAN	                10	    20	     5	    2	    0x0/0x0         able to rust armor
B	    bat (denevér)	                    0%	        ISFLY	                10	    1	     1	    3	    1x2             flitters in random directions
C	    centaur (kentaur)	                15%	        -	                    10	    17	     4	    4	    1x2/1x5/1x5
D	    dragon (sárkány)	                100%	    ISMEAN	                10	    5000	 10	    −1	    1x8/1x8/3x10    has long range "6d6" flame attack (note 3)
E	    emu	                                0%	        ISMEAN	                10	    2	     1	    7	    1x2
F	    venus flytrap (légyfogó)	        0%	        ISMEAN	                10	    80	     8	    3	    %%%x0           holds / damage increases (note 1)
G	    griffin (griff)	                    20%	        ISMEAN, ISFLY, ISREGEN	10	    2000	 13	    2	    4x3/3x5
H	    hobgoblin	                        0%	        ISMEAN	                10	    3	     1	    5	    1x8
I	    ice monster (jégszörny)	            0%	        -	                    10	    5	     1	    9	    0x0             freezes (note 2)
J	    jabberwock	                        70%	        -	                    10	    3000	 15	    6	    2x12/2x4
K	    kestrel (vércse)	                0%	        ISMEAN, ISFLY	        10	    1	     1	    7	    1x4
L	    leprechaun	                        0%	        -	                    10	    10	     3	    8	    1x1             steals gold (note 3)
M	    medusa	                            40%	        ISMEAN	                10	    200	     8	    2	    3x4/3x4/2x5     confuses (note 3)
N	    nymph	                            100%	    -	                    10	    37	     3	    9	    0x0             steals unused magic item
O	    orc (ork)	                        15%	        ISGREED	                10	    5	     1	    6	    1x8             runs towards gold
P	    phantom (fantom)	                0%	        ISINVIS	                10	    120	     8	    3	    4x4             invisible
Q	    quagga	                            0%	        ISMEAN	                10	    15	     3	    3	    1x5/1x5
R	    rattlesnake (csörgőkígyó)	        0%	        ISMEAN	                10	    9	     2	    3	    1x6             reduces strength (note 2)
S	    snake (kígyó)	                    0%	        ISMEAN	                10	    2	     1	    5	    1x3
T	    troll	                            50%	        ISREGEN, ISMEAN	        10	    120	     6	    4	    1x8/1x8/2x6
U	    black unicorn (fekete unikornis)	0%	        ISMEAN	                10	    190	     7	    −2	    1x9/1x9/2x9
V	    vampire (vámpír)	                20%	        ISREGEN, ISMEAN	        10	    350	     8	    1	    1x10            30% to reduce max HP by 1..3
W	    wraith (kísértet)	                0%	        -	                    10	    55	     5	    4	    1x6             15% change to drain level (note 4)
X	    xeroc	                            30%	        -	                    10	    100	     7	    7	    4x4             imitates an object
Y	    yeti	                            30%	        -	                    10	    50	     4	    6	    1x6/1x6
Z	    zombie	                            0%          ISMEAN	                10	    6	     2	    8	    1x8

- itt az alacsonyabb páncél (arm) érték a jobb
- megjegyzések
    note 1: The F (venus flytrap) does no damage at first. However, the damage increases by 1 each turn being held.
    note 2: The special attack has a 1d20 saving throw where the value needed to save is: 14 - int(experence_level/2)^2.
    note 3: The special attack has a 1d20 saving throw where the value needed to save is: 17 - armor_class - int(experence_level/2).
    note 4: The special attack removed 1d10 from player maximum HP, and reduces experence_level by 1. 0 experence_level causes death.

## flag-ek (bitflagek)
- játékos flag-jei
    CANHUH      zavarást tud okozni a következő találatig (Szörny-zavarás tekercstől)
    CANSEE      látja a láthatatlan lényeket (Láthatatlan-látás bájitaltól)
    ISBLIND     vak (Vakság bájitaltól)
    ISLEVIT     lebeg (Levitáció bájitaltól)
    ISHALU      hallucinál (Hallucináció bájitaltól)
    SEEMONST    érzékeli a rejtett/láthatatlan szörnyeket is (Szörny-észlelés bájitaltól)

    ISHUH       zavarodott (Zavarodottság bájitaltól, vagy egy Medúza pillantásától)
    ISHASTE     fel van gyorsítva - 2 lépés/kör (Gyorsítás bájitaltól)
    ISHELD      fogva van tartva (elkapta egy Venus Flytrap) - ilyenkor egyáltalán nem mozog

- szörnyek flag-jei
    ISMEAN      a szobájába lépő játékos láttán van esélye felébredni és üldözőbe venni
    ISFLY       repül - extra lépést kaphat ha messze van a játékostől
    ISREGEN     regenerálódik a HP-ja
    ISGREED     kapzsi, az arany elfogytával azonnal a játékos után ered (ork)
    ISINVIS     eleve láthatatlan (fantom)

    ISRUN       éppen üldözi a játékost ("felébredt", ez indítja el a mozgást egyáltalán)
    ISSLOW      le van lassítva (0.5 lépés/kör)
    ISCANC      speciális képessége ki van kapcsolva (Staff of Cancellation)
    ISFOUND     már észlelte/felfedezte a játékost
    ISTARGET    ez a szörny a célpontja a játékos 'f' (harc a halálig) parancsának

    ISHUH     - zavarodott - véletlenszerűen mozog
    ISHASTE   - fel van gyorsítva - 2 lépés/kör - 29. szint fölött automatikusan minden szörny ilyen
    ISHELD    - fogva van tartva (Hold Monster tekercstől) - ilyenkor egyáltalán nem mozog

## játékos generálás
str	    16
exp	    0
lvl	    1
arm	    10	    Alap páncélérték (felszerelés nélkül)
dmg	    1x4	    Puszta kézzel ütés sebzése
hpt	    12
maxhp	12

Kezdő felszerelés:
- 1 adag étel (food_left = HUNGERTIME = 1300)
- Láncing (Ring Mail), o_arm = a_class[RING_MAIL] - 1 → automatikusan +1-es bűvölt, azonnal viselve, azonosítva (ISKNOW)
- Buzogány (Mace), +1/+1 támadás/sebzés módosító, azonnal a kézben, azonosítva
- Íj (Bow), +1 találat bónusz, a csomagban (nincs felajzva), azonosítva
- Nyílvessző (Arrow), darabszám: random(0..14) + 25 = 25-39 db véletlenszerűen, azonosítva

## szörny generálás
- két szörny generálási lista van
    - kezdeti_szornyek[] = {'K','E','B','S','H','I','R','O','Z','L','C','Q','A','N','Y','F','T','W','P','X','U','M','V','G','J','D'}
    - vandorlo_szornyek[] = {'K','E','B','S','H',0,'R','O','Z',0,'C','Q','A',0,'Y',0,'T','W','P',0,'U','M','V','G','J',0}
1. szörny típus kiválasztás
    - szorny_index = jelenlegi_dungeon_szint + (random(0..9) - 6)
        - ha szorny_index < 0 akkor szorny_index = random(0..4)
        - ha szorny_index > 25 akkor szorny_index = random(0..4) + 21
    - ha a kiválasztott szörny értéke 0 (a vándorló szörnyek esetében lehetséges) akkor új szorny_index-et választunk
    - type = a kiválasztott szörny típus a megfelelő lista valamelyikéből
2. meghatározzuk a szörny statjait
    - amulett_dungeon_szint = 26
    - stat_modosito = MAX((jelenlegi_dungeon_szint - amulett_dungeon_szint), 0)
        - ez ahhoz kell a 26 dungeon szint alatt erősebbek legyenek
    - lvl   = type.lvl + stat_modosito
    - maxhp = ROLL(lvl, 8)
        - ROLL egy kockadobás, ebben az esetben -> amennyi az előbb beállított szorny_lvl annyiszor kell dobni 8 oldalú dobókockával
    - hpt   = maxhp
    - arm   = type.arm - stat_modosito
    - dmg   = type.dmg
    - str   = type.str
    - exp   = type.exp + stat_modosito * 10 + EXPMOD(lvl, maxhp)
        - EXPMOD a szörny max hp-ját és szintjét figyelembe véve módosítja a szörny legyőzéséért kapható exp pontot
            - ha a lvl = 1 akkor a      mod = maxhp / 8
                - ha magasabb akkor     mod = maxhp / 6
            - majd ez a mod tovább szorzódik
                - ha a lvl > 9          mod *= 20
                - különben ha lvl > 6   mod *= 4
                - ha lvl <= 6           akkor nincs szorzó, a mod változatlan marad



## a szörnyek mozgása
- egy szörny csak akkor mozog/cselekszik, ha "felébredt" és üldözi a játékost (ISRUN flag) - alvó/nem észlelt szörny egyáltalán nem lép
    - felébred ha: a játékos elég közel kerül hozzá és látja/hallja, vagy Felbőszítés tekercstől (ekkor a szinten mindenki felébred), vagy ha egy "kapzsi" (pl. Ork) szörny szobájából elfogy az arany
- a sebesség nem fix típus-tulajdonság, hanem állapotfüggő
    - normál: 1 lépés/kör
    - lassítva: csak minden második körben lép (0.5 lépés/kör)
    - gyorsítva (pl. automatikusan minden szörny a 29. dungeon szint fölött): 2 lépés/kör
    - fogva tartva (pl. Fogvatartás tekercstől): 0 lépés/kör
    - repülő szörnyek (denevér, vércse, griff): ha 3-nál messzebb vannak a játékostől, kapnak egy plusz lépést is ebben a körben (gyorsabban utolérik, aztán közelről normál sebességre váltanak)
- nem tudnak egymáson átmenni, de kincsekre/tárgyakra rá tudnak lépni
- célpont meghatározása
    - alapesetben a játékos pozíciója a célpont
    - ha a szörny tud tárgyat hordani (Hordoz % > 0), nincs a játékos szobájában, és nem is látja a játékost, akkor inkább egy, a saját szobájában heverő tárgy felé indul
        - amikor odaér, TÉNYLEGESEN FELVESZI (bekerül a saját tárgylistájába, eltűnik a padlóról) - nem csak megközelíti
        - utána újra célpontot választ: ha van még másik, senki más által nem célzott tárgy a szobájában, elindul afelé is - így egymás után TÖBB tárgyat is összeszedhet
        - két szörny sosem indul ugyanazon tárgy felé egyszerre
        - amint nincs több felvehető tárgy a szobájában, vagy meglátja a játékost, onnantól a játékost kezdi üldözni
- mozgás (szobában és folyosón is UGYANAZZAL az algoritmussal, nincs külön "folyosót követő" logika - az a játékos "run" parancsának a viselkedése)
    - ha a célpont más szobában van mint a szörny, először nem a célpont nyers (x,y) koordinátája felé indul, hanem a saját szobájának ahhoz a kijáratához (ajtajához), amelyik a legközelebb van a célponthoz
    - ha már a célponttal egy szobában van (vagy folyosón/ajtóban áll), a tényleges célpont felé indul
    - a 8 szomszédos (átlós is) mező közül azt választja, amelyik a legjobban csökkenti a távolságot a célponttól
        - átlós lépés csak akkor engedélyezett, ha nem "vág be" egy fal sarkán (mindkét szomszédos oldal-mezőnek is járhatónak kell lennie)
        - több egyenértékű (azonos távolságú) jó mező esetén véletlenszerűen választ közülük
        - ha egyik szomszédos mező sem közelebbi, inkább nem lép (helyben marad)
- kivételek
    - zavarodott (ISHUH) szörny véletlenszerű irányba mozog
    - a Denevér 50%-ban, a Fantom 20%-ban MINDIG véletlenszerűen mozog egy kört, a zavarodottságtól függetlenül (ez a beépített "kaotikus" mozgásuk)
    - a Sárkány, ha egy vonalban van a játékossel és lőtávolságon (6 mező) belül van, mozgás helyett 1/5 eséllyel tűzokádás-sugarat lő
