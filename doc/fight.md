# harc

- játékos támadás
    találat = d20 + fegyver_támadás_módosító + str_plus[erő]
    str_plus[] = { -7, -6, -5, -4, -3, -2, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  3 };

    sikeres támadás: találat >=  (20 − támadó_szintje) − ellenfél_páncélja

    sebzés = fegyver_sebzés + fegyver_sebzés_módosító + add_dam[erő]
    add_dam[] = { -7, -6, -5, -4, -3, -2, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,  1,  2,  3,  3,  4,  5,  5,  5,  5,  5,  5,  5,  5,  5,  6 };

    hp -= sebzés
    halál = hp <= 0

- szörny támadása ugyanaz, de
        - fegyver_támadás_módosító = 0 (nincs fegyvere)
        - erő = 10 -> str_plus[erő] = 0
    azaz többnyire csak egy sima d20 dobás

- alvó/fogva tartott (nem "futó" állapotú) célpont ellen +4 bónusz jár a találathoz
- a védekező páncélja:
    - ha a játékos védekezik: a ténylegesen felszerelt páncél értéke (nem a pstats.arm) mínusz a viselt
        gyűrűk (Védelem gyűrű) bónusza
    - ha a szörny védekezik: egyszerűen a szorny_arm

- ha a szorny_dmg "/"-lel elválasztott több kockacsoportot tartalmaz (pl. sárkánynál "1x8/1x8/3x10"), mindegyik szegmensre KÜLÖN találat-dobás és KÜLÖN sebzés-dobás történik

    speciális mellékhatások (csak akkor, ha a szörny talál):
        A (aquator)      -> a játékos páncélja rozsdásodik (a páncél védelme 1-gyel romlik)
                            - bőrpáncélt nem lehet rozsdásítani
                            - ha a páncél védelme már elérte a lehetséges legrosszabb szintet (azaz ac >= 9), nincs több hatás
                            - a Páncélvédelem tekercs (ISPROT) vagy a Páncél-fenntartás gyűrű teljesen blokkolja (a rozsda "lepereg")
                            - a rozsdásodás nem távolítja el a páncélt, csak véglegesen gyengíti, amíg vissza nem bűvölöd (fegyver-/páncélbűvölő tekerccsel)
        I (ice monster)  -> a játékos egy időre lefagy, mozgás/cselekvés kimarad
        R (rattlesnake)  -> sikertelen mentődobás esetén a játékos ereje csökken
        W (wraith)       -> esély van rá hogy a játékos veszít egy szintet
        V (vampire)      -> esély van rá hogy a játékos maximum HP-ja csökken
        F (venus flytrap)-> a játékost fogva tartja, és a fogvatartás sebzése körönként nő
                            (ha a szörny NEM talál, de már fogva tart, akkor is jár a folyamatos sebzés)
        L (leprechaun)   -> aranyat lop a játékostól, utána eltűnik a pályáról
        N (nymph)        -> egy véletlen mágikus tárgyat lop a csomagból, utána eltűnik a pályáról
