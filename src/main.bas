init:
    sys 57812 "routines",8,1:poke 780,0:sys 65493:rem load asm



    rem constants for sector borders
    x0=0 :y0=0
    x1=13:y1=8
    x2=26:y2=16
    x3=39:y3=24

    tl=0:br=1:x=0:y=1:rem constants for readability

    dim rm(8,1,1):rem rooms in the nine (3x3) sectors
    dim rf(8):rem flags
        rem bit.0 -phantom room (1)
        rem bit 1 -has its own light (2)
        rem bit 2 -lighted up already (4)
        rem bit 3 - maze room (8)
        rem bit 4 - has connection to east (16)
        rem bit 5 - has connection to south (32)
        rem bit 6 - ... (64)
        rem bit 7 - visited flag for creating connections (128)
    dim cl(8):rem list of visited rooms by connection algorithm
    dim cp(3):rem possible connection directions flags from current room
    iw=2:rem minimum inner width of rooms (walls not included)


    lv=1:rem current level
    pr=-1:rem player's room
    py=0:px=0:rem player's position
    pb=-1:rem player's background



    r=rnd(-ti):rem initialize random number generator
    poke 650,128:rem drag keypress (128-enable, 0-disable)

    rem poke 53280,0:poke 53281,0:poke 646,15:rem border, background and text colors



reset_new_level:
    print "{clr}"
    seed=-int(rnd(0)*32768)-1:rem random seed
    rem seed=-30849
    r=rnd(seed):rem initialize random number generator

    gosub reset_flags
    gosub create_map
    gosub draw_map
    gosub add_staircase

    print "{clr}"



    rem sys showFullMap



    set_player:
        pr=int(rnd(1)*9):rem starting room

        check_normal_room_for_starting_room:
            if (rf(pr) and 9)=0 then set_player_position: rem 1+8=phantom+maze
            pr=pr+1:if pr>8 then pr=0
            goto check_normal_room_for_starting_room

        set_player_position:
            px=rm(pr,tl,x)+1+int(rnd(1)*(rm(pr,br,x)-rm(pr,tl,x)-2))
            py=rm(pr,tl,y)+1+int(rnd(1)*(rm(pr,br,y)-rm(pr,tl,y)-2))
            p=px+py*40
            if peek(MAP_MEM+p)<>floor_char then set_player_position

        nb=peek(MAP_MEM+p):rem next (possible) background

        if (rf(pr) and 6)=0 then gosub light_on_player_area:goto draw_player
        gosub light_on_room



draw_player:
    pb=nb
    poke SCREEN_MEM+p,player_char

draw_hud:
    print "{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}";
    print spc(0)"level:"lv;

player_control:
    get a$
    if a$="w" or a$="{up}" then dx=0:dy=-1:d=-40:goto check_collision
    if a$="d" or a$="{right}" then dx=1:dy=0:d=1:goto check_collision
    if a$="s" or a$="{down}" then dx=0:dy=1:d=40:goto check_collision
    if a$="a" or a$="{left}" then dx=-1:dy=0:d=-1:goto check_collision
    if a$=chr$(13) then make_actions:rem return key
    if a$=chr$(32) then going_to_next_level:rem space key
    goto player_control



    check_collision:
        nb=peek(MAP_MEM+p+d):rem next background
        if nb=corridor_char then move_player
        if nb=door_char then move_player
        if nb=floor_char then move_player
        if nb=staircase_char then move_player

        if nb<>gold_char then player_control

        move_player:
            if pb=corridor_char and (nb=corridor_char) then move_to_corridor
            if pb=corridor_char and (nb=door_char) then move_from_corridor_to_door
            if (pb=floor_char or pb=staircase_char or pb=gold_char) and (nb=floor_char or nb=door_char or nb=staircase_char or nb=gold_char) then move_inside_room
            if pb=door_char and nb=corridor_char then move_from_door_to_corridor

            move_from_corridor_to_door:
                gosub step_player
                gosub get_player_room
                if (rf(pr) and 2)=0 then move_from_corridor_to_door_with_no_light
                poke SCREEN_MEM+p-d,pb
                if (rf(pr) and 4)=0 then gosub light_on_room
                goto draw_player

                move_from_corridor_to_door_with_no_light:
                    gosub light_on_player_area
                    goto draw_player

            move_inside_room:
                if (rf(pr) and 4)=0 then move_inside_room_with_no_light
                poke SCREEN_MEM+p,pb
                if nb=door_char then move_to_corridor
                gosub step_player
                goto draw_player

                move_inside_room_with_no_light:
                    gosub light_off_player_area
                    gosub step_player
                    gosub light_on_player_area
                    goto draw_player

            move_from_door_to_corridor:
                if (rf(pr) and 4)=0 then gosub light_off_player_area

            move_to_corridor:
                gosub step_player
                gosub light_on_corridor
                goto draw_player

    make_actions:
        if pb=staircase_char then going_to_next_level
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
    if py<y1 then pr=0:goto check_sector_column
    if py<y2 then pr=3:goto check_sector_column
    pr=6

    check_sector_column:
        if px<x1 then return
        if px<x2 then pr=pr+1:return
        pr=pr+2
        return

light_on_room:
    poke tlx_var,rm(pr,tl,x)
    poke tly_var,rm(pr,tl,y)
    poke brx_var,rm(pr,br,x)
    poke bry_var,rm(pr,br,y)
    sys lightOn_room
    rf(pr)=rf(pr) or 4:rem set room as lightened
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

going_to_next_level:
    lv=lv+1
    goto reset_new_level



reset_flags:
    print " reset flags..."

    for i=0 to 8
        rf(i)=0
        if int(rnd(1)*10)>=lv-1 then rf(i)=2:goto reset_done:rem light is on
        if int(rnd(1)*15)=0 then rf(i)=8:rem it's a maze room
        reset_done:
    next i

    nr=int(rnd(1)*4):rem number of phantom rooms (0-3)
    if nr=0 then return
    for i=1 to nr
        r=int(rnd(1)*9)

        check_normal_room_for_phantom_room:
            if (rf(r) and 9)=0 then set_phantom_room:rem 1+8=phantom+maze
            r=r+1:if r>8 then r=0
            goto check_normal_room_for_phantom_room

        set_phantom_room:
            rf(r)=rf(r) or 1:rem set room as phantom room
    next i
    return



create_map:
    print "{down} create map..."

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
        for i=0 to 8
            xs=rm(i,tl,x):ys=rm(i,tl,y)
            xe=rm(i,br,x):ye=rm(i,br,y)

            if (rf(i) and 1)=0 then set_room

            set_phantom_room_position:
                dx=xe-xs:dy=ye-ys
                xs=xs+int(rnd(1)*dx):xe=xs
                ys=ys+int(rnd(1)*dy):ye=ys
                goto shrink_done

            set_room:
                dx=xe-xs-iw*2:dy=ye-ys-iw*2
                if dx>0 then xs=xs+int(rnd(1)*dx)
                if dy>0 then ys=ys+int(rnd(1)*dy)
                dx=xe-xs-iw:dy=ye-ys-iw
                if dx>0 then xe=xe-int(rnd(1)*dx)
                if dy>0 then ye=ye-int(rnd(1)*dy)

            shrink_done:
                rm(i,tl,x)=xs:rm(i,tl,y)=ys
                rm(i,br,x)=xe:rm(i,br,y)=ye
        next i

    set_room_connections:
        print "   set room connections..."

        a=int(rnd(1)*9):rem select random starting room
        rf(a)=rf(a) or 128:rem first room setted as visited
        cl(0)=a:rem first room added to list

        for n=1 to 8
            an=int(rnd(1)*n):rem select random room from the list (n=length of roomlist)

            get_room:
                a=cl(an):rem get the room from list

                m=a-int(a/3)*3:rem column of room (0,1,2)
                s=0:rem available connections counter

                if m>0 then if (rf(a-1) and 128)=0 then cp(s)=a-1:s=s+1:rem possible to left connection
                if m<2 then if (rf(a+1) and 128)=0 then cp(s)=a+1:s=s+1:rem possible to right connection
                if a>2 then if (rf(a-3) and 128)=0 then cp(s)=a-3:s=s+1:rem possible to up connection
                if a<6 then if (rf(a+3) and 128)=0 then cp(s)=a+3:s=s+1:rem possible to down connection

                if s>0 then select_connection
                an=an+1:if an=n then an=0:rem no available direction, select next room
                goto get_room

            select_connection:
                b=cp(int(rnd(1)*s)):rem select random available connection
                if b=a-3 then rf(b)=rf(b) or 32:rem b is at north (set south flag of b)
                if b=a+1 then rf(a)=rf(a) or 16:rem b is at east (set east flag of a)
                if b=a+3 then rf(a)=rf(a) or 32:rem b is at south (set south flag of a)
                if b=a-1 then rf(b)=rf(b) or 16:rem b is at west (set east flag of b)
                rf(b)=rf(b) or 128:cl(n)=b
        next n

        add_more_connections:
            print "     add more connections..."
            for i=0 to 2
                a=int(rnd(1)*7)
                m=a-int(a/3)*3:rem column of room (0,1,2)
                d=0
                if m<2 then d=16:rem possible east
                if a<6 then d=d or 32:rem possible south
                rf(a)=rf(a) or (d and (int(rnd(1)*3)*16)):rem 0, 16 or 32
            next i
    return



draw_map:
    print "{down} draw map..."
    sys clearMap

    draw_rooms:
        print "   draw rooms..."
        for i=0 to 8
            if (rf(i) and 1)<>0 then poke MAP_MEM+rm(i,tl,x)+rm(i,tl,y)*40,corridor_char:goto room_drawing_done
            if (rf(i) and 8)=0 then draw_normal_room

            draw_maze_room:
                print "     {white}maze room - under construct...{light blue}"
                rem goto room_drawing_done

            draw_normal_room:
                poke tlx_var,rm(i,tl,x)
                poke tly_var,rm(i,tl,y)
                poke brx_var,rm(i,br,x)
                poke bry_var,rm(i,br,y)
                sys draw_room

            room_drawing_done:
        next i

    draw_corridors:
        print "   draw corridors..."
        for a=0 to 8
            if (rf(a) and 16)<>0 then b=a+1:gosub horizontal_corridor to east
            if (rf(a) and 32)<>0 then b=a+3:gosub vertical_corridor to south
        next a
        return

        horizontal_corridor:
            if (rf(a) and 1)<>0 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto set_horizontal_b_room
            ax=rm(a,br,x)
            dy=rm(a,br,y)-rm(a,tl,y)-2
            ay=rm(a,tl,y)+1+int(rnd(1)*dy)
            poke MAP_MEM+ax+ay*40,door_char

            set_horizontal_b_room:
                if (rf(b) and 1)<>0 then bx=rm(b,tl,x):by=rm(b,tl,y):goto draw_horizontal_corridor
                bx=rm(b,tl,x)
                dy=rm(b,br,y)-rm(b,tl,y)-2
                by=rm(b,tl,y)+1+int(rnd(1)*dy)
                poke MAP_MEM+bx+by*40,door_char

            draw_horizontal_corridor:
                if ay=by then straight_horizontal_corridor

            zshaped_horizontal_corridor:
                poke x_var,ax+1
                poke y_var,ay
                poke x2_var,bx-1
                poke y2_var,by
                poke mx_var,ax+1+int(rnd(1)*(bx-ax-2))
                sys draw_zShapedHorizontalCorridor
                return

            straight_horizontal_corridor:
                poke y_var,ay
                poke x_var,ax+1
                poke x2_var,bx-1
                sys draw_straightHorizontalCorridor
                return

        vertical_corridor:
            if (rf(a) and 1)<>0 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto set_vertical_b_room
            ay=rm(a,br,y)
            dx=rm(a,br,x)-rm(a,tl,x)-2
            ax=rm(a,tl,x)+1+int(rnd(1)*dx)
            poke MAP_MEM+ax+ay*40,door_char

            set_vertical_b_room:
                if (rf(b) and 1)<>0 then bx=rm(b,tl,x):by=rm(b,tl,y):goto draw_vertical_corridor
                by=rm(b,tl,y)
                dx=rm(b,br,x)-rm(b,tl,x)-2
                bx=rm(b,tl,x)+1+int(rnd(1)*dx)
                poke MAP_MEM+bx+by*40,door_char

            draw_vertical_corridor:
                if ax=bx then straight_vertical_corridor

            zshaped_vertical_corridor:
                poke x_var,ax
                poke y_var,ay+1
                poke x2_var,bx
                poke y2_var,by-1
                poke my_var,ay+1+int(rnd(1)*(by-ay-2))
                sys draw_zShapedVerticalCorridor
                return

            straight_vertical_corridor:
                poke x_var,ax
                poke y_var,ay+1
                poke y2_var,by-1
                sys draw_straightVerticalCorridor
                return



add_staircase:
    print "{down} add staircase..."
    r=int(rnd(1)*9):rem room of passage to next level

    check_phantom_room_for_staircase:
        if (rf(r) and 1)=0 then set_staircase
        r=r+1:if r>8 then r=0
        goto check_phantom_room_for_staircase

    set_staircase:
        nx=rm(r,tl,x)+1+int(rnd(1)*(rm(r,br,x)-rm(r,tl,x)-2))
        ny=rm(r,tl,y)+1+int(rnd(1)*(rm(r,br,y)-rm(r,tl,y)-2))
        poke MAP_MEM+nx+ny*40,staircase_char
        return
