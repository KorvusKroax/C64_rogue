*=$c000

SCREEN_MEM  = $0400
COLOR_MEM   = $d800
MAP_MEM     = $8000

screenPointer   = $fb
mapPointer      = $fd

tlx_var     = $c700
tly_var     = $c701
brx_var     = $c702
bry_var     = $c703

col_var     = $c704

width_var   = $c705
bry_final      = $c706

plx_var     = $c707
ply_var     = $c708

x_var       = $c709
y_var       = $c70a
y_final     = $c70b



; look-up tables for rows of screen and color memory
rowScreen_hi:
    !for i, 0, 24 { !byte >(SCREEN_MEM + i*40) }
rowColor_hi:
    !for i, 0, 24 { !byte >(COLOR_MEM + i*40) }
rowMap_hi:
    !for i, 0, 24 { !byte >(MAP_MEM + i*40) }
row_lo:
    !for i, 0, 24 { !byte <(COLOR_MEM + i*40) }





;----------------------------------------------------------------------------------------------------
clearMap:
    ldx #$00
    lda #$20
loop_clear:
    sta MAP_MEM,x
    sta MAP_MEM+$100,x
    sta MAP_MEM+$200,x
    sta MAP_MEM+$2e8,x
    inx
    bne loop_clear

    rts

;----------------------------------------------------------------------------------------------------
drawRoom:
    lda brx_var             ; calculating width
    sec
    sbc tlx_var
    sta width_var

    ldx tly_var             ; starting row -> x reg

    lda row_lo,x            ; drawing first (top) horizontal walls
    clc
    adc tlx_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1

    ldy #$00
    lda #$70                ; upper-left corner char
    sta (mapPointer),y

    iny
    lda #$43                ; horizontal wall char
loop_firstDrawColumn:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_firstDrawColumn

    lda #$6e                ; upper-right corner char
    sta (mapPointer),y

    inx
loop_drawRow:
    lda row_lo,x
    clc
    adc tlx_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1

    ldy #$00                ; inner rows
    lda #$42                ; first vertical wall char
    sta (mapPointer),y
    iny
    lda #$2e                ; room floor char (.)
loop_drawColumn:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_drawColumn
    lda #$42                ; last vertical wall char
    sta (mapPointer),y

    inx
    cpx bry_var
    bne loop_drawRow

    lda row_lo,x            ; drawing last (bottom) horizontal walls
    clc
    adc tlx_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1

    ldy #$00
    lda #$6d                ; bottom-left corner char
    sta (mapPointer),y

    iny
    lda #$43                ; horizontal wall char
loop_lastDrawColumn:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_lastDrawColumn

    lda #$7d                ; bottom-right corner char
    sta (mapPointer),y
    rts





;----------------------------------------------------------------------------------------------------
lightUp_room:
    lda brx_var             ; calculate width
    sec
    sbc tlx_var
    clc
    adc #$01
    sta width_var

    lda bry_var             ; setting last row + 1
    sta bry_final
    inc bry_final

    ldx tly_var
loop_showRow:
    lda row_lo,x
    clc
    adc tlx_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1

    lda row_lo,x
    clc
    adc tlx_var
    sta screenPointer
    lda rowScreen_hi,x
    adc #$00
    sta screenPointer+1

    ldy #$00
loop_showColumn:
    lda (mapPointer),y
    sta (screenPointer),y
    iny
    cpy width_var
    bne loop_showColumn

    inx
    cpx bry_final
    bne loop_showRow
    rts





;----------------------------------------------------------------------------------------------------
lightUp_corridor:
    lda plx_var
    sta x_var
    dec x_var

    lda ply_var
    sta y_var
    dec y_var

    lda ply_var
    sta y_final
    inc y_final
    inc y_final

    ldx y_var
loop_lightUpCorridorRow:
    lda row_lo,x
    clc
    adc x_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1

    lda row_lo,x
    clc
    adc x_var
    sta screenPointer
    lda rowScreen_hi,x
    adc #$00
    sta screenPointer+1

    ldy #$00
loop_lightUpCorridorColumn:
    lda (mapPointer),y
    cmp #$23                ; corridor (#)
    beq lightUpCorridorPos
    cmp #$2b                ; door (+)
    bne next_lightUpCorridorPos

lightUpCorridorPos:
    sta (screenPointer),y

next_lightUpCorridorPos:
    iny
    cpy #$03
    bne loop_lightUpCorridorColumn

    inx
    cpx y_final
    bne loop_lightUpCorridorRow
    rts





;----------------------------------------------------------------------------------------------------
lightUp_playerArea:
    lda plx_var
    sta x_var
    dec x_var

    lda ply_var
    sta y_var
    dec y_var

    lda ply_var
    sta y_final
    inc y_final
    inc y_final

    ldx y_var
loop_lightUpPlayerAreaRow:
    lda row_lo,x
    clc
    adc x_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1

    lda row_lo,x
    clc
    adc x_var
    sta screenPointer
    lda rowScreen_hi,x
    adc #$00
    sta screenPointer+1

    ldy #$00
loop_lightUpPlayerAreaColumn:
    lda (mapPointer),y
    sta (screenPointer),y
    iny
    cpy #$03
    bne loop_lightUpPlayerAreaColumn

    inx
    cpx y_final
    bne loop_lightUpPlayerAreaRow
    rts
