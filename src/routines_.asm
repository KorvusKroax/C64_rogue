        *=$c000

SCREEN  = $0400
COLOR   = $d800

scrptr  = $fb
colptr  = $fd

tlx_var   = $c700
tly_var   = $c701
brx_var   = $c702
bry_var   = $c703
chr_var   = $c704
col_var   = $c705

width_var = $c706

fillRoom_insideOnly:
    ; calculate width
        lda brx_var
        sec
        sbc tlx_var
        sta width_var

        ldx tly_var
        inx
loop_row:
    ; screen pointer = current row address + x
        lda screen_lo,x
        clc
        adc tlx_var
        sta scrptr
        lda screen_hi,x
        adc #$0
        sta scrptr+1

    ; color pointer pointer = current row address + x
        lda color_lo,x
        clc
        adc tlx_var
        sta colptr
        lda color_hi,x
        adc #$0
        sta colptr+1

        ldy #$01
loop_column:
        lda chr_var
        sta (scrptr),y
        lda col_var
        sta (colptr),y
        iny
        cpy width_var
        bne loop_column

        inx
        cpx bry_var
        bne loop_row
        rts

screen_lo:
        !for i, 0, 24 { !byte <(SCREEN + i*40) }
screen_hi:
        !for i, 0, 24 { !byte >(SCREEN + i*40) }
color_lo:
        !for i, 0, 24 { !byte <(COLOR + i*40) }
color_hi:
        !for i, 0, 24 { !byte >(COLOR + i*40) }
