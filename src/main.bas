init:
    sys 57812 "routines",8,1:poke 780,0:sys 65493:rem load asm

    r=rnd(-ti):rem initialize random number generator
    tl=0:br=1:x=0:y=1:rem for readability

    dim rm(8,1,1):rem rooms in the nine (3x3) sectors
    dim rf(8):rem flags 0-phantom room, 1-has light, 4-lighted up already

    dim cn(8),vs(8),al(8),ct(3):rem temporary arrays for room connections

    poke 650,128:rem drag keypress (128-enable, 0-disable)
    poke 53280,0:poke 53281,0

reset_new_level:
    poke 646,2:rem set background color (0) to hide undiscovered dungeon parts

    seed=-int(rnd(0)*32768)-1:rem random seed
    rem seed=-18177
    r=rnd(seed):rem initialize random number generator

    rem *** reset rooms' flags ***
    for i=0 to 8
        rf(i)=2
        if rnd(1)<0.5 then rf(i)=0:rem room has no own light
    next i
    nr=int(rnd(1)*4):rem number of rooms to remove (0-3)
    if nr=0 then set_level
    for i=1 to nr
        select_room:
        r=int(rnd(1)*9)
        if (rf(r) and 1)=1 then select_room
        rf(r)=rf(r) or 1
    next i

    set_level:
    print "{clr}{dark gray}create map..."

    poke tlx_var,0   :rem tlx  ($c700)
    poke tly_var,0   :rem tly  ($c701)

    poke brx_var,39  :rem brx  ($c702)
    poke bry_var,24  :rem bry  ($c703)

    poke chr_var,46   :rem chr  ($c704)
    poke col_var,3   :rem col  ($c705)
    sys fillRect_char

    gosub create_map
    gosub draw_map
    print "{home}             "
    sys fillRect_color

    n=int(rnd(1)*9):rem room of passage to next level

    check_phantom_room:
    if (rf(n) and 1)=0 then set_next_level_passage:rem not a phantom room
    n=n+1:if n>8 then n=0
    goto check_phantom_room

    set_next_level_passage:
    nx=rm(n,tl,x)+1+int(rnd(1)*(rm(n,br,x)-rm(n,tl,x)-2))
    ny=rm(n,tl,y)+1+int(rnd(1)*(rm(n,br,y)-rm(n,tl,y)-2))
    poke 1024+nx+ny*40,37

    rem *** set player ***
    cr=int(rnd(1)*9):rem starting room

    check_starting_room:
    if (rf(cr) and 1)=0 then set_player_position:rem not a phantom room
    cr=cr+1:if cr>8 then cr=0
    goto check_starting_room

    set_player_position:
    px=rm(cr,tl,x)+1+int(rnd(1)*(rm(cr,br,x)-rm(cr,tl,x)-2))
    py=rm(cr,tl,y)+1+int(rnd(1)*(rm(cr,br,y)-rm(cr,tl,y)-2))
    gosub light_up_room

draw_player:
    p=px+py*40
    bg=peek(1024+p):rem store char under the player
    poke 1024+p,0:poke 55296+p,1:rem draw player
    if bg=35 or bg=43 then gosub light_up_corridor
    if bg=43 then gosub get_player_room:gosub light_up_room
    if bg<>35 and (rf(cr) and 16)=0 then gosub light_up_player_area

player_control:
    get a$
    if a$="w" or a$="{up}" then dx=0:dy=-1:goto check_collision:rem up
    if a$="d" or a$="{right}" then dx=1:dy=0:goto check_collision:rem right
    if a$="s" or a$="{down}" then dx=0:dy=1:goto check_collision:rem down
    if a$="a" or a$="{left}" then dx=-1:dy=0:goto check_collision:rem left
    if a$=chr$(13) then make_actions
    goto player_control

    check_collision:
    c=peek(1024+p+dx+dy*40)
    if c=46 then move_player:rem floor
    if c=35 then move_player:rem corridor
    if c=43 then move_player:rem door
    if c=37 then move_player:rem stairs to prev or next level
    goto player_control:rem colliding, no move

    move_player:
    poke 1024+p,bg:rem draw back char under the player
    px=px+dx:py=py+dy
    goto draw_player

    make_actions:
    if bg=37 then reset_new_level
    goto player_control

get_player_room:
    if py<y1 then cr=0:goto check_sector_column
    if py<y2 then cr=3:goto check_sector_column
    cr=6

    check_sector_column:
    if px<x1 then return
    if px<x2 then cr=cr+1:return
    cr=cr+2
    return

light_up_player_area:
    poke 55296+p-41,1
    poke 55296+p-40,1
    poke 55296+p-39,1
    poke 55296+p-1, 1
    poke 55296+p+1, 1
    poke 55296+p+39,1
    poke 55296+p+40,1
    poke 55296+p+41,1
    return

light_up_corridor:
    c=peek(1024+p-41):if c=35 or c=43 then poke 55296+p-41,1
    c=peek(1024+p-40):if c=35 or c=43 then poke 55296+p-40,1
    c=peek(1024+p-39):if c=35 or c=43 then poke 55296+p-39,1
    c=peek(1024+p-1) :if c=35 or c=43 then poke 55296+p-1, 1
    c=peek(1024+p+1) :if c=35 or c=43 then poke 55296+p+1, 1
    c=peek(1024+p+39):if c=35 or c=43 then poke 55296+p+39,1
    c=peek(1024+p+40):if c=35 or c=43 then poke 55296+p+40,1
    c=peek(1024+p+41):if c=35 or c=43 then poke 55296+p+41,1
    return

light_up_room:
    if (rf(cr) and 16)<>0 then return:rem light is already on
    if (rf(cr) and 2)=0 then return:rem no light
    for i=rm(cr,tl,x) to rm(cr,br,x)
        for j=rm(cr,tl,y) to rm(cr,br,y)
            poke 55296+i+j*40,1
        next j
    next i
    rf(cr)=rf(cr) or 16:rem light is on
    return



create_map:
    rem *** create sectors ***
    gs=5:rem minimum sector size (inner space)
    x0=0:rem first sector column
    x3=39:rem last sector column
    y0=0:rem first sector row
    y3=24:rem last sector row
    xs=x0+gs+1:xe=x3-gs*3-1
    x1=xs+int(rnd(1)*(xe-xs)):rem second sector column
    xs=x1+gs+1:xe=x3-gs
    x2=xs+int(rnd(1)*(xe-xs)):rem third sector column
    ys=y0+gs+1:ye=y3-gs*3-1
    y1=ys+int(rnd(1)*(ye-ys)):rem second sector row
    ys=y1+gs+1:ye=y3-gs
    y2=ys+int(rnd(1)*(ye-ys)):rem third sector row

    rem *** create rooms in sectors ***
    rm(0,tl,x)=x0+1:rm(0,br,x)=x1-1:rm(0,tl,y)=y0+1:rm(0,br,y)=y1-1
    rm(1,tl,x)=x1+1:rm(1,br,x)=x2-1:rm(1,tl,y)=y0+1:rm(1,br,y)=y1-1
    rm(2,tl,x)=x2+1:rm(2,br,x)=x3-1:rm(2,tl,y)=y0+1:rm(2,br,y)=y1-1
    rm(3,tl,x)=x0+1:rm(3,br,x)=x1-1:rm(3,tl,y)=y1+1:rm(3,br,y)=y2-1
    rm(4,tl,x)=x1+1:rm(4,br,x)=x2-1:rm(4,tl,y)=y1+1:rm(4,br,y)=y2-1
    rm(5,tl,x)=x2+1:rm(5,br,x)=x3-1:rm(5,tl,y)=y1+1:rm(5,br,y)=y2-1
    rm(6,tl,x)=x0+1:rm(6,br,x)=x1-1:rm(6,tl,y)=y2+1:rm(6,br,y)=y3-1
    rm(7,tl,x)=x1+1:rm(7,br,x)=x2-1:rm(7,tl,y)=y2+1:rm(7,br,y)=y3-1
    rm(8,tl,x)=x2+1:rm(8,br,x)=x3-1:rm(8,tl,y)=y2+1:rm(8,br,y)=y3-1

    rem *** shrink rooms ***
    gr=2:rem minimum inner gap between room walls
    for i=0 to 8
        if (rf(i) and 1)=1 then shrink_done
        xs=rm(i,tl,x):ys=rm(i,tl,y)
        xe=rm(i,br,x):ye=rm(i,br,y)

        dx=xe-xs-gr*2:dy=ye-ys-gr*2
        if dx>0 then xs=xs+int(rnd(1)*dx)
        if dy>0 then ys=ys+int(rnd(1)*dy)
        dx=xe-xs-gr:dy=ye-ys-gr
        if dx>0 then xe=xe-int(rnd(1)*dx)
        if dy>0 then ye=ye-int(rnd(1)*dy)

        rm(i,tl,x)=xs:rm(i,tl,y)=ys
        rm(i,br,x)=xe:rm(i,br,y)=ye

        shrink_done:
    next i

    rem *** set room connections ***
    for i=0 to 8:cn(i)=0:vs(i)=0:next i:rem reset connection flags
    a=int(rnd(1)*9):rem select random starting room
    vs(a)=1:al(0)=a:rem mark starting room as connected and add to list

    for n=1 to 8
        an=int(rnd(1)*n):rem select random connected room

        get_room:
        a=al(an)
        m=a-int(a/3)*3:rem determine column of room (0,1,2)
        s=0:rem avialable connections counter
        if m>0 then if vs(a-1)=0 then ct(s)=a-1:s=s+1:rem possible to left connection
        if m<2 then if vs(a+1)=0 then ct(s)=a+1:s=s+1:rem possible to right connection
        if a>2 then if vs(a-3)=0 then ct(s)=a-3:s=s+1:rem possible to up connection
        if a<6 then if vs(a+3)=0 then ct(s)=a+3:s=s+1:rem possible to down connection

        if s>0 then select_connection
        an=an+1:if an=n then an=0:rem no available direction, select next room
        goto get_room

        select_connection:
        b=ct(int(rnd(1)*s)):rem select random available connection
        if b=a-3 then cn(b)=cn(b)+4:rem cn(a)=cn(a)+1:rem b is up
        if b=a+1 then cn(a)=cn(a)+2:rem cn(b)=cn(b)+8:rem b is right
        if b=a+3 then cn(a)=cn(a)+4:rem cn(b)=cn(b)+1:rem b is down
        if b=a-1 then cn(b)=cn(b)+2:rem cn(a)=cn(a)+8:rem b is left
        vs(b)=1:al(n)=b:rem mark new room as connected and add to list
    next n

    rem add more (0-3) connection
    for i=0 to 3
        a=int(rnd(1)*7)
        m=a-int(a/3)*3:rem determine column of room (0,1,2)
        if m<2 and a<6 then d=(int(rnd(1)*2)*2):goto set_connection
        if m<2 and a=6 then d=2:goto set_connection
        if m=2 and a<6 then d=4:goto set_connection
        goto connection_done

        set_connection:
        cn(a)=cn(a) or d

        connection_done:
    next i
    return



draw_map:

draw_rooms:
    for i=0 to 8
        rem check phantom rooms
        if (rf(i) and 1)=1 then poke 1024+rm(i,tl,x)+rm(i,tl,y)*40,35:goto room_drawing_done
        rem horizontal walls
        a0=rm(i,tl,y)*40:a1=rm(i,br,y)*40
        for j=rm(i,tl,x)+1 to rm(i,br,x)-1
            poke 1024+j+a0,67
            poke 1024+j+a1,67
        next j
        poke 1024+rm(i,tl,x)+a0,112
        poke 1024+rm(i,br,x)+a0,110
        rem vertical walls
        for j=rm(i,tl,y)+1 to rm(i,br,y)-1
            a0=rm(i,tl,x)+j*40:a1=rm(i,br,x)+j*40
            poke 1024+a0,66
            poke 1024+a1,66
            for k=a0+1 to a1-1:poke 1024+k,46:next k:rem floor
        next j
        poke 1024+rm(i,tl,x)+rm(i,br,y)*40,109
        poke 1024+rm(i,br,x)+rm(i,br,y)*40,125

        room_drawing_done:
    next i

draw_corridors:
    for a=0 to 8
        rem if (cn(a) and 1)<>0 then b=a-3:gosub ...:rem open up
        if (cn(a) and 2)<>0 then b=a+1:gosub horizontal_corridor
        if (cn(a) and 4)<>0 then b=a+3:gosub vertical_corridor
        rem if (cn(a) and 8))<>0 then b=a-1:gosub ...:rem open left
    next a
    return

    horizontal_corridor:
        if (rf(a) and 1)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto set_horizontal_b_room
        ax=rm(a,br,x)
        dy=rm(a,br,y)-rm(a,tl,y)-2
        ay=rm(a,tl,y)+1+int(rnd(1)*dy)
        a0=ax+ay*40:poke 1024+a0,43:rem door

        set_horizontal_b_room:
        if (rf(b) and 1)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto draw_horizontal_corridor
        bx=rm(b,tl,x)
        dy=rm(b,br,y)-rm(b,tl,y)-2
        by=rm(b,tl,y)+1+int(rnd(1)*dy)
        a0=bx+by*40:poke 1024+a0,43:rem door

        draw_horizontal_corridor:
        if ay=by then draw_straight_horizontal_corridor

        draw_zshaped_horizontal_corridor:
            mx=ax+1+int(rnd(1)*(bx-ax-2))
            for j=ax+1 to mx
                a0=j+ay*40:poke 1024+a0,35:rem corridor
            next j
            dy=sgn(by-ay)
            if ay+dy=by then no_horizontal_midpart
            for j=ay+dy to by-dy step dy
                a0=mx+j*40:poke 1024+a0,35:rem corridor
            next j
            no_horizontal_midpart:
            for j=mx to bx-1
                a0=j+by*40:poke 1024+a0,35:rem corridor
            next j
            return

        draw_straight_horizontal_corridor:
            for j=ax+1 to bx-1
                a0=j+ay*40:poke 1024+a0,35:rem corridor
            next j
            return

    vertical_corridor:
        if (rf(a) and 1)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto set_vertical_b_room
        ay=rm(a,br,y)
        dx=rm(a,br,x)-rm(a,tl,x)-2
        ax=rm(a,tl,x)+1+int(rnd(1)*dx)
        a0=ax+ay*40:poke 1024+a0,43:rem door

        set_vertical_b_room:
        if (rf(b) and 1)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto draw_veretical_corridor
        by=rm(b,tl,y)
        dx=rm(b,br,x)-rm(b,tl,x)-2
        bx=rm(b,tl,x)+1+int(rnd(1)*dx)
        a0=bx+by*40:poke 1024+a0,43:rem door

        draw_veretical_corridor:
        if ax=bx then draw_straight_veretical_corridor

        draw_zshaped_veretical_corridor:
            my=ay+1+int(rnd(1)*(by-ay-2))
            for j=ay+1 to my
                a0=ax+j*40:poke 1024+a0,35:rem corridor
            next j
            dx=sgn(bx-ax)
            if ax+dx=bx then no_vertical_midpart
            for j=ax+dx to bx-dx step dx
                a0=j+my*40:poke 1024+a0,35:rem corridor
            next j

            no_vertical_midpart:
            for j=my to by-1
                a0=bx+j*40:poke 1024+a0,35:rem corridor
            next j
            return

        draw_straight_veretical_corridor:
            for j=ay+1 to by-1
                a0=ax+j*40:poke 1024+a0,35:rem corridor
            next j
            return

    rem *** end of program ***
