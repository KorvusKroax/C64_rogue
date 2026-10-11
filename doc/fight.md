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



sikeres varázsmentődobás: 1d20 >= 17 - floor(jatekos_szint / 2) - (protection gyűrűk ha vannak)

sikeres méreg elleni mentődobás: 1d20 >= 14 - floor(jatekos_szint / 2)



## A hajítás szabályai

- minden tárgy dobható, de csak a fegyvereknek, botoknak/pálcáknak van sebzése
- Ha a dobott tárgy eltalálja a szörnyet, végleg elvész. Mellé, falnak vagy ajtónak dobva a fall() a közelbe teszi, és ha nincs szabad mező, "vanishes as it hits the ground" üzenettel elvész.


(`hurldmg`, launcher, `ISMISL`, íj bónuszai) és a dobott tárgy sorsa (találat után elfogy, mellé/falnak esetén `fall()`, hely nélkül "vanishes").
