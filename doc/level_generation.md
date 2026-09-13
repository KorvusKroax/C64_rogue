# dungeon generálás

1. 3x3 szektor beállítása a képernyő mérete alapján
    - eredetileg mind a 9 szektor egyforma kiterjedésű terület (már amennyire lehet)

2. kitaláljuk hogy melyik szektorban legyen fantom szoba
    - fantom_szobak_szama = random(0..3)

3. végigmegyünk a szektorokon és szobákká alakítjuk őket
    1. ha a szektor fantom szoba lesz
        - választunk a szektoron belül egy tetszőleges mezőt, azt beállítjuk a szoba bal_felso_sarok értékének -> ide egy folyosó fog kerülni
    2. ha nem fantom szoba lesz
        - a bal_felso_sarok és a jobb_also_sarok felveszi a szektor méreteit -1 mező minden irányból hogy legyen legalább egy mező két szoba közt a folyosóknak
            - uj_bal_felso_sarok = random(bal_felso_sarok..(jobb_also_sarok - 2 * minimum_belso_faltavolsag))
            - uj_jobb_also_sarok = random(uj_bal_felso_sarok..(jobb_also_sarok - minimum_belso_faltavolsag))
    3. kitaláljuk hogy ez egy sötét szoba vagy sem
        - sotetseg_flag = random(0..9) < jelenlegi_dungeon_szint - 1
            - ha ez egy sötét szoba akkor még kiderítjük hogy ez valójában egy labirintus szoba vagy sem
                - labirintus_flag = random(0..14) == 0 (ilyenkor törlődik az "összes" szoba flag is)
    4. ha labirintus szoba lesz
        - ...

4. összekötjük a szobákat (és fantom szobákat) folyosókkal
    - ...

5. a dungeon szintet feltöltjük tárgyakkal
    - 9 alkalommal próbálunk 36% eséllyel letenni tárgyakat egy dungeon szinten a szobák szabad padló mezőire

6. teszünk a szint szobáiba aranyat
    - 50% esély van arra hogy arany kerül a szobába
        - de csak akkor ha még nincs meg az amulett
        - vagy ha már megvan akkor csak ha a jelenlegi (az éppen generálódó) szint nagyobb vagy egyenlő mint az eddig elért legnagyobb dungeon szint
    - mennyiség: random(0..(50 + 10 * jelenlegi_szint)) + 2

7. generálunk a szobákba szörnyeket
    - ha van arany egy szobában akkor 80% esélyel
    - ha nincs akkor 25% esélyel

8. lépcső kijelölése a szinten
    - véletlenszerűen kiválasztunk egy szobát ami lehet labirintus szoba is de nem lehet fantom szoba
    - kiválasztunk egy tetszőleges padló mezőt vagy folyosó mezőt, ha a ez egy labirintus szoba
    - a lépcsőről lehet menni felfelé is, de csak ha már megvan az amulett
    - a lépcsőről mindig egy új dungeon szintre jut a játékos, bármelyik irányba is megy

9. kincses szoba kijelölése
    - 5% esély van rá hogy lesz a szinten egy kincses szoba
    - ha van a kincses szoba
        1. kiszámoljuk hogy mennyi a hely van ahová kerülhet tárgy
            - minimum_kincsek_szama = 2
            - maximum_kincsek_szama = 10
            - lehetseges_poziciok_szama = MIN(szoba_belso_terulete, maximum_kincsek_szama) - minimum_kincsek_szama
        2. megállapítjuk hogy mennyi tárgy legyen a szobában
            - targyak_szama = random(0..lehetseges_poziciok_szama-1) + minimum_kincsek_szama
        3. legeneráljuk és letesszük a tárgyakat/kincseket
        4. megállapítjuk hogy mennyi szörny legyen a szobában
            - szornyek_szama = random(0..lehetseges_poziciok_szama-1) + 2
            - szornyek_szama = MAX(szornyek_szama, (targyak_szama + 2))
            - szornyek_szama = MIN(szornyek_szama, szoba_belso_terulete)
            - minden tárgyhoz kötelezően tartozik egy szörny amit úgy generálunk le mintha a következő szintre sorsolnánk ki (azaz jelenlegi_szint + 1-gyel hívjuk a generálást)
        5. legeneráljuk és letesszük a szörnyeket

10. szobák összekötése
    - minimális összeköttetés, hogy minden szoba elérhető legyen
        1. kiválasztunk egy kiinduló szobát
            - beletesszük egy "visited" listába
            - megjelöljük hogy "connected" vagy ilyesmi
        2. véletlenszerűen kiválasztunk a listából egy szobát (A szoba)
        3. összeszedjük egy "neighbor" listába a szoba szomszéd szobáit amik még nem "connected"-ek
            - ha nincs egy szomszéd szoba sem akkor ugrunk a 2. pontra vagy kiválasztjuk a következő szobát és ugrunk a 3. pontra
        4. véletlenszerűen kiválasztunk egyet a "neighbor" listából (B szoba)
        5. be kell állítani a kapcsolatot a két szoba közt
            - ha A szoba keletre vagy délre van a B szobához képest akkor az A szobához kell beírni a kapcsolatot
            - ha B szoba keletre vagy délre van az A szobához képest akkor a B szobához kell beírni a kapcsolatot
        6. be kell állítani hogy a B szoba is "connected" és be kell tenni a "visited" listába
        7. mindezt ismételjük a 2. ponttól amíg nem lesz minden szoba "connected" (ez 8 kör a loop-ban)
    - további, de nem kötelező összeköttetések, hogy lehessen több útvonal egy-egy szobához
        1. véletlenszerűen válasszunk ki egy szobát
        2. véletlenszerűen válasszuk ki és jelöljük be kapcsolatnak
            - vagy a keleti irányt (ha lehet)
            - vagy a déli irányt (ha lehet)
            - vagy egyiket sem
        3. ismételjük az 1. ponttól ugyanezt 3-szor

11. map lerajzolása
    - végigloop-olunk az összes szobán (két külön loop)
        1. szobák berajzolása
            - ha ez egy fantom szoba
                - teszünk egy folyosó karaktert a szoba bal_felso_sarok pozíciójába
            - ha ez nem fantom szoba
                - berajzoljuk a falakat és kitöltjük a belső részt padló karakterrel
        2. folyosók berajzolása
            - ha a szobából van keletre folyosó akkor meghívjuk a horizontális folyosó rajzolást
            - ha a szobából van délre (is) folyosó akkor meghívjuk a vertikális folyosó rajzolást
            - folyosó rajzolás (horizontális vagy vertikális)
                1. beállítjuk az A (jelenlegi) és B (szomszéd) szobákat
                2. kiválasztjuk az ajtók helyét a két szoba egymás felé néző falain
                    - ha valamelyik egy fantom szoba akkor ott ez a mező a jobb_felso_sarok
                    - amelyik nem fantom szoba ott erre a mezőre berajzolunk egy ajtót a falra
                3. berajzoljuk a két mező közti folyosót
                    - ha ugyanabban a sorban(horizontális) vagy oszlopban(vertikális) vannak, húzunk egy egyenes folyosót
                    - ha nem ugyanabban a sorban(horizontális) vagy oszlopban(vertikális) vannak, Z formályú folyosót húzunk
                        - ehhez választani kell egy véletlenszerű oszlopot(horizontális) vagy sort(vertikális) a két szoba közt ahol a folyosó elfordul
