## általános statok:
    	játékosnál	                            szörnynél
str	    erő, fegyverbónuszhoz	                ritkán változik, de számít pl. Rattlesnake mérgénél
exp	    jelenlegi tapasztalat	                mennyi XP-t kapsz, ha megölöd
lvl	    karakterszint	                        hit dice / nehézségi szint - ez megy be a támadás értékbe at_lvl-ként
arm	    páncél (a felszerelt tárgy felülírja)   a szörny natúr páncélértéke
dmg     fegyver nélküli ütés sebzése ("1x2")	több támadás is lehet egyszerre, /-lel elválasztva (pl. egy sárkánynál karom/karom/harapás)
hpt     jelenlegi életpont                      ugyanaz
maxhp	életpont	                            ugyanaz

pos     aktuális koordináta (x,y)               ugyanaz
room    aktuális szoba                          ugyanaz
flags   állapotjelzők (bitflagek)               ugyanaz
pack    tárgylista (max 23 tárgy)               ugyanaz

oldch   mi volt a mezőn mielőtt ráállt          ugyanaz

## szörnyek extra statjai
name        a szörny neve
carry       mekkora eséllyel kap egy tárgyat generáláskor
dest        hova igyekszik (a játékos pozíciója, vagy egy a szinten heverő tárgy pozíciója)
disguise    mimic (Xeroc) esetén mire hasonlít, egyébként megegyezik a típusával
turn        ha le van lassítva, ez a kör számít-e nála

## szörnyek alap statjai
        name	                            carry	    flags	                str	    exp	     lvl    arm	    dmg             special attack
A	    aquator (vízi lény)	                0%	        ISMEAN	                10	    20	     5	    2	    0x0/0x0         páncélt rozsdásít (max 9ig, de bőr páncélra nincs hatása)
B	    bat (denevér)	                    0%	        ISFLY	                10	    1	     1	    3	    1x2             véletlenszerű irányokba röpköd
C	    centaur (kentaur)	                15%	        -	                    10	    17	     4	    4	    1x2/1x5/1x5
D	    dragon (sárkány)	                100%	    ISMEAN	                10	    5000	 10	    −1	    1x8/1x8/3x10    nagy távolságú "6d6" láng támadás -> ha 1d20 < 17 - pancel_vedelem - int(szint / 2)
E	    emu	                                0%	        ISMEAN	                10	    2	     1	    7	    1x2
F	    venus flytrap (légyfogó)	        0%	        ISMEAN	                10	    80	     8	    3	    %%%x0           fogva tart / 0 a sebzése, de növekszik körönként 1gyel
G	    griffin (griff)	                    20%	        ISMEAN, ISFLY, ISREGEN	10	    2000	 13	    2	    4x3/3x5
H	    hobgoblin	                        0%	        ISMEAN	                10	    3	     1	    5	    1x8
I	    ice monster (jégszörny)	            0%	        -	                    10	    5	     1	    9	    0x0             fagyasztás -> ha 1d20 < 14 - int(szint / 2) ^ 2
J	    jabberwock	                        70%	        -	                    10	    3000	 15	    6	    2x12/2x4
K	    kestrel (vércse)	                0%	        ISMEAN, ISFLY	        10	    1	     1	    7	    1x4
L	    leprechaun	                        0%	        -	                    10	    10	     3	    8	    1x1             aranyat lop a játékostól -> ha 1d20 < 17 - pancel_vedelem - int(szint / 2)
M	    medusa	                            40%	        ISMEAN	                10	    200	     8	    2	    3x4/3x4/2x5     összezavarás -> ha 1d20 < 17 - pancel_vedelem - int(szint / 2) -> csak egyszer próbálkozik, ha nem sikerül a mentődobás a juátékos ISHUH lesz ami spread(20) (19..20) körig hat
N	    nymph	                            100%	    -	                    10	    37	     3	    9	    0x0             használaton kívül lévő varázstárgyakat lop a játékostól
O	    orc (ork)	                        15%	        ISGREED	                10	    5	     1	    6	    1x8
P	    phantom (fantom)	                0%	        ISINVIS	                10	    120	     8	    3	    4x4
Q	    quagga	                            0%	        ISMEAN	                10	    15	     3	    3	    1x5/1x5
R	    rattlesnake (csörgőkígyó)	        0%	        ISMEAN	                10	    9	     2	    3	    1x6             csökkenti a játékos erejét -> ha 1d20 < 14 - int(szint / 2) ^ 2
S	    snake (kígyó)	                    0%	        ISMEAN	                10	    2	     1	    5	    1x3
T	    troll	                            50%	        ISREGEN, ISMEAN	        10	    120	     6	    4	    1x8/1x8/2x6
U	    black unicorn (fekete unikornis)	0%	        ISMEAN	                10	    190	     7	    −2	    1x9/1x9/2x9
V	    vampire (vámpír)	                20%	        ISREGEN, ISMEAN	        10	    350	     8	    1	    1x10            30% esély hogy csökkenti a játékos maxhp-ját random(1..3)-mal
W	    wraith (kísértet)	                0%	        -	                    10	    55	     5	    4	    1x6             15% esély a szintelszívásra -> 1-gyel csökken a szint és 1d10-zel csökken a maxhp, 0. szint halált okoz
X	    xeroc	                            30%	        -	                    10	    100	     7	    7	    4x4             egy tárgynak mutatja magát
Y	    yeti	                            30%	        -	                    10	    50	     4	    6	    1x6/1x6
Z	    zombie	                            0%          ISMEAN	                10	    6	     2	    8	    1x8
- az alacsonyabb páncél (arm) érték a jobb
- ha egy szörnynek van carry esélye, és nem a játékos szobájában van, és nem látja a játékost, akkor random(0..99) < carry eséllyel egy padlón heverő tárgy felé indul, és felveszi azt a csomagjába, amikor odaér

## flag-ek (bitflagek)
- játékos flag-jei
    CANHUH      zavarást tud okozni (ráteszi a ISHUH flag-et)
    CANSEE      látja a láthatatlan lényeket
    ISBLIND     vakság -> stagnáló, nem frissülő térkép
    ISLEVIT     lebegés -> nincs hatása a csapdáknak amikor a játékos rálép, és az alvó ISMEAN szörnyek NEM ébrednek fel a szobába lépéskor (ugyanaz a feltétel-kivétel, mint a lopakodás-gyűrűnél)
    ISHALU      hallucinálás -> minden körben újrarajzolja a látható mezőket és véletlenszerű betűkkel jeleníti meg a szörnyeket és a tárgyakat - tisztán vizuális hatás, a SEEMONST-ra is hat (850 kör)
    SEEMONST    érzékeli a szörnyeket a falakon kerszetül is (inverzen jelennek meg ammik egyébként nem látszanának), de az ISINVIS szörnyek ekkor sem látszanak (ahhoz CANSEE kell), ha nincs mit mutatni ez az üzenet: "you have a strange/normal feeling for a moment, then it passes"

    ISHUH       zavarodott -> véletlenszerű mozogás, 80% eséllyel a szándékolt irány felülíródik azaz dir_x=random(-1..1), dir_y=random(-1..1) ha több hatás van, időtartalmak összeadódnak
    ISHASTE     fel van gyorsítva - 2 lépés/kör
    ISHELD      fogva van tartva (elkapta egy Venus Flytrap) -> nem tud ellépni a mezőről ahol áll amíg a flytrap meg nem hal (harcolni, tárgyat használni, stb lehet)

- szörnyek flag-jei
    ISMEAN      alszik -> a szobába lépő játékos ha nem ISLEVIT és nincs stealth gyűrűje sem akkor random(0..2)!=0 esetén felébreszti és az ISRUN flag bekapcsolódik
    ISFLY       repül -> miután megtette a normál lépését, ha még mindig elég messze van a játékostól, MÉG EGYSZER lép ugyanabban a körben
    ISREGEN     regenerálódik a HP-ja -> minden harci kör végén 33% eséllyel +1 HP-t kap
    ISGREED     kapzsi -> amíg van arany a szobában addíg az aranyra megy előbb, nem a játékosra (ork)
    ISINVIS     láthatatlan -> csak akkor látszik ha a CANSEE aktív
    ISRUN       éppen üldözi a játékost ("felébredt", ez indítja el a mozgást egyáltalán)
    ISSLOW      le van lassítva -> csak minden MÁSODIK körben cselekszik
    ISCANC      speciális képessége ki van kapcsolva (Staff of Cancellation)
    ISFOUND     már észlelte/felfedezte a játékost (vagyis ez a szörny MÁR EGYSZER elsütötte a speciális képességét)
    ISTARGET    ez a szörny a célpontja a játékos 'f' (harc a halálig) parancsának

    ISHUH       zavarodott - véletlenszerű mozogás (ugyanaz mint a játékosnál)
    ISHASTE     fel van gyorsítva - 2 lépés/kör - 29. szint fölött automatikusan minden szörny megkapja
    ISHELD      fogva van tartva (Hold Monster tekercstől) - ilyenkor egyáltalán nem mozog



## játékos generálás
- minden esetben ezek az induló statok:
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

- XP a következő szinthez: 10, 20, 40, 80, 160, 320, 640, 1300, 2600, 5200, 13000, 26000, 50000, 100000, 200000, 400000, 800000, 2000000, 4000000, 8000000
- szintlépéskor növekszik a hpt és a maxhp is ROLL(uj_szint - regi_szint, 10) -> ez általában ROLL(1, 10), de előfordulhat hogy több szintet lép egyszerre, üzenet: "welcome to level <new_lvl>"



## szörny generálás
- két szörny generálási lista van
    - kezdeti_szornyek[] = {'K','E','B','S','H','I','R','O','Z','L','C','Q','A','N','Y','F','T','W','P','X','U','M','V','G','J','D'}
    - vandorlo_szornyek[] = {'K','E','B','S','H',0,'R','O','Z',0,'C','Q','A',0,'Y',0,'T','W','P',0,'U','M','V','G','J',0}

- a vándorló szörny spread(70) (azaz 67..73) kör mulva elindul egy ellenörzés
    - minden 4. körben megnézzük hogyha random(1..6) == 4 akkor generálódik egy vándorló szörny
    - generálás után a körszámláló reset-elődik majd a következő random(56..84) kör mulva újra kezdődik a 4 körönkénti ellenőrzés
    - bármelyik járható (folyosó, padló - bármi, ahol lehet állni) mezőre lehelyeződhet de sosem abban a szobába ahol a játékos van éppen

1. szörny típus kiválasztás
    - szorny_index = jelenlegi_dungeon_szint + (random(0..9) - 6)
        - ha szorny_index < 0 akkor szorny_index = random(0..4)
        - ha szorny_index > 25 akkor szorny_index = random(0..4) + 21
    - ha a kiválasztott szörny értéke 0 (a vándorló szörnyek esetében lehetséges) akkor új szorny_index-et választunk
    - type = a kiválasztott szörny típus a megfelelő (kezdeti vagy vándorló) lista valamelyikéből
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
