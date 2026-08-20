init:
    sys 57812 "routines",8,1:poke 780,0:sys 65493:rem load asm

    r=rnd(-ti):rem initialize random number generator
    tl=0:br=1:x=0:y=1:rem for readability

    dim rm(8,1,1):rem rooms in the nine (3x3) sectors
    dim rf(8):rem flags
        rem bit.0 -phantom room
        rem bit 1 -has its own light
        rem bit 2 -lighted up already

    dim cn(8),cv(8),ca(8),ct(3):rem temporary arrays for room connections

    poke 650,128:rem drag keypress (128-enable, 0-disable)

    rem poke 53280,0:poke 53281,0:rem background and border colors



reset_new_level:
    seed=-int(rnd(0)*32768)-1:rem random seed
    rem seed=-15233
    r=rnd(seed):rem initialize random number generator

    reset_flags:
        for i=0 to 8
            rf(i)=2
            if rnd(1)<0.5 then rf(i)=0:rem room has no light
        next i

        nr=int(rnd(1)*4):rem number of rooms to remove (0-3)
        if nr=0 then set_level
        for i=1 to nr
            r=int(rnd(1)*9)
            select_room:
            if (rf(r) and 1)=0 then select_room_done
            r=r+1:if r>8 then n=0
            goto select_room
            select_room_done:
            rf(r)=rf(r) or 1
        next i

    set_level:
        print "{clr}"
        gosub create_map

        print "{clr}"

        create_next_level_passage:
            r=int(rnd(1)*9):rem room of passage to next level

            check_phantom_room:
                if (rf(r) and 1)=0 then set_next_level_passage
                r=r+1:if r>8 then r=0
                goto check_phantom_room

            set_next_level_passage:
                nx=rm(r,tl,x)+1+int(rnd(1)*(rm(r,br,x)-rm(r,tl,x)-2))
                ny=rm(r,tl,y)+1+int(rnd(1)*(rm(r,br,y)-rm(r,tl,y)-2))
                poke MAP_MEM+nx+ny*40,staircase_char

    rem sys showFullMap

    set_player:
        cr=int(rnd(1)*9):rem starting room

        check_starting_room:
            if (rf(cr) and 1)=0 then set_player_position:rem not a phantom room
            cr=cr+1:if cr>8 then cr=0
            goto check_starting_room

        set_player_position:
            px=rm(cr,tl,x)+1+int(rnd(1)*(rm(cr,br,x)-rm(cr,tl,x)-2))
            py=rm(cr,tl,y)+1+int(rnd(1)*(rm(cr,br,y)-rm(cr,tl,y)-2))
            p=px+py*40
            np=peek(MAP_MEM+p):rem new position background

            if (rf(cr) and 6)=0 then gosub light_on_player_area:goto draw_player
            gosub light_on_room



draw_player:
    bg=np
    poke SCREEN_MEM+p,player_char

player_control:
    get a$
    if a$="w" or a$="{up}" then dx=0:dy=-1:d=-40:goto check_collision
    if a$="d" or a$="{right}" then dx=1:dy=0:d=1:goto check_collision
    if a$="s" or a$="{down}" then dx=0:dy=1:d=40:goto check_collision
    if a$="a" or a$="{left}" then dx=-1:dy=0:d=-1:goto check_collision
    if a$=chr$(13) then make_actions
    goto player_control

    check_collision:
        np=peek(MAP_MEM+p+d):rem next position
        if np<>corridor_char and np<>door_char and np<>floor_char and np<>staircase_char then player_control

        move_player:
            if bg=corridor_char and (np=corridor_char) then move_to_corridor
            if bg=corridor_char and (np=door_char) then move_from_corridor_to_door
            if (bg=floor_char or bg=staircase_char) and (np=floor_char or np=door_char or np=staircase_char) then move_inside_room
            if bg=door_char and np=corridor_char then move_from_door_to_corridor

            move_from_corridor_to_door:
                gosub step_player
                gosub get_player_room
                if (rf(cr) and 2)=0 then move_from_corridor_to_door_with_no_light
                poke SCREEN_MEM+p-d,bg
                if (rf(cr) and 4)=0 then gosub light_on_room
                goto draw_player

                move_from_corridor_to_door_with_no_light:
                    gosub light_on_player_area
                    goto draw_player

            move_inside_room:
                if (rf(cr) and 4)=0 then move_inside_room_with_no_light
                poke SCREEN_MEM+p,bg
                gosub step_player
                goto draw_player

                move_inside_room_with_no_light:
                    gosub light_off_player_area
                    gosub step_player
                    gosub light_on_player_area
                    goto draw_player

            move_from_door_to_corridor:
                if (rf(cr) and 4)=0 then gosub light_off_player_area

            move_to_corridor:
                gosub step_player
                gosub light_on_corridor
                goto draw_player

    make_actions:
        if bg=staircase_char then reset_new_level
        goto player_control



step_player:
    px=px+dx
    py=py+dy
    p=p+d
    return

light_on_corridor:
    poke plx_var,px
    poke ply_var,py
    sys lightOn_corridor
    return

get_player_room:
    if py<y1 then cr=0:goto check_sector_column
    if py<y2 then cr=3:goto check_sector_column
    cr=6

    check_sector_column:
    if px<x1 then return
    if px<x2 then cr=cr+1:return
    cr=cr+2
    return

light_on_room:
    poke tlx_var,rm(cr,tl,x)
    poke tly_var,rm(cr,tl,y)
    poke brx_var,rm(cr,br,x)
    poke bry_var,rm(cr,br,y)
    poke col_var,1
    sys lightOn_room
    rf(cr)=rf(cr) or 4:rem set room as lightened
    return

light_off_player_area:
    poke plx_var,px
    poke ply_var,py
    sys lightOff_playerArea
    return

light_on_player_area:
    poke plx_var,px
    poke ply_var,py
    sys lightOn_playerArea
    return





create_map:
    print " create map..."

    create_sectors:
        print "   create sectors..."
        x0=0
        y0=0
        x1=13
        y1=8
        x2=26
        y2=16
        x3=39
        y3=24

    create_rooms_in_sectors:
        print "   create rooms in sectors..."
        rm(0,tl,x)=x0+1:rm(0,br,x)=x1-1:rm(0,tl,y)=y0+1:rm(0,br,y)=y1-1
        rm(1,tl,x)=x1+1:rm(1,br,x)=x2-1:rm(1,tl,y)=y0+1:rm(1,br,y)=y1-1
        rm(2,tl,x)=x2+1:rm(2,br,x)=x3-1:rm(2,tl,y)=y0+1:rm(2,br,y)=y1-1
        rm(3,tl,x)=x0+1:rm(3,br,x)=x1-1:rm(3,tl,y)=y1+1:rm(3,br,y)=y2-1
        rm(4,tl,x)=x1+1:rm(4,br,x)=x2-1:rm(4,tl,y)=y1+1:rm(4,br,y)=y2-1
        rm(5,tl,x)=x2+1:rm(5,br,x)=x3-1:rm(5,tl,y)=y1+1:rm(5,br,y)=y2-1
        rm(6,tl,x)=x0+1:rm(6,br,x)=x1-1:rm(6,tl,y)=y2+1:rm(6,br,y)=y3-1
        rm(7,tl,x)=x1+1:rm(7,br,x)=x2-1:rm(7,tl,y)=y2+1:rm(7,br,y)=y3-1
        rm(8,tl,x)=x2+1:rm(8,br,x)=x3-1:rm(8,tl,y)=y2+1:rm(8,br,y)=y3-1

    shrink_rooms:
        print "   shrink rooms..."
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

    set_room_connections:
        print "   set room connections..."
        for i=0 to 8:cn(i)=0:cv(i)=0:next i:rem reset connection flags
        a=int(rnd(1)*9):rem select random starting room
        cv(a)=1:ca(0)=a:rem mark starting room as connected and add to list

        for n=1 to 8
            an=int(rnd(1)*n):rem select random connected room

            get_room:
            a=ca(an)
            m=a-int(a/3)*3:rem determine column of room (0,1,2)
            s=0:rem avialable connections counter
            if m>0 then if cv(a-1)=0 then ct(s)=a-1:s=s+1:rem possible to left connection
            if m<2 then if cv(a+1)=0 then ct(s)=a+1:s=s+1:rem possible to right connection
            if a>2 then if cv(a-3)=0 then ct(s)=a-3:s=s+1:rem possible to up connection
            if a<6 then if cv(a+3)=0 then ct(s)=a+3:s=s+1:rem possible to down connection

            if s>0 then select_connection
            an=an+1:if an=n then an=0:rem no available direction, select next room
            goto get_room

            select_connection:
            b=ct(int(rnd(1)*s)):rem select random available connection
            if b=a-3 then cn(b)=cn(b)+4:rem cn(a)=cn(a)+1:rem b is up
            if b=a+1 then cn(a)=cn(a)+2:rem cn(b)=cn(b)+8:rem b is right
            if b=a+3 then cn(a)=cn(a)+4:rem cn(b)=cn(b)+1:rem b is down
            if b=a-1 then cn(b)=cn(b)+2:rem cn(a)=cn(a)+8:rem b is left
            cv(b)=1:ca(n)=b:rem mark new room as connected and add to list
        next n

        add_more_connections:
            print "     add more connections..."
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

draw_map:
    print "{down} draw map..."
    sys clearMap

    draw_rooms:
        print "   draw rooms..."
        for i=0 to 8
            rem check phantom rooms
            if (rf(i) and 1)=1 then poke MAP_MEM+rm(i,tl,x)+rm(i,tl,y)*40,corridor_char:goto room_drawing_done

            poke tlx_var,rm(i,tl,x)
            poke tly_var,rm(i,tl,y)
            poke brx_var,rm(i,br,x)
            poke bry_var,rm(i,br,y)
            sys drawRoom

            room_drawing_done:
        next i

    draw_corridors:
        print "   draw corridors..."
        for a=0 to 8
            rem if (cn(a) and 1)<>0 then b=a-3:gosub ...:rem open up
            if (cn(a) and 2)<>0 then b=a+1:gosub horizontal_corridor
            if (cn(a) and 4)<>0 then b=a+3:gosub vertical_corridor
            rem if (cn(a) and 8)<>0 then b=a-1:gosub ...:rem open left
        next a
        return

        horizontal_corridor:
            print "     horizontal corridor..."
            if (rf(a) and 1)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto set_horizontal_b_room
            ax=rm(a,br,x)
            dy=rm(a,br,y)-rm(a,tl,y)-2
            ay=rm(a,tl,y)+1+int(rnd(1)*dy)
            p=ax+ay*40:poke MAP_MEM+p,door_char

            set_horizontal_b_room:
            if (rf(b) and 1)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto draw_horizontal_corridor
            bx=rm(b,tl,x)
            dy=rm(b,br,y)-rm(b,tl,y)-2
            by=rm(b,tl,y)+1+int(rnd(1)*dy)
            p=bx+by*40:poke MAP_MEM+p,door_char

            draw_horizontal_corridor:
            if ay=by then straight_horizontal_corridor

            zshaped_horizontal_corridor:
                print "       z-shaped horizontal corridor..."
                mx=ax+1+int(rnd(1)*(bx-ax-2))
                for j=ax+1 to mx
                    p=j+ay*40:poke MAP_MEM+p,corridor_char
                next j
                dy=sgn(by-ay)
                if ay+dy=by then no_horizontal_midpart
                for j=ay+dy to by-dy step dy
                    p=mx+j*40:poke MAP_MEM+p,corridor_char
                next j
                no_horizontal_midpart:
                for j=mx to bx-1
                    p=j+by*40:poke MAP_MEM+p,corridor_char
                next j
                return

            straight_horizontal_corridor:
                print "       straight horizontal corridor..."
                for j=ax+1 to bx-1
                    p=j+ay*40:poke MAP_MEM+p,corridor_char
                next j
                return

        vertical_corridor:
            print "     vertical corridor..."
            if (rf(a) and 1)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto set_vertical_b_room
            ay=rm(a,br,y)
            dx=rm(a,br,x)-rm(a,tl,x)-2
            ax=rm(a,tl,x)+1+int(rnd(1)*dx)
            p=ax+ay*40:poke MAP_MEM+p,door_char

            set_vertical_b_room:
            if (rf(b) and 1)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto draw_vertical_corridor
            by=rm(b,tl,y)
            dx=rm(b,br,x)-rm(b,tl,x)-2
            bx=rm(b,tl,x)+1+int(rnd(1)*dx)
            p=bx+by*40:poke MAP_MEM+p,door_char

            draw_vertical_corridor:
            if ax=bx then straight_vertical_corridor

            zshaped_vertical_corridor:
                print "       z-shaped vertical corridor..."
                my=ay+1+int(rnd(1)*(by-ay-2))
                for j=ay+1 to my
                    p=ax+j*40:poke MAP_MEM+p,corridor_char
                next j
                dx=sgn(bx-ax)
                if ax+dx=bx then no_vertical_midpart
                for j=ax+dx to bx-dx step dx
                    p=j+my*40:poke MAP_MEM+p,corridor_char
                next j

                no_vertical_midpart:
                for j=my to by-1
                    p=bx+j*40:poke MAP_MEM+p,corridor_char
                next j
                return

            straight_vertical_corridor:
                print "       straight vertical corridor..."
                for j=ay+1 to by-1
                    p=ax+j*40:poke MAP_MEM+p,corridor_char
                next j
                return
