# harc

- játékos támadás
    találat = random(0..19) + fegyver_támadás_módosító + str_plus[erő]
    str_plus[] = { -7, -6, -5, -4, -3, -2, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  3 };

    sikeres támadás: találat >=  (20 − támadó_szintje) − ellenfél_páncélja

    sebzés = fegyver_sebzés + fegyver_sebzés_módosító + add_dam[erő]
    add_dam[] = { -7, -6, -5, -4, -3, -2, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,  1,  2,  3,  3,  4,  5,  5,  5,  5,  5,  5,  5,  5,  5,  6 };

    A Dexterity (támadásnál) és Increase damage (sebzésnél) gyűrűk csak akkor számít, ha van kézben támadó fegyver, fegyver nélküli ütésnél és dobásnál nem.

    hp -= sebzés
    halál = hp <= 0
    a szörny halálakor növekszik a játékos xp-je

- szörny támadása ugyanaz, de
        - fegyver_támadás_módosító = 0 (nincs fegyvere)
        - erő = 10 -> str_plus[erő] = 0
    azaz többnyire csak egy sima d20 dobás



- alvó/fogva tartott (nem ISRUN állapotú) célpont ellen +4 bónusz jár a találathoz (játékos támadásra ez gyakorlatilag nem igaz mert a még támadás legelején a szörny ISRUN-t kap és törli az ISHELD-jét)
- a védekező páncélja:
    - ha a játékos védekezik: a ténylegesen felszerelt páncél értéke mínusz a viselt gyűrűk (Védelem gyűrű) bónusza
    - a védekező játékos páncélja páncél nélkül 10
    - ha a szörny védekezik: egyszerűen a szorny_arm

- ha a szorny_dmg "/"-lel elválasztott több kockacsoportot tartalmaz (pl. sárkánynál "1x8/1x8/3x10"), mindegyik szegmensre KÜLÖN találat-dobás és KÜLÖN sebzés-dobás történik



## hajítás lépései

1. Irány. A t parancs először irányt kér (which direction?).
    - Elfogadja a h j k l y u b n billentyűket kis- és nagybetűvel, minden más billentyűre újra kérdez. Az ESC kilép (nem veszi el a kört a játékostól)
    - Zavarodott állapotban (ISHUH) 20% eséllyel a megadott irány helyett véletlen irány lesz (a 8 irány egyike, helyben maradás nincs)

2. Tárgy. Ezután kérdezi, melyik tárgyat dobod (which object do you want to throw? (* for list)).
    - A kód bármelyik csomagbeli tárgy betűjét elfogadja
    - A tárgytípus csak a * listát szűri (az fegyvereket mutat).
    - bármilyen tárgyat el lehet dobni: bájitalt, tekercset, ételt, gyűrűt, pálcát, páncélt, sőt magát az Amulettet is. Az ESC kilép (nem veszi el a kört a játékostól)

3. Viselt vagy kézben tartott tárgy
    - Ha a tárgyat nem használod éppen, mehet.
    - Ha használod, de átkozott, akkor a játék közli, hogy "you can’t. It appears to be cursed", és nem dobható. A kód ilyenkor nem adja vissza a lépést, vagyis a sikertelen kísérlet is elviszi a körödet.
    - Ha használod, de nem átkozott, akkor a játék leveszi rólad (fegyvert a kézből, páncélt időveszteséggel, gyűrűt a hatásával együtt), és utána el tudod dobni.

4. Kivétel a csomagból.
    - Ha több darabod van (nyílvessző, tőr), a kupacból egy darab másolat kerül ki, a kupac eggyel csökken. Ha csak egy darab van, az kikerül, és a csomagbeli betűjele felszabadul.

5. Repülés.
    - A tárgy a hős mezőjéből indul, és lépésenként halad az irányban. A mozgás közbeni rajzolás csak akkor történik meg, ha a játékos látja a mezőt, és nincs "terse" mód.
    - Addig repül, amíg a következő mező járható és nem ajtó. Távolságkorlát nincs.
    - A megállási mező az akadály mezője lesz: fal, ajtó vagy szörny.

6. Megállás. Ha nincs ott szörny, a tárgy leesik (lásd a 9. pontot). Ha van, támadás következik.

7. Találat és sebzés. Ugyanaz a harci szabály fut, mint közelharcnál, a dobott tárgy adataival:
    - Találat: d20 + a tárgy hplus értéke + az erő-bónusz, a szokásos küszöb ellen. Ha a szörny alszik vagy nem üldöz, +4 jár.
    - Sebzés: kocka + a tárgy dplus értéke + az erő-bónusz. Hogy melyik kockát használja, az a tárgytól függ:

Dobott tárgy	                                                    Sebzési kocka	            Extra
Nyílvessző, és a hozzá való íj van a kezedben	                    hajítási (2x3)	            az íj hplus/dplus bónusza is hozzáadódik
Nyílvessző íj nélkül	                                            közelharci (1x1)	        nincs
Tőr, lándzsa, dobótőr, shuriken, buzogány stb. (nem kell kilövő)	hajítási kocka	            csak a saját bónuszai
Nem fegyver (a pályán generált bájital, tekercs stb.)	            0x0, vagyis nulla kocka	    csak az erő-bónusz (Erő 7–15 között ez 0, 16–17-nél +1, 18-nál +2, 19–20-nál +3)

8. Következmények találatnál.
    - A szörny felébred és üldözni kezd, a nyugodt gyógyulásod megszakad.
    - Ha érvényben van a "monster confusion" hatás (CANHUH), a dobott találat is összezavarja a szörnyet, és a hatás elhasználódik.
    - Ha egy még le nem leplezett Xerocra dobsz, a játék közli, hogy "wait! That's a xeroc!". Hajításnál a dobás ezután is lefut (közelharcnál ilyenkor véget ér a lépés).

9. Hová kerül a tárgy.
    - Találat esetén sehová: a tárgy elfogy, nem esik le.
    - Mellényúlásnál vagy falnak, ajtónak ütközve a megállási mező 3×3-as környezetéből választ egyenletes eséllyel egy padló- vagy folyosómezőt. A hős saját mezője kimarad. Ha nincs ilyen mező, a tárgy "vanishes as it hits the ground" üzenettel eltűnik.



## mentődobások
- sikeres varázsmentődobás: 1d20 >= 17 - floor(jatekos_szint / 2) - (protection gyűrűk ha vannak)
- sikeres méreg elleni mentődobás: 1d20 >= 14 - floor(jatekos_szint / 2)
