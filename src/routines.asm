*=$c000

SCREEN_MEM      = $0400
MAP_MEM         = $8000

screenPointer   = $fb
mapPointer      = $fd

tlx_var     = $c700
tly_var     = $c701
brx_var     = $c702
bry_var     = $c703

width_var   = $c704

plx_var     = $c705
ply_var     = $c706

x_var       = $c707
x2_var      = $c708
y_var       = $c709
y2_var      = $c70a
mx_var      = $c70b
my_var      = $c70c

tmp_var     = $c710



row_lo:
    !for i, 0, 24 { !byte <(SCREEN_MEM + i*40) }
rowScreen_hi:
    !for i, 0, 24 { !byte >(SCREEN_MEM + i*40) }
rowMap_hi:
    !for i, 0, 24 { !byte >(MAP_MEM + i*40) }



vertical_wall_char:         !byte $42
horizontal_wall_char:       !byte $43
upper_left_corner_char:     !byte $70
upper_right_corner_char:    !byte $6e
bottom_left_corner_char:    !byte $6d
bottom_right_corner_char:   !byte $7d
floor_char:     !byte $2e   ; (.)
staircase_char: !byte $25   ; (%)
door_char:      !byte $2b   ; (+)
corridor_char:  !byte $23   ; (#)

gold_char:      !byte $2a   ; (*)

player_char:    !byte $00   ; (@)





;---------------------------------------------------------------------------------------------------
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



;---------------------------------------------------------------------------------------------------
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



;---------------------------------------------------------------------------------------------------
set_mapPointer:
    lda row_lo,x
    clc
    adc x_var
    sta mapPointer
    lda rowMap_hi,x
    adc #$00
    sta mapPointer+1
    rts



;---------------------------------------------------------------------------------------------------
set_screenPointer:
    lda row_lo,x
    clc
    adc x_var
    sta screenPointer
    lda rowScreen_hi,x
    adc #$00
    sta screenPointer+1
    rts



;---------------------------------------------------------------------------------------------------
draw_room:
    lda brx_var
    sec
    sbc tlx_var
    sta width_var

    ldx tly_var

    lda tlx_var
    sta x_var

    jsr set_mapPointer          ; first row (top horizontal wall)
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
    jsr set_mapPointer          ; inner rows
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

    jsr set_mapPointer          ; last row (bottom horizontal wall)
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



draw_room_toScreen:
    lda brx_var
    sec
    sbc tlx_var
    sta width_var

    ldx tly_var

    lda tlx_var
    sta x_var

    jsr set_screenPointer          ; first row (top horizontal wall)
    ldy #$00
    lda upper_left_corner_char
    sta (screenPointer),y
    iny
    lda horizontal_wall_char
loop_toScreen_firstDrawColumn:
    sta (screenPointer),y
    iny
    cpy width_var
    bne loop_toScreen_firstDrawColumn
    lda upper_right_corner_char
    sta (screenPointer),y

    inx
loop_toScreen_drawRow:
    jsr set_screenPointer          ; inner rows
    ldy #$00
    lda vertical_wall_char
    sta (screenPointer),y
    iny
    lda floor_char
loop_toScreen_drawColumn:
    sta (screenPointer),y
    iny
    cpy width_var
    bne loop_toScreen_drawColumn
    lda vertical_wall_char
    sta (screenPointer),y
    inx
    cpx bry_var
    bne loop_toScreen_drawRow

    jsr set_screenPointer          ; last row (bottom horizontal wall)
    ldy #$00
    lda bottom_left_corner_char
    sta (screenPointer),y
    iny
    lda horizontal_wall_char
loop_toScreen_lastDrawColumn:
    sta (screenPointer),y
    iny
    cpy width_var
    bne loop_toScreen_lastDrawColumn
    lda bottom_right_corner_char
    sta (screenPointer),y
    rts



;---------------------------------------------------------------------------------------------------
draw_straightHorizontalCorridor:
    lda x2_var
    sec
    sbc x_var
    clc
    adc #$01
    sta width_var

    ldx y_var
    jsr set_mapPointer

    ldy #$00
    lda corridor_char
loop_straightHorizontalCorridor:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_straightHorizontalCorridor
    rts



draw_straightHorizontalCorridor_toScreen:
    lda x2_var
    sec
    sbc x_var
    clc
    adc #$01
    sta width_var

    ldx y_var
    jsr set_screenPointer

    ldy #$00
    lda corridor_char
loop_toScreen_straightHorizontalCorridor:
    sta (screenPointer),y
    iny
    cpy width_var
    bne loop_toScreen_straightHorizontalCorridor
    rts



;---------------------------------------------------------------------------------------------------
draw_zShapedHorizontalCorridor:
    lda mx_var                                          ; first part of the corridor
    sec
    sbc x_var
    clc
    adc #$01
    sta width_var

    ldx y_var
    jsr set_mapPointer
    ldy #$00
    lda corridor_char
loop_zShapedHorizontalCorridor_h:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_zShapedHorizontalCorridor_h

    lda x2_var                                          ; last part of the corridor
    sec
    sbc mx_var
    clc
    adc #$01
    sta width_var

    ldx y2_var
    lda mx_var
    sta x_var
    jsr set_mapPointer
    ldy #$00
    lda corridor_char
loop_zShapedHorizontalCorridor_h2:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_zShapedHorizontalCorridor_h2

    lda y_var                                           ; middle part of the corridor
    cmp y2_var
    bcc check_horizontal_mid_length
    ldx y2_var                      ; swap y and y2
    sta y2_var
    stx y_var
check_horizontal_mid_length:
    ldx y_var
    inx
    cpx y2_var
    beq draw_zShapedHorizontalCorridor_done

    ldy #$00
loop_zShapedHorizontalCorridor_v:
    jsr set_mapPointer
    lda corridor_char
    sta (mapPointer),y
    inx
    cpx y2_var
    bne loop_zShapedHorizontalCorridor_v
draw_zShapedHorizontalCorridor_done:
    rts



draw_zShapedHorizontalCorridor_toScreen:
    lda mx_var                                          ; first part of the corridor
    sec
    sbc x_var
    clc
    adc #$01
    sta width_var

    ldx y_var
    jsr set_screenPointer
    ldy #$00
    lda corridor_char
loop_toScreen_zShapedHorizontalCorridor_h:
    sta (screenPointer),y
    iny
    cpy width_var
    bne loop_toScreen_zShapedHorizontalCorridor_h

    lda x2_var                                          ; last part of the corridor
    sec
    sbc mx_var
    clc
    adc #$01
    sta width_var

    ldx y2_var
    lda mx_var
    sta x_var
    jsr set_screenPointer
    ldy #$00
    lda corridor_char
loop_toScreen_zShapedHorizontalCorridor_h2:
    sta (screenPointer),y
    iny
    cpy width_var
    bne loop_toScreen_zShapedHorizontalCorridor_h2

    lda y_var                                           ; middle part of the corridor
    cmp y2_var
    bcc check_toScreen_horizontal_mid_length
    ldx y2_var                      ; swap y and y2
    sta y2_var
    stx y_var
check_toScreen_horizontal_mid_length:
    ldx y_var
    inx
    cpx y2_var
    beq draw_toScreen_zShapedHorizontalCorridor_done

    ldy #$00
loop_toScreen_zShapedHorizontalCorridor_v:
    jsr set_screenPointer
    lda corridor_char
    sta (screenPointer),y
    inx
    cpx y2_var
    bne loop_toScreen_zShapedHorizontalCorridor_v
draw_toScreen_zShapedHorizontalCorridor_done:
    rts



;---------------------------------------------------------------------------------------------------
draw_straightVerticalCorridor:
    inc y2_var
    ldy #$00
    ldx y_var
loop_straightVerticalCorridor:
    jsr set_mapPointer
    lda corridor_char
    sta (mapPointer),y
    inx
    cpx y2_var
    bne loop_straightVerticalCorridor
    rts



draw_straightVerticalCorridor_toScreen:
    inc y2_var
    ldy #$00
    ldx y_var
loop_toScreen_straightVerticalCorridor:
    jsr set_screenPointer
    lda corridor_char
    sta (screenPointer),y
    inx
    cpx y2_var
    bne loop_toScreen_straightVerticalCorridor
    rts



;---------------------------------------------------------------------------------------------------
draw_zShapedVerticalCorridor:
    inc my_var                                          ; first part of the corridor
    ldy #$00
    ldx y_var
loop_zShapedVerticalCorridor_v:
    jsr set_mapPointer
    lda corridor_char
    sta (mapPointer),y
    inx
    cpx my_var
    bne loop_zShapedVerticalCorridor_v
    dec my_var

    inc y2_var                                          ; last part of the corridor
    lda x_var
    sta tmp_var
    lda x2_var
    sta x_var
    ldx my_var
loop_zShapedVerticalCorridor_v2:
    jsr set_mapPointer
    lda corridor_char
    sta (mapPointer),y
    inx
    cpx y2_var
    bne loop_zShapedVerticalCorridor_v2
    lda tmp_var
    sta x_var

    lda x_var                                           ; mid part of the corridor
    cmp x2_var
    bcc check_vertical_mid_length
    ldx x2_var                      ; swap x and x2
    sta x2_var
    stx x_var
check_vertical_mid_length:
    ldx x_var
    inx
    cpx x2_var
    beq draw_zShapedVerticalCorridor_done

    lda x2_var
    sec
    sbc x_var
    clc
    adc #$00
    sta width_var

    ldx my_var
    jsr set_mapPointer
    ldy #$01
    lda corridor_char
loop_zShapedVerticalCorridor_h:
    sta (mapPointer),y
    iny
    cpy width_var
    bne loop_zShapedVerticalCorridor_h
draw_zShapedVerticalCorridor_done:
    rts



draw_zShapedVerticalCorridor_toScreen:
    inc my_var                                          ; first part of the corridor
    ldy #$00
    ldx y_var
loop_toScreen_zShapedVerticalCorridor_v:
    jsr set_screenPointer
    lda corridor_char
    sta (screenPointer),y
    inx
    cpx my_var
    bne loop_toScreen_zShapedVerticalCorridor_v
    dec my_var

    inc y2_var                                          ; last part of the corridor
    lda x_var
    sta tmp_var
    lda x2_var
    sta x_var
    ldx my_var
loop_toScreen_zShapedVerticalCorridor_v2:
    jsr set_screenPointer
    lda corridor_char
    sta (screenPointer),y
    inx
    cpx y2_var
    bne loop_toScreen_zShapedVerticalCorridor_v2
    lda tmp_var
    sta x_var

    lda x_var                                           ; mid part of the corridor
    cmp x2_var
    bcc check_toScreen_vertical_mid_length
    ldx x2_var                      ; swap x and x2
    sta x2_var
    stx x_var
check_toScreen_vertical_mid_length:
    ldx x_var
    inx
    cpx x2_var
    beq draw_toScreen_zShapedVerticalCorridor_done

    lda x2_var
    sec
    sbc x_var
    clc
    adc #$00
    sta width_var

    ldx my_var
    jsr set_screenPointer
    ldy #$01
    lda corridor_char
loop_toScreen_zShapedVerticalCorridor_h:
    sta (screenPointer),y
    iny
    cpy width_var
    bne loop_toScreen_zShapedVerticalCorridor_h
draw_toScreen_zShapedVerticalCorridor_done:
    rts



;---------------------------------------------------------------------------------------------------
lightOn_room:
    lda brx_var
    sec
    sbc tlx_var
    clc
    adc #$01
    sta width_var

    inc bry_var

    ldx tly_var

    lda tlx_var
    sta x_var
loop_showRow:
    jsr set_mapPointer
    jsr set_screenPointer
    ldy #$00
loop_showColumn:
    lda (mapPointer),y
    sta (screenPointer),y
    iny
    cpy width_var
    bne loop_showColumn

    inx
    cpx bry_var
    bne loop_showRow
    rts



;---------------------------------------------------------------------------------------------------
lightOn_corridor:
    lda plx_var
    sta x_var
    dec x_var

    lda ply_var
    sta y2_var
    inc y2_var
    inc y2_var

    ldx ply_var
    dex
loop_lightOnCorridorRow:
    jsr set_mapPointer
    jsr set_screenPointer
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
    cpx y2_var
    bne loop_lightOnCorridorRow
    rts



;---------------------------------------------------------------------------------------------------
lightOn_playerArea:
    lda plx_var
    sta x_var
    dec x_var

    lda ply_var
    sta y2_var
    inc y2_var
    inc y2_var

    ldx ply_var
    dex
loop_lightOnPlayerAreaRow:
    jsr set_mapPointer
    jsr set_screenPointer
    ldy #$00
loop_lightOnPlayerAreaColumn:
    lda (mapPointer),y
    sta (screenPointer),y
    iny
    cpy #$03
    bne loop_lightOnPlayerAreaColumn

    inx
    cpx y2_var
    bne loop_lightOnPlayerAreaRow
    rts



;---------------------------------------------------------------------------------------------------
lightOff_playerArea:
    lda plx_var
    sta x_var
    dec x_var

    lda ply_var
    sta y2_var
    inc y2_var
    inc y2_var

    ldx ply_var
    dex
loop_lightOffPlayerAreaRow:
    jsr set_mapPointer
    jsr set_screenPointer
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
    cpx y2_var
    bne loop_lightOffPlayerAreaRow
    rts
