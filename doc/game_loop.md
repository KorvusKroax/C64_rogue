## játék menet
- dungeon szint generálás
    - szobák és folyosók generálása
    - tárgyak/kincsek elhelyezése a szint szobáiban
    - csapdák elhelyezése a szinten egy szobában
    - kezdeti szörnyek generálása és elhelyezése a szinten
    - lépcső elhelyezése a szinten egy szobában
    - kincses szoba kijelölése és feltötlése tárgyakkal, kincsekkel és szörnyekkel
- játékos létrehozása és elhelyezése
- loop
    - sebesség loop (ha a játékos gyorsított akkor 2szer fut le ez a rész)
        - látótér frissítés
        - státusz sor frissítés
        - képernyő kirajzolás
        - játékos input bekérés (itt addig állunk amíg nem kapunk valamit)
            - végrehajtás
    - szörnyek mozgása
    - játékos hp regen kezelése
    - játékos éhség kezelése
    - vándorló szörny generálás
    - egyéb aktív effektek (pl. bájitalhatás, mérgezés, stb)
    - gyűrű effektek (keresés/teleport ellenőrzés)






## szörnyek mozgása
- egy szörny csak akkor mozog/cselekszik, ha "felébredt" és üldözi a játékost (ISRUN flag) - alvó/nem észlelt szörny egyáltalán nem lép
    - a szörnyek a szobában akkor ébredhetnek fel ha a játékos belép vagy elhagyja a szobát, vagy ha a 8 szomszédos mező valamélyikén áll a játékos körül
        - felébred ha
            - még nem fut (ISRUN)
            - 2/3 esély (random(0..2) != 0) bejön
            - nincs fogva tartva (ISHELD)
            - a játékos nem visel nincs Stealth gyűrűt
            - a játékos nem lebeg
        - vagy ha ISGREED
    - a vándorló szörnyek azonnal tudják hogy hol van a játékos és elindulnak felé
- a sebesség nem fix típus-tulajdonság, hanem állapotfüggő
    - normál: 1 lépés/kör
    - lassítva: csak minden második körben lép (0.5 lépés/kör)
    - gyorsítva (pl. automatikusan minden szörny a 29. dungeon szint fölött): 2 lépés/kör
    - fogva tartva (pl. Fogvatartás tekercstől): 0 lépés/kör
    - repülő szörnyek (denevér, vércse, griff): ha a játékostól a tavolsag^2 >= 3 akkor kapnak egy plusz lépést is ebben a körben (gyorsabban utolérik, aztán közelről normál sebességre váltanak)
- nem tudnak egymáson átmenni, de kincsekre/tárgyakra rá tudnak lépni
- célpont meghatározása
    - alapesetben a játékos pozíciója a célpont
    - ha a szörny tud tárgyat hordani (Hordoz % > 0), nincs a játékos szobájában, és nem is látja a játékost, akkor inkább egy, a saját szobájában heverő tárgy felé indul (Csak szobaváltáskor és tárgy felvétele után hívódik, nem folyamatosan)
        - amikor odaér, felveszi (bekerül a saját tárgylistájába, eltűnik a padlóról)
        - utána újra célpontot választ: ha van még másik, senki más által nem célzott tárgy a szobájában, elindul afelé is - így egymás után TÖBB tárgyat is összeszedhet
        - két szörny sosem indul ugyanazon tárgy felé egyszerre
        - amint nincs több felvehető tárgy a szobájában, meglátja a játékost (de csak miután felvette a tárgyat), onnantól a játékost kezdi üldözni
    - A tárgyra tartó szörny a játékos általi felvételkor átáll a játékosra.
- mozgás (szobában és folyosón is UGYANAZZAL az algoritmussal, nincs külön "folyosót követő" logika - az a játékos "run" parancsának a viselkedése)
    - ha a célpont más szobában van mint a szörny, először nem a célpont nyers (x,y) koordinátája felé indul, hanem a saját szobájának ahhoz a kijáratához (ajtajához), amelyik a legközelebb van a célponthoz
    - ha már a célponttal egy szobában van (vagy folyosón/ajtóban áll), a tényleges célpont felé indul
    - a 8 szomszédos (átlós is) mező közül azt választja, amelyik a legjobban csökkenti a távolságot a célponttól
        - átlós lépés csak akkor engedélyezett, ha nem "vág be" egy fal sarkán (mindkét szomszédos oldal-mezőnek is járhatónak kell lennie)
        - több egyenértékű (azonos távolságú) jó mező esetén véletlenszerűen választ közülük
        - ha egyik szomszédos mező sem közelebbi vagy azonos távolságra lévő, inkább nem lép (helyben marad)
- kivételek
    - zavarodott (ISHUH) szörny véletlenszerű irányba mozog
    - a Denevér 50%-ban, a Fantom 20%-ban MINDIG véletlenszerűen mozog egy kört, a zavarodottságtól függetlenül (ez a beépített "kaotikus" mozgásuk)
    - a Sárkány, ha egy vonalban van a játékossel és lőtávolságon (6 mező) belül van, mozgás helyett 1/5 eséllyel tűzokádás-sugarat lő
- Szörnyek nem lépnek Xeroc és scare-monster mezőre.



## játékos hp regen kezelés
- egy regen_szamlalo 1gyel nő minden körben
- ha jatekos_szint < 8
    - ha regen_szamlalo + 2 * jatekos_szint > 20 akkor a játékos hp-ja 1gyel növekszik és nullázzuk a regen_szamlalo értékét
- ha jatekos_szint >= 8
    - minden 3dik kör után (regen_szamlamo >= 3) a játékos visszakap random(1..jatekos_szint-7) hp-t és a regen_szamlalo nullázódik
- ha van regen gyűrű azok mindkét kézen külön-külön 1gyel növelik a hp-t körönként és nullázzák regen_szamlalo-t
- a regen_szamlalo nullázódik harcnál és minden HP-változásnál
- max_hp fölé sosem mehet



## játékos éhség kezelése
- A játékos gyomra max. 2000 egység ételt tárolhat
- alapból körönként 1 egység fogy, de ha már megvan az amulett (hátizsákban ott van) akkor ez 0 körönként
- minden gyűrű (bal/jobb kéz) a táblázat szerint módosítja tovább
- éhségállapot küszöbök:
    - 300 alá esik: "éhes" leszel
    - 150 alá esik: "gyenge" leszel
    - 0 vagy kevesebb: minden körben 20% eséllyel elájulsz random(4..11) körre
    - −850 alatt: éhen halsz
- minden éhség állapotváltáskor az ISRUN állapot megszűnik, az evés nem állítja vissza (bug?) csak ha elájul (nem tud csinálni semmit)
- ISRUN állapot visszaáll amikor az ájulás időtartalma lejár (akkor is ha még mindig 300 alatt van (bug?))
- Étkezéskor 1100..1499 közötti véletlen mennyiség kerül a játékos gyomrába.
    - evés előtt a negatív éhségállapot 0-ra áll
    - 10%-ban "finom" gyümölcs
    - 90% eséllyel "sima" étel
        - ilyenkor 29%-ban (rnd(100) > 70) rossz ízű, de ártalmatlan, viszont 1 XP jár érte


## keresés parancs
- ajtó 1/5, csapda 1/2, rejtett folyosó 1/3, hallucinációnál +3, vakságnál +2 a nevezőbe

// nm * random(0.95f..1.05f)
int spread(int nm) {
    return nm - nm / 20 + rnd(nm / 10);
}
