*=$c000

SCREEN_MEM  = $0400
COLOR_MEM   = $d800

screenPointer   = $fb
colorPointer    = $fd

tlx_var     = $c700
tly_var     = $c701
brx_var     = $c702
bry_var     = $c703

col_var     = $c704

width_var   = $c705
bry_p1      = $c706

plx_var     = $c707
ply_var     = $c708

npx_var     = $c709
npy_var     = $c70a
npy_p1      = $c70b




drawRoom:
    ; calc width
        lda brx_var
        sec
        sbc tlx_var
        sta width_var

        ldx tly_var

    ; first horizontal walls
        lda screen_lo,x
        clc
        adc tlx_var
        sta screenPointer
        lda screen_hi,x
        adc #$00
        sta screenPointer+1

        ldy #$00
        lda #$70                ; upper-left corner
        sta (screenPointer),y

        iny
        lda #$43                ; horizontal wall (-)
loop_firstCharColumn:
        sta (screenPointer),y
        iny
        cpy width_var
        bne loop_firstCharColumn

        lda #$6e                ; upper-right corner
        sta (screenPointer),y

        inx
loop_charRow:
    ; set screen pointer to row + x
        lda screen_lo,x
        clc
        adc tlx_var
        sta screenPointer
        lda screen_hi,x
        adc #$00
        sta screenPointer+1

    ; inner rows
        ldy #$00
        lda #$42                ; first vertical wall (|)
        sta (screenPointer),y
        iny
        lda #$2e                ; room floor (.)
loop_charColumn:
        sta (screenPointer),y
        iny
        cpy width_var
        bne loop_charColumn
        lda #$42                ; last vertical wall (|)
        sta (screenPointer),y

        inx
        cpx bry_var
        bne loop_charRow

    ; last horizontal walls
        lda screen_lo,x
        clc
        adc tlx_var
        sta screenPointer
        lda screen_hi,x
        adc #$00
        sta screenPointer+1

        ldy #$00
        lda #$6d                ; bottom-left corner
        sta (screenPointer),y

        iny
        lda #$43                ; horizontal wall (-)
loop_lastCharColumn:
        sta (screenPointer),y
        iny
        cpy width_var
        bne loop_lastCharColumn

        lda #$7d                ; bottom-right corner
        sta (screenPointer),y

        rts

screen_lo:
        !for i, 0, 24 { !byte <(SCREEN_MEM + i*40) }
screen_hi:
        !for i, 0, 24 { !byte >(SCREEN_MEM + i*40) }





fillColor:
    ; calc width
        lda brx_var
        sec
        sbc tlx_var
        clc
        adc #$01
        sta width_var
    ; set last row
        lda bry_var
        sta bry_p1
        inc bry_p1

        ldx tly_var
loop_colorRow:
    ; set color pointer to row + x
        lda color_lo,x
        clc
        adc tlx_var
        sta colorPointer
        lda color_hi,x
        adc #$00
        sta colorPointer+1

        ldy #$00
        lda col_var
loop_colorColumn:
        sta (colorPointer),y
        iny
        cpy width_var
        bne loop_colorColumn

        inx
        cpx bry_p1
        bne loop_colorRow
        rts

color_lo:
        !for i, 0, 24 { !byte <(COLOR_MEM + i*40) }
color_hi:
        !for i, 0, 24 { !byte >(COLOR_MEM + i*40) }





lightUp_corridor:
        lda plx_var
        sta npx_var
        dec npx_var

        lda ply_var
        sta npy_var
        dec npy_var

        lda ply_var
        sta npy_p1
        inc npy_p1
        inc npy_p1

        ldx npy_var
loop_lightUpCorridorRow:
        lda screen_lo,x
        clc
        adc npx_var
        sta screenPointer
        lda screen_hi,x
        adc #$00
        sta screenPointer+1

        lda color_lo,x
        clc
        adc npx_var
        sta colorPointer
        lda color_hi,x
        adc #$00
        sta colorPointer+1

        ldy #$00
loop_lightUpCorridorColumn:
        lda (screenPointer),y
        cmp #$23                ; corridor (#)
        beq lightUpCorridorPos
        cmp #$2b                ; door (+)
        bne next_lightUpCorridorPos

lightUpCorridorPos:
        lda #$01                ; white
        sta (colorPointer),y

next_lightUpCorridorPos:
        iny
        cpy #$03
        bne loop_lightUpCorridorColumn

        inx
        cpx npy_p1
        bne loop_lightUpCorridorRow

        rts
