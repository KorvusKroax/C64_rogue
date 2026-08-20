*=$c000

SCREEN_MEM      = $0400
COLOR_MEM       = $d800

MAP_MEM         = $8000

screenPointer   = $fb
mapPointer      = $fd

tlx_var     = $c700
tly_var     = $c701
brx_var     = $c702
bry_var     = $c703

col_var     = $c704

width_var   = $c705
bry_final   = $c706

plx_var     = $c707
ply_var     = $c708
dx_var      = $c709
dy_var      = $c70a

x_var       = $c710
y_var       = $c711
y_final     = $c712



row_lo:
    !for i, 0, 24 { !byte <(SCREEN_MEM + i*40) }
rowScreen_hi:
    !for i, 0, 24 { !byte >(SCREEN_MEM + i*40) }
rowMap_hi:
    !for i, 0, 24 { !byte >(MAP_MEM + i*40) }



player_char:    !byte $00   ; (@)

corridor_char:  !byte $23   ; (#)
staircase_char: !byte $25   ; (%)
door_char:      !byte $2b   ; (+)
floor_char:     !byte $2e   ; (.)

vertical_wall_char:         !byte $42
horizontal_wall_char:       !byte $43
upper_left_corner_char:     !byte $70
upper_right_corner_char:    !byte $6e
bottom_left_corner_char:    !byte $6d
bottom_right_corner_char:   !byte $7d





;----------------------------------------------------------------------------------------------------
showFullMap:
    ldx #$06
loop_fullMapShow:
    lda MAP_MEM-6,x
    sta SCREEN_MEM-6,x
    lda MAP_MEM-6+$fa,x
    sta SCREEN_MEM-6+$fa,x
    lda MAP_MEM-6+$1f4,x
    sta SCREEN_MEM-6+$1f4,x
    lda MAP_MEM-6+$2ee,x
    sta SCREEN_MEM-6+$2ee,x
    inx
    bne loop_fullMapShow
    rts



;----------------------------------------------------------------------------------------------------
clearMap:
    ldx #$06
    lda #$20
loop_mapClear:
    sta MAP_MEM-6,x
    sta MAP_MEM-6+$fa,x
    sta MAP_MEM-6+$1f4,x
    sta MAP_MEM-6+$2ee,x
    inx
    bne loop_mapClear
    rts



;----------------------------------------------------------------------------------------------------
drawRoom:
    lda brx_var
    sec
    sbc tlx_var
    sta width_var

    ldx tly_var

    lda row_lo,x                ; first row (top horizontal wall)
    clc
    adc tlx_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1

    ldy #$00
    lda upper_left_corner_char
    sta (mapPointer),y
    iny
    lda horizontal_wall_char
loop_firstDrawColumn:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_firstDrawColumn
    lda upper_right_corner_char
    sta (mapPointer),y

    inx
loop_drawRow:
    lda row_lo,x                ; inner rows
    clc
    adc tlx_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1

    ldy #$00
    lda vertical_wall_char
    sta (mapPointer),y
    iny
    lda floor_char
loop_drawColumn:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_drawColumn
    lda vertical_wall_char
    sta (mapPointer),y

    inx
    cpx bry_var
    bne loop_drawRow

    lda row_lo,x            ; last row (bottom horizontal wall)
    clc
    adc tlx_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1

    ldy #$00
    lda bottom_left_corner_char
    sta (mapPointer),y
    iny
    lda horizontal_wall_char
loop_lastDrawColumn:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_lastDrawColumn
    lda bottom_right_corner_char
    sta (mapPointer),y

    rts



;----------------------------------------------------------------------------------------------------
lightOn_room:
    lda brx_var
    sec
    sbc tlx_var
    clc
    adc #$01
    sta width_var

    lda bry_var
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
lightOn_corridor:
    lda plx_var
    sta x_var
    dec x_var

    lda ply_var
    sta y_final
    inc y_final
    inc y_final

    ldx ply_var
    dex
loop_lightOnCorridorRow:
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
loop_lightOnCorridorColumn:
    lda (mapPointer),y
    cmp corridor_char
    beq lightOnCorridorPos
    cmp door_char
    bne next_lightOnCorridorPos

lightOnCorridorPos:
    sta (screenPointer),y

next_lightOnCorridorPos:
    iny
    cpy #$03
    bne loop_lightOnCorridorColumn

    inx
    cpx y_final
    bne loop_lightOnCorridorRow
    rts



;----------------------------------------------------------------------------------------------------
lightOn_playerArea:
    lda plx_var
    sta x_var
    dec x_var

    lda ply_var
    sta y_final
    inc y_final
    inc y_final

    ldx ply_var
    dex
loop_lightOnPlayerAreaRow:
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
loop_lightOnPlayerAreaColumn:
    lda (mapPointer),y
    sta (screenPointer),y
    iny
    cpy #$03
    bne loop_lightOnPlayerAreaColumn

    inx
    cpx y_final
    bne loop_lightOnPlayerAreaRow
    rts





;----------------------------------------------------------------------------------------------------
lightOff_playerArea:
    lda plx_var
    sta x_var
    dec x_var

    lda ply_var
    sta y_final
    inc y_final
    inc y_final

    ldx ply_var
    dex
loop_lightOffPlayerAreaRow:
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
loop_lightOffPlayerAreaColumn:
    lda (mapPointer),y

    cmp floor_char
    bne next_pos

    lda #$20
    sta (screenPointer),y
next_pos:
    iny
    cpy #$03
    bne loop_lightOffPlayerAreaColumn

    inx
    cpx y_final
    bne loop_lightOffPlayerAreaRow
    rts
