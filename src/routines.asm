*=$c000

SCREEN_MEM  = $0400
COLOR_MEM   = $d800

screenPointer  = $fb
colorPointer  = $fd

tlx_var   = $c700
tly_var   = $c701
brx_var   = $c702
bry_var   = $c703
chr_var   = $c704
col_var   = $c705

width_var = $c706
bry_p1    = $c707





fillRect_char:
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
loop_row:
    ; set screen pointer to row + x
        lda screen_lo,x
        clc
        adc tlx_var
        sta screenPointer
        lda screen_hi,x
        adc #$00
        sta screenPointer+1

        ldy #$00
loop_column:
        lda chr_var
        sta (screenPointer),y
        iny
        cpy width_var
        bne loop_column

        inx
        cpx bry_p1
        bne loop_row
        rts

screen_lo:
        !for i, 0, 24 { !byte <(SCREEN_MEM + i*40) }
screen_hi:
        !for i, 0, 24 { !byte >(SCREEN_MEM + i*40) }





fillRect_color:
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
loop_row1:
    ; set color pointer to row + x
        lda color_lo,x
        clc
        adc tlx_var
        sta colorPointer
        lda color_hi,x
        adc #$00
        sta colorPointer+1

        ldy #$00
loop_column1:
        lda col_var
        sta (colorPointer),y
        iny
        cpy width_var
        bne loop_column1

        inx
        cpx bry_p1
        bne loop_row1
        rts

color_lo:
        !for i, 0, 24 { !byte <(COLOR_MEM + i*40) }
color_hi:
        !for i, 0, 24 { !byte >(COLOR_MEM + i*40) }
