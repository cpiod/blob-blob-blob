pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- untitled blob game
-- by cpiod for 7drl22

function _init()
 xp=0
 poke(0x5f2d, 1) --enable mouse
 mouse_last_move=-100
 mouse_last_x=stat(32)
 mouse_last_y=stat(33)
 show_classes=false
 show_controls=false
 msg={}
 selected_class=0
 inv={}
 changed_focus=0
 status=12
 turn=0
	los_radius=6
 cls()
 palt(0,false)
 screen_dx=0
 screen_dy=0
 show_map=false
 redraw=false
 ents={}
 srand(2)--todo
 mapgen()
 menuitem(1, "controls", function() show_controls=true end)
end

-- states:
-- 10: player input
-- 11: monster input
-- 12: end turn
-- 13: blob auto input
-- 20: game over

table_los=split("-1,0,-2,-1,-3,-1,-4,-2,-5,-2,,,,,,,-1,0,-2,0,-3,-1,-4,-1,-5,-1,,,,,,,-1,0,-2,0,-3,0,-4,0,-5,0,,,,,,,-1,0,-2,0,-3,1,-4,1,-5,1,,,,,,,-1,0,-2,1,-3,1,-4,2,-5,2,,,,,,,-1,-1,-2,-2,-3,-3,-4,-4,,,,,,,,,-1,-1,-2,-1,-3,-2,-4,-3,,,,,,,,,-1,1,-2,1,-3,2,-4,3,,,,,,,,,-1,1,-2,2,-3,3,-4,4,,,,,,,,,-1,-1,-1,-2,-2,-3,-3,-4,,,,,,,,,-1,1,-2,2,-2,3,-3,4,,,,,,,,,0,-1,-1,-2,-1,-3,-2,-4,-2,-5,,,,,,,0,1,-1,2,-1,3,-2,4,-2,5,,,,,,,0,-1,0,-2,-1,-3,-1,-4,-1,-5,,,,,,,0,1,0,2,-1,3,-1,4,-1,5,,,,,,,0,-1,0,-2,0,-3,0,-4,0,-5,,,,,,,0,1,0,2,0,3,0,4,0,5,,,,,,,0,-1,0,-2,1,-3,1,-4,1,-5,,,,,,,0,1,0,2,1,3,1,4,1,5,,,,,,,0,-1,1,-2,1,-3,2,-4,2,-5,,,,,,,0,1,1,2,1,3,2,4,2,5,,,,,,,1,-1,1,-2,2,-3,3,-4,,,,,,,,,1,1,2,2,2,3,3,4,,,,,,,,,1,-1,2,-2,3,-3,4,-4,,,,,,,,,1,-1,2,-2,3,-2,4,-3,,,,,,,,,1,1,2,2,3,2,4,3,,,,,,,,,1,1,2,2,3,3,4,4,,,,,,,,,1,0,2,-1,3,-1,4,-2,5,-2,,,,,,,1,0,2,0,3,-1,4,-1,5,-1,,,,,,,1,0,2,0,3,0,4,0,5,0,,,,,,,1,0,2,0,3,1,4,1,5,1,,,,,,,1,0,2,1,3,1,4,2,5,2,,,,,,,")


poke(0x5600,unpack(split"8,8,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,24,24,24,24,0,24,0,0,54,54,18,0,0,0,0,0,54,127,54,127,54,0,0,24,124,30,60,120,62,24,0,6,102,48,24,12,102,96,0,28,54,54,28,110,54,108,0,24,24,8,0,0,0,0,0,24,12,6,6,6,12,24,0,24,48,96,96,96,48,24,0,24,126,60,24,60,126,24,0,0,24,24,126,24,24,0,0,0,0,0,0,0,12,12,6,0,0,0,126,0,0,0,0,0,0,0,0,0,0,12,0,0,96,48,24,12,6,0,0,0,0,60,118,110,102,60,0,0,0,24,28,24,24,60,0,0,0,62,96,60,6,126,0,0,0,62,96,56,96,62,0,0,0,56,60,54,126,48,0,0,0,126,6,62,96,62,0,0,0,60,6,62,102,60,0,0,0,126,96,48,24,12,0,0,0,60,102,60,102,60,0,0,0,60,102,124,96,60,0,0,0,0,12,0,12,0,0,0,0,0,12,0,12,12,6,48,24,12,6,12,24,48,0,0,0,0,126,0,0,0,0,12,24,48,96,48,24,12,0,0,60,102,48,24,0,24,0,0,60,102,118,110,118,60,0,0,0,60,102,126,102,102,0,0,0,62,102,62,102,62,0,0,0,60,102,6,102,60,0,0,0,62,102,102,102,62,0,0,0,126,6,30,6,126,0,0,0,126,6,30,6,6,0,0,0,124,6,118,102,124,0,0,0,102,102,126,102,102,0,0,0,60,24,24,24,60,0,0,0,96,96,96,102,60,0,0,0,102,54,30,54,102,0,0,0,6,6,6,6,126,0,0,0,66,102,126,126,102,0,0,0,102,110,126,118,102,0,0,0,60,102,102,102,60,0,0,0,62,102,62,6,6,0,0,0,60,102,102,54,108,0,0,0,62,102,126,54,102,0,0,0,124,6,60,96,62,0,0,0,126,24,24,24,24,0,0,0,102,102,102,102,60,0,0,0,102,102,102,60,24,0,0,0,102,126,126,102,66,0,0,0,102,60,24,60,102,0,0,0,102,102,60,24,24,0,0,0,126,48,24,12,126,0,62,6,6,6,6,6,62,0,0,6,12,24,48,96,0,0,62,48,48,48,48,48,62,0,24,60,102,0,0,0,0,0,0,0,0,0,0,0,0,126,12,24,48,0,0,0,0,0,0,60,102,102,126,102,102,0,0,62,102,62,102,102,62,0,0,60,102,6,6,102,60,0,0,62,102,102,102,102,62,0,0,126,6,30,6,6,126,0,0,126,6,30,6,6,6,0,0,124,6,118,102,102,124,0,0,102,102,126,102,102,102,0,0,60,24,24,24,24,60,0,0,96,96,96,96,102,60,0,0,102,54,30,54,102,102,0,0,6,6,6,6,6,126,0,0,66,102,126,126,102,102,0,0,102,110,126,118,102,102,0,0,60,102,102,102,102,60,0,0,62,102,102,62,6,6,0,0,60,102,102,102,54,108,0,0,62,102,102,62,54,102,0,0,124,6,60,96,96,62,0,0,126,24,24,24,24,24,0,0,102,102,102,102,102,60,0,0,102,102,102,102,60,24,0,0,102,102,126,126,102,66,0,0,102,60,24,60,102,102,0,0,102,102,60,24,24,24,0,0,126,48,24,12,6,126,0,56,12,12,6,12,12,56,0,24,24,24,24,24,24,24,24,14,24,24,48,24,24,14,0,44,26,0,0,0,0,0,0,0,28,54,28,0,0,0,0,255,255,255,255,255,255,255,255,85,170,85,170,85,170,85,170,0,195,255,189,189,255,126,0,60,126,255,129,195,231,126,60,17,68,17,68,17,68,17,0,4,12,252,124,62,63,48,32,60,110,223,255,255,255,126,60,102,255,255,255,126,60,24,0,24,60,102,231,102,60,24,0,24,24,0,60,90,24,60,102,60,126,255,126,82,82,94,0,60,110,231,227,227,231,110,60,0,255,153,153,255,129,255,0,56,120,216,24,30,31,14,0,0,126,195,219,219,195,126,0,8,28,62,127,62,28,8,0,0,0,0,0,85,0,0,0,60,118,231,199,199,231,118,60,0,8,28,127,62,28,54,0,127,34,20,8,8,20,42,127,60,126,231,195,129,255,126,60,0,5,82,32,0,0,0,0,0,17,42,68,0,0,0,0,0,126,219,231,231,219,126,0,255,0,255,0,255,0,255,0,85,85,85,85,85,85,85,85,255,129,129,129,129,129,129,255,255,195,165,153,153,165,195,255,0,126,62,30,62,118,34,0,8,28,62,127,127,62,8,62,8,28,28,107,127,107,8,28,28,34,73,93,73,34,28,0"))


--tiny ecs v1.1
--by katrinakitten
--adapted by cpiod

function ent()
 return setmetatable({},{
  __index=function(self,a)
   for k,t in pairs(self) do
    local r=t[a]
    if(r) return r
   end
   return nil
  end,
  __newindex=function(self,a,v)
   for k,t in pairs(self) do
    local r=t[a]
    if(r) t[a]=v return
   end
   printh("not found! "..a)
   assert(false)
  end,
  __add=function(self,cmp)
   assert(cmp._cn)
   rawset(self,cmp._cn,cmp)
   return self
  end,
  __sub=function(self,cn)
   assert(rawget(self,cn)!=nil) -- le composant existait
   self[cn]=nil
   return self
  end
  })
end

function cmp(cn,t)
 t=t or {}
 t._cn=cn
 return t
end

function sys(cns,f)
 return function(ents,...)
  assert(ents)
  for e in all(ents) do
   for cn in all(cns) do
    if(rawget(e,cn)==nil) goto _
   end
   f(e,...)
   ::_::
  end
 end
end
-->8
-- update

function _update()
 local restart=true
 local restart_nb=4
 while restart and restart_nb>0 do
  restart=false
  restart_nb-=1
	 if status==12 then
	  search_next_entity()
	  if acting_ent.blob then
	   if acting_ent==current_blob then
	    status=10
	   else
	    status=13
	   end
	  elseif acting_ent.monster then
	   status=11
	  else
	   assert(false)
	  end
	 end
 
	 update_input()
	 if status==10 then
	  local dur=player_input()
	  consume_inputs()
	  if mget(current_blob.x,current_blob.y)==35 then
	   mapgen()
	  end
	  if(dur>0) status=12 acting_ent.t+=dur restart=true
	 elseif status==11 then
   local dur=monster_act()
	  if(dur==0) dur=get_wait_dur()
	  acting_ent.t+=dur
	  restart=true
	  status=12
	 elseif status==13 then
	  local dur=do_atk(acting_ent)
	  if(dur==0) dur=get_wait_dur()
	  acting_ent.t+=dur
	  restart=true
	  status=12
	 end
	 
  sys_suffers(ents)
  sys_dead(ents)
  
 end
 
 if dirty_cells then
  update_tx_ty(ents)
  remove_dead_tiles()
  create_tiles(ents,true)
  dirty_cells=false
	 update_los_all()
--		 printh("dirty_cell")
	 redraw_heavy=true
	 local found=false
	 for e in all(ents) do
	  if(e.blob) found=true e.target=search_target(e)
	 end
	 -- game over
	 if(not found) status=20
 elseif rerender then
  create_tiles_one_blob(current_blob,false)
  update_los_one()
  redraw_light=true
  current_blob.target=search_target(current_blob)
 end
 rerender=false
end

function try_move(x,y,p,pressed,short,long)
 -- wall?
 if(not fget(mget(x,y),0)) return 0
 e=check_collision(x,y)
 -- collision
 if e then
  if e.blob then
   if pressed or short then
    if(shake==0) add_msg("mERGING!",nil,15)
    shake=3
    whoshake={e,current_blob}
    return 0
   elseif long then
    merge(e)
   else
    assert(false)
   end
  else -- not a blob
   return 0
  end
 end
 -- successful move
 if short or long then
  screen_dx=(x-p.x)*5
  screen_dy=(y-p.y)*5  
  p.x=x
  p.y=y
  -- cells didn't change
  rerender=true
  return get_move_dur(current_blob)
 end
 return 0
end

function search_next_entity()
 local min_turn=nil
 for e in all(ents) do
  local t=rawget(e,"turn")
  if t then
   assert(t.t>=turn)
   if min_turn==nil or t.t<min_turn then
    acting_ent=e
    min_turn=t.t
   end
  end
 end
 turn=min_turn
end

function change_focus()
 local min_blob=nil
 local min_t=nil
 for e in all(ents) do
  if e!=current_blob
   and e.blob!=nil
   and (min_t==nil or e.t<min_t) then
   min_blob=e
   min_t=e.t
  end  
 end
 if min_blob!=nil then
  current_blob=min_blob
  changed_focus=5
 end
end

function merge(b2)
 local b=current_blob
 bm = b2.first > b.first and b2 or b
 curr_last=min(b2.last,b.last)
 while(bm.first!=curr_last+1) do
  local found=false
  for e in all(ents) do
   -- potentiellement nil
   if e.last==bm.first-1 then
    found=true
    local tmpl=bm.last
    bm.last=e.first+(bm.last-bm.first)
    bm.first=e.first
    e.first=tmpl-(e.last-e.first)
    e.last=tmpl
    break
   end
  end
  if not found then
   bm.first-=1
   bm.last-=1
  end
 end
 b.first=min(b2.first,b.first)
 b.last=max(b2.last,b.last)
 del(ents,b2)
 dirty_cells=true
end

function change_class()
 current_blob-="class"
 current_blob+=cmp("class",inv[selected_class+1])
 changed_focus=5
 current_blob.target=search_target(current_blob)
end

function check_collision(x,y)
 for e in all(ents) do
  if(e.x==x and e.y==y) return e
 end
end

-->8
-- draw

hx=2
hy=2
skip=0
shake=0
whoshake={}

function _draw()
 if redraw_light or redraw_heavy or screen_dx!=0 or screen_dy!=0 then
  update_screen_dxdy()
  nodithering(redraw_heavy)
  dithering(100)
 else
  dithering(300)
 end
 draw_background_entities()
 if(show_map) draw_map()
 if(show_classes) draw_classes()
-- ?nice_print("T:"..turn,0,121)
 draw_msg()
 draw_mouse()
 if(show_controls) draw_controls()
 if(status==20) nice_print("game over!",nil,60,8)
end

function draw_mouse()
 if stat(32)!=mouse_last_x or stat(33)!=mouse_last_y then
  mouse_last_x=stat(32)
  mouse_last_y=stat(33)
  mouse_last_move=t()
 end
 if t()-mouse_last_move<2 then
  palt(0,true)
  spr(25,stat(32)-1,stat(33)-1)
	 palt(0,false)
	 local found=nil
	 local tx=(stat(32)-hx-1)\5
	 local ty=(stat(33)-hy-1)\5
	 local t=tiles[tx+ty*24]
 	 -- no tile on frontier
  if t and not t.f then
   local mx=t.x
   local my=t.y
   local mnb=mx+my*42
   local y=stat(33)>64 and stat(33)-9 or stat(33)+6
			if losb[mnb] then
	   for e in all(ents) do
	    local p=rawget(e,"pos")
	    if p!=nil and mx==p.x and my==p.y then
	     local t=rawget(e,"desc").txt
	     x=stat(32)-#t*4
	     if(x+#t*8>128) x=128-#t*8
	     if(x<0) x=0
	     found=e
					 nice_print(t,x,y)
					 break
	    end
	   end
	   if not found then
	    local m=mget(mx,my)
	    local t=nil
	    if(m==35) t="nEXT LEVEL!"
	    if(m==38) t="pREVIOUS LEVEL"
	    if(t) then
	    	x=stat(32)-#t*4
	     if(x+#t*8>128) x=128-#t*8
	     if(x<0) x=0
	     nice_print(t,x,y)
	    end
	   end
	  end
	 end
	 if(found) nice_print("cLICK FOR MORE",nil,115)
 end
end

function add_msg(text,col,dur)
 add(msg,{text,dur or 30,col})
end

function draw_controls()
 nice_print("gAMES cONTROLS",nil,10) 
 nice_print("c (SHORT PRESS)",nil,25)
 nice_print("sHOW/HIDE MAP",nil,33,6)
 nice_print("c (LONG PRESS)",nil,45)
 nice_print("sPLIT THE BLOB",nil,53,6)
 nice_print("z (SHORT PRESS)",nil,65)
 nice_print("aTK/nEXT BLOB",nil,73,6)
 nice_print("z (LONG PRESS)",nil,85)
 nice_print("CHANGE SPECIES",nil,93,6) 
 nice_print("mOUSE",nil,105)
 nice_print("gET MORE INFO",nil,113,6)
end

function nice_print(t,x,y,c)
 x=x or 64-#t*4
 t="\014"..t
 for dx=-1,1 do
  for dy=-1,1 do
   ?t,x+dx,y+dy,0
  end
 end
 ?t,x,y,c or 7
end

function draw_msg()
 local y=50
 for m in all(msg) do
  m[2]-=1
  if(m[2]==0) del(msg,m)
  nice_print(m[1],nil,y,m[3])
  y+=8
 end
end

function update_screen_dxdy()
	if(screen_dx>0) screen_dx-=1
	if(screen_dy>0) screen_dy-=1
	if(screen_dx<0) screen_dx+=1
	if(screen_dy<0) screen_dy+=1
end

function draw_classes(right)
 local nb,w,h,x,y=0,62,38,33,2
 if(right) x=65
 for c in all(inv) do
  local col=nb==selected_class and 7 or 6
  local col2=nb==selected_class and class_attr[c.c].c1 or class_attr[c.c].c2
  rectfill(x,y,x+w-1,y+h,col2)
  rectfill(x+1,y+1,x+w-2,y+h-1,col)
  ?c.adj..": "..desc[c.adj][1],x+2,y+2,col2
  ?desc[c.adj][2],x+2,y+8,col2
  ?desc[c.adj][3],x+2,y+14,col2
  color(nb==selected_class and 5 or 1)
  ?"aTK   "..c.atk,x+1,y+20
  ?"aTKsPD "..(12-c.atkspd),x+30,y+20
  ?"aRMOR "..c.armor,x+1,y+26
  ?"mOVsPD "..(12-c.movspd),x+30,y+26
  if c.rangemax==c.rangemin then
   ?"rANGE "..c.rangemin,x+1,y+32
  elseif c.rangemax then
   ?"rANGE "..c.rangemin.."-"..c.rangemax,x+1,y+32
  else
   ?"rANGE "..c.rangemin.."+",x+1,y+32
  end
  nb+=1
  y+=h+3
 end
end

function draw_map()
 rectfill(21,21,107,107,0)
 for x=0,41 do
  local sx=22+2*x
  for y=0,41 do
   if seen[x+42*y] then
	   local sy=22+2*y
	   if(losb[x+42*y]) pal(1,13) pal(5,6)
	   m=mget(x,y)
	   if m==33 or m==38 then
	    rectfill(sx,sy,sx+1,sy+1,1)
	   elseif m>=48 then
	    rectfill(sx,sy,sx+1,sy+1,5)
				elseif m==36 then
				 fillp(▒-.5)
				 rectfill(sx,sy,sx+1,sy+1,0x15)
				 fillp()
				elseif m==35 then
				 fillp(▒-.5)
				 rectfill(sx,sy,sx+1,sy+1,0x51)
				 fillp()
	   end
	   pal(1,1)
	   pal(5,5)
	  end
  end
 end
	fillp(▒-.5)
	pal(13,1)
 for e in all(ents) do
	 local p=rawget(e,"pos")
	 if p then
	  if losb[p.x+42*p.y] then
		 	local c=class_attr[rawget(e,"class").c]
		 	local col=(c.c1<<4)+c.c1
		 	if rawget(e,"blob")==nil then
	 	 	col=(c.c1<<4)+c.c2
		 	end
		  local sx=22+2*p.x
		  local sy=22+2*p.y
		 	if e==current_blob then
	 	  rectfill(sx-1,sy,sx+2,sy+1,col)
	 	  rectfill(sx,sy-1,sx+1,sy+2,col)
		 	else
	 	  rectfill(sx,sy,sx+1,sy+1,col)
		  end
		 end
	 end
	end
 pal(13,13)
	fillp()
end

function draw_background_entities()
	palt(1,true)
	if(shake>0) shake-=1
	-- tiles
	for x=0,23 do
	 for y=0,23 do
 	 local i=x+24*y
 	 -- tile dead ?
 	 -- no tile on frontier
	  if tiles[i] and not tiles[i].f then
	   local mx=tiles[i].x
	   local my=tiles[i].y
	   local mnb=mx+my*42
	   if seen[mnb] then
	    local m=mget(mx,my)
	    if(m!=0) then
		    local sx=hx+5*x+1
		    local sy=hy+5*y
		    if (screen_dx!=0 or screen_dy!=0) and tiles[i].b==current_blob then
		     if (screen_dx<0 and tiles[i-1].f)
		        or (screen_dx>0 and tiles[i+1].f)
		        or (screen_dy<0 and tiles[i-24].f)
		        or (screen_dy>0 and tiles[i+24].f) then
		        goto skip
		     end
	      sx+=screen_dx
	      sy+=screen_dy
		    end
		    if shake>0 then
		     local b=tiles[i].b
	      if b==whoshake[1] or b==whoshake[2] then
						  palt(0,true)
	       sx+=rnd(2)-1
	       sy+=rnd(2)-1
	      end
						end
						if(not losb[mnb]) pal(6,5)
						if m==33 then
						 sspr(9,18,3,3,sx+1,sy+2)
						elseif m>48 then
						 sspr(8*(m-48),25,5,5,sx,sy+1)
						else
 						spr(m,sx,sy)						
						end
						palt(0,false)
 					pal(6,6)
 					if losb[mnb] then
			    for e in all(ents) do
			     local p=rawget(e,"pos")
			     if p!=nil and mx==p.x and my==p.y then
								 local ch=rawget(e,"render").char
		 	     local col=class_attr[rawget(e,"class").c].c1
		 	     local col2=class_attr[rawget(e,"class").c].c2
		  	    pal(6,col)
		 	     if(tiles[i].b==e) pal(0,col) pal(6,col2)
	   	    if(tiles[i].b.target==e) circfill(sx+2,sy+3,3+(t()*4)%2,8)
	   	    spr(ch,sx,sy)
		  	    pal(6,6)
		  	    pal(0,0)
			     end
			    end
		    end
	    end
	   end
 	 end
 	::skip::
	 end
	end
	palt(1,false)
end

function nodithering(heavy)
 redraw_light=false
 redraw_heavy=false
 clip(hx,hy,120,120)
 -- not los, not frontier
 for tx=0,23 do
  for ty=0,23 do
   local i=tx+ty*24
	  local t=tiles[i]
   local x=hx+5*tx
   local y=hy+5*ty
	  if t and not t.f and not losb[t.x+42*t.y] then
	   if t.b==current_blob then
	  	 x+=screen_dx
	  	 y+=screen_dy
--		  	if (screen_dx<0 and tiles[i-1].f)
--			    or (screen_dx>0 and tiles[i+1].f)
--			    or (screen_dy<0 and tiles[i-24].f)
--			    or (screen_dy>0 and tiles[i+24].f) then
--		   else
	  	  rectfill(x,y,x+4,y+4,1)
--	  	 end
  	 elseif heavy then
  	  rectfill(x,y,x+4,y+4,1)
	  	end
   end
  end
 end
 -- los, not frontier
 for tx=0,23 do
  for ty=0,23 do
   local i=tx+ty*24
	  local t=tiles[i]
   local x=hx+5*tx
   local y=hy+5*ty
	  if t and losb[t.x+42*t.y] and not t.f then
	   if t.b==current_blob then
 	  	--x+=screen_dx
 	  	--y+=screen_dy
-- 		  if (screen_dx<0 and tiles[i-1].f)
--			    or (screen_dx>0 and tiles[i+1].f)
--			    or (screen_dy<0 and tiles[i-24].f)
--			    or (screen_dy>0 and tiles[i+24].f) then
--		   else
 	  	 circfill(x+3,y+3,3,13)	
-- 	  	end
 	  elseif heavy then
 	   circfill(x+3,y+3,3,13)
	  	end
   end
  end
 end
 -- frontier
 for tx=0,23 do
  for ty=0,23 do
	  local t=tiles[tx+ty*24]
   local x=hx+5*tx
   local y=hy+5*ty
	  if t and t.f and (t.b==current_blob or heavy) then
	   local colors=class_attr[rawget(t.b,"class").c]
	   local c=t.b==current_blob and colors.c1 or colors.c2
	   circfill(x+3,y+3,2,c)
--	  elseif t==nil and heavy then
--	  	rectfill(x,y,x+4,y+4,0)
   end
  end
 end
 clip()
end

function dithering(imax)
	for i=1,imax do
	 local x=rnd(127)
	 local y=rnd(127)
	 local c=nil
	 local r=1
	 if x<hx or x>=hx+5*24 or y<hy or y>=hy+5*24 then
	  c=0
	 else
	  local tx=(x-hx)\5
	  local ty=(y-hy)\5
	  local t=tiles[tx+ty*24]
	  if t and t.f then
 	  local thres=.1 -- color
 	  local chance=1
		  -- current blob has bigger frontier
	   if t.b==current_blob then
	    if(imax>200 and changed_focus==0) chance=.5
	    r=3
	    thres=.9
	   end
	   
	   if rnd()<chance then
				 local colors=class_attr[rawget(t.b,"class").c]
					if rnd()>thres then
		    c=colors.c2
		   else
		    c=colors.c1
		   end
    end
	  elseif t then
		  c=losb[t.x+42*t.y] and 13 or 1
	  else
	   c=0
	  end
	 end
  if(c!=nil) circfill(x,y,r,c)
	end
	if(changed_focus>0) changed_focus-=1
end

-->8
-- map generation

-- flags:
-- 0: traversable
-- 1: transparent

function mapgen()
 nice_print("map gen",nil,60)
 flip()
 first_step()
 second_step()
 set_bitset_wall()
 populate()
 
 los={}
 losb={}
 seen={}
 for i=0,41 do
  for j=0,41 do
   los[i+j*42]={}
   losb[i+j*42]=false
   seen[i+j*42]=false
  end
 end
 rerender=true
end

function first_step()
-- crude mapgen
 local dx=100
 for x=dx,dx+19 do
  for y=0,19 do
   mset(x,y,2)
  end
 end
 local seedx=dx+rnd(20)&-1
 local seedy=rnd(20)&-1
 local free=1
 mset(seedx,seedy,1)
 while free<200 do
  local x=dx+rnd(20)&-1
  local y=rnd(20)&-1
  local prevx,prevy=nil,nil
  while mget(x,y)==2 do
   prevx=x
   prevy=y
   local d=dir[rnd(4)&-1]
   x+=d[1]
   y+=d[2]
   if(x<dx) x=dx
   if(y<0) y=0
   if(x>dx+19) x=dx+19
   if(y>19) y=19
  end
  if(prevx) mset(prevx,prevy,1) free+=1
 end
 for x=0,41 do
  for y=0,41 do
   -- border
   if x==0 or y==0 or x==41 or y==41 then
    mset(x,y,2)
   else
	   local x2=(x-1)\2
	   local y2=(y-1)\2
	   mset(x,y,mget(x2+dx,y2))
   end
  end
 end
end

function second_step()
 -- generate layout with automata
 local dx=80
 for x=0,4 do
  for y=0,4 do
	  mset(x+dx,y,rnd(2)&-1)
	 end
 end

 -- modify map
 for i=0,500 do
  local x=1+rnd(40)&-1
  local y=1+rnd(40)&-1
  local t=mget(dx+x\10,y\10)
  local w=mget(x,y)==2
  local k=0
  for x2=-1,1 do
   for y2=-1,1 do
    if((x2!=0 or y2!=0) and mget(x+x2,y+y2)==2) k+=1
   end
  end
  
  if t==0 then
  -- big open space
   if(w and k>1 and k<6) mset(x,y,1)
  elseif t==1 then
  -- pillars
   if(x&1==0 and y&1==0 and not w and k==0) mset(x,y,2)
   if(w and k>0 and k<3) mset(x,y,1)
  end
 end
end

function populate()
 if current_blob==nil then
  spawn_first_blob()
 else
  reset_blob()
 end
 mset(current_blob.x,current_blob.y,38)
 local maxdist=nil
 local bestx,besty=nil,nil
 for i=1,10 do
  local x,y=get_empty_space()
  local dx=abs(x-current_blob.x)
  local dy=abs(y-current_blob.y)
  local dist=dx+dy-0.56*min(dx,dy)
  if maxdist==nil or dist>maxdist then
   maxdist=dist
   bestx=x
   besty=y
  end
 end
 mset(bestx,besty,35)
 
 for i=1,10 do
  add_monster()
 end
end

function get_empty_space()
 local x,y=nil,nil
 while mget(x,y)!=33 do
  x=rnd(40)&-1
  y=rnd(40)&-1
 end
 return x,y
end

function set_bitset_wall()
local delta={[0]={0,-1},{1,0},{0,1},{-1,0}}
for x=0,41 do
 for y=0,41 do
  local val=mget(x,y)
  if val==2 then
	  local b=0
	  for i=0,3 do
	   local x2=x+delta[i][1]
	   local y2=y+delta[i][2]
	   if x2>=0 and x2<42 and y2>=0 and y2<42 and (mget(x2,y2)==2 or mget(x2,y2)>=48) then
	    b+=1<<i
	   end
	  end
   mset(x,y,48+b)
	 elseif val>0 then
	  mset(x,y,val+32)
  end
 end
end

end
-->8
-- tiles

-- hilbert/cells init (once)
hilb={[0]={0,0},{0,1},{1,1},{1,0},{2,0},{3,0},{3,1},{2,1},{2,2},{3,2},{3,3},{2,3},{1,3},{1,2},{0,2},{0,3},{0,4},{1,4},{1,5},{0,5},{0,6},{0,7},{1,7},{1,6},{2,6},{2,7},{3,7},{3,6},{3,5},{2,5},{2,4},{3,4},{4,4},{5,4},{5,5},{4,5},{4,6},{4,7},{5,7},{5,6},{6,6},{6,7},{7,7},{7,6},{7,5},{6,5},{6,4},{7,4},{7,3},{7,2},{6,2},{6,3},{5,3},{4,3},{4,2},{5,2},{5,1},{4,1},{4,0},{5,0},{6,0},{6,1},{7,1},{7,0}}
cells={}
tiles={}

for i=0,#hilb do
 local x,y=unpack(hilb[i])
 cells[x+y*8]=i
end

function create_tiles_one_blob(b,renew)
 for c=b.first,b.last do
  local cxb,cyb=unpack(hilb[c])
  local cx=3*cxb
  local cy=3*cyb
  local x=b.x+cx-b.tx
  local y=b.y+cy-b.ty
  local first=b.first
  local last=b.last
  for dx=0,2 do
   for dy=0,2 do
    local i=(cx+dx)+(cy+dy)*24
    local f=false
    if(renew and (dx!=1 or dy!=1)) then
     f=is_frontier(first,last,cxb,cyb,dx,dy)
     if(dy!=1) f=f or is_frontier(first,last,cxb,cyb,dx,1)
     if(dx!=1) f=f or is_frontier(first,last,cxb,cyb,1,dy)
    elseif not renew then
     f=tiles[i].f
    end
    tiles[i]={x=x+dx,y=y+dy,b=b,f=f}
   end
  end
 end
end

-- renew=true when the cells shapes change
-- update_tx_ty must be called before!
create_tiles=sys({"blob"},create_tiles_one_blob)

function remove_dead_tiles()
 local t={}
 for e in all(ents) do
  if e.blob then
	  for c=e.first,e.last do
	   t[c]=true
	  end
  end
 end
 for i=0,24*24-1 do
  if(not t[c]) tiles[i]=nil
 end
end

function is_frontier(first,last,cxb,cyb,dx,dy)
 cxb+=dx-1
 cyb+=dy-1
 local n=cells[cxb+cyb*8]
 return n==nil or cxb<0 or cyb<0 or cxb>7 or cyb>7 or n<first or n>last
end

-- where is the @ on screen ?
update_tx_ty=sys({"blob"},
function(b)
 local best_cnt=10
 local best={}
 local centerx,centery=0,0
 local first=b.first
 local last=b.last
 for c=first,last do
  local cxb,cyb=unpack(hilb[c])
  local cnt=0
  centerx+=cxb
  centery+=cyb
  for dx=-1,1 do
   for dy=-1,1 do
    if(dx!=0 or dy!=0) then
 	   local cxb2=cxb+dx
 	   local cyb2=cyb+dy
 	   local n=cells[cxb2+cyb2*8]
 	   if(n==nil or cxb2<0 or cyb2<0 or cxb2>7 or cyb2>7 or n<first or n>last) then
 	    if dx==0 or dy==0 then
  	    cnt+=1
  	   else
  	    cnt+=.5
  	   end
 	   end
	   end
   end
  end
  if cnt<best_cnt then
   best_cnt=cnt
   best={c}
  elseif cnt==best_cnt then
   add(best,c)
  end
 end
 centerx=1+3*centerx/(last-first+1)
 centery=1+3*centery/(last-first+1)
 assert(#best>0)
 local mindist=5000
 for c in all(best) do
  local cxb,cyb=unpack(hilb[c])
  for x2=0,2 do
   for y2=0,2 do
    local newx=3*cxb+x2
    local newy=3*cyb+y2
		  local dx=abs(newx-centerx)
		  local dy=abs(newy-centery)
		  local dist=dx+dy-0.56*min(dx,dy) -- diagonal distance
		  if dist<mindist then
		   bestdistx=newx
		   bestdisty=newy
		   mindist=dist
		  end
	  end
  end
 end
 b.tx=bestdistx
 b.ty=bestdisty
end)

-->8
-- spawn
class_attr={[0]={c1=10,c2=9},
{c1=8,c2=4},
{c1=11,c2=3},
{c1=14,c2=2},
{c1=12,c2=13}}

ename={[0]="pHd sTUDENT","pROFESSOR","cHEMIST","jANITOR","hAZMAT TECH"}
bname={[0]="pH. vOLEXUM","pH. pOTENSUM","pH. jACTARUM","pH. sOLLICITUM","pH. lENTUSUM"}
adj={"bASIC"}

desc={bASIC={"JUST A","REGULAR BLOB.",""}}

default_classes={
[0]={c=0,adj="bASIC",atk=5,atkspd=10,
 armor=2,movspd=6,rangemin=1,rangemax=1},
{c=1,adj="bASIC",atk=8,atkspd=16,
 armor=4,movspd=16,rangemin=1,rangemax=1},
{c=2,adj="bASIC",atk=6,atkspd=16,
 armor=1,movspd=10,rangemin=2,rangemax=8},
{c=3,adj="bASIC",atk=3,atkspd=2,
 armor=3,movspd=14,rangemin=1,rangemax=1},
{c=4,adj="bASIC",atk=2,atkspd=10,
 armor=7,movspd=10,rangemin=1,rangemax=1}}

function add_monster()
 local x,y=nil,nil
 while not can_move_to(x,y) do
  x=1+rnd(40)&-1
  y=1+rnd(40)&-1
 end
 local c=default_classes[4]
 local e=ent()+cmp("monster",{hp=9})
 e+=cmp("pos",{x=x,y=y})
 e+=cmp("class",c)
 e+=cmp("render",{char=e.hp+15})
 e+=cmp("desc",{txt=ename[c.c]})
 add(ents,e)
 rerender=true
end

function reset_blob()
 local hp=0
 for e in all(ents) do
  if(e.blob) hp+=e.last-e.first+1
 end
 ents={}
 local b=current_blob
 add(ents,b)
 b.first=0
 b.last=hp-1
 b.target="" 
 b.x,b.y=get_empty_space()
 dirty_cells=true
end

function spawn_first_blob()
 inv={default_classes[3],default_classes[2],default_classes[3]}
 local x,y=get_empty_space()
 local b=ent()+cmp("blob",{first=0,last=63,tx=-1,ty=-1,target=""})
 b+=cmp("pos",{x=x,y=y})
 b+=cmp("class",inv[1])
 b+=cmp("render",{char=32})
 b+=cmp("turn",{t=0})
 b+=cmp("desc",{txt="yOUR BLOB"})
 add(ents,b)
 current_blob=b
 dirty_cells=true
end

function split_blob()
 local b=current_blob
 local s=(b.last+b.first)\2
 local b2=ent()
 b2+=cmp("blob",{first=s+1,last=b.last,tx=-1,ty=-1,target=""})
 b2+=cmp("class",b.class)
 b2+=cmp("pos",{x=b.x+1,y=b.y})
 b2+=cmp("render",{char=b.char})
 b2+=cmp("turn",{t=b.t+get_split_dur()})
 b2+=cmp("desc",{txt="yOUR BLOB"})
 add(ents,b2)
 b.last=s
 dirty_cells=true
end

-- components
-- blob: first last tx ty target
-- monster: hp
-- pos: x y
-- class: c adj atk atkspd armor
--   movspd rangemin rangemax
-- render: char
-- turn: t
-- desc: txt
-- suffers: dmg

-- class:
-- 0: move speed
-- 1: dps
-- 2: range
-- 3: atk speed
-- 4: armor
-->8
-- input

input={[0]=0,0,0,0,0,0}
short={[0]=false,false,false,false,false,false}
long={[0]=false,false,false,false,false,false}
dir={[0]={-1,0},{1,0},{0,-1},{0,1}}
-- gauche droite haut bas o x
function update_input()
 for i=0,5 do
  if btn(i) then
   if(input[i]>=0) input[i]+=1
   if input[i]==20 then
    long[i]=true
    input[i]=0
   end
  else -- release
   if input[i]>0 then
    short[i]=true
   end
   input[i]=0
  end
 end
end

function consume_inputs()
 for i=0,5 do
  short[i]=false
  long[i]=false
 end
end

function player_input()
 if show_controls then
  for i=0,5 do
   if(short[i]) show_controls=false
  end
 elseif show_classes then
  if(short[2] and selected_class>0) selected_class-=1
  if(short[3] and selected_class<2) selected_class+=1
  if(short[5]) then
   show_classes=false
   if current_blob.class==inv[selected_class+1] then
    add_msg("nO CHANGE")
    return 0
   else
    change_class()
    return get_change_class_dur()
   end
  end
  if(short[4]) show_classes=false
 else	
	 -- while the map is open, move and change focus are the only action accepted
	 local p=current_blob.pos
	 local x,y=p.x,p.y
	 local move=false
	 for i=0,3 do
	  if short[i] or long[i] or input[i]>0 then
	   x=p.x+dir[i][1]
	   y=p.y+dir[i][2]
	   local m=try_move(x,y,p,input[i]>0,short[i],long[i])
	   if(m>0) return m
	  end
	 end
	 if(short[5]) then
	  change_focus()
	  local dur=do_atk(current_blob)
	  if(dur==0) dur=get_wait_dur()
	  return dur
	 end
	
	 if show_map then
	  if(short[4]) show_map=false
	 else
		 if long[5] then
	   input[5]=-1
	   show_classes=true
	   selected_class=0
	   return 0
		 end
		 if(input[4]>5) then
		  if(shake==0) add_msg("sPLITTING!",nil,15)
 		 shake=2
 		 whoshake={current_blob}
 		end
		 
		 if(short[4]) show_map=true
		 if long[4] then
		  input[4]=-1
		  if current_blob.last-current_blob.first>=8 then
		   split_blob()
		   return get_split_dur()
		  else 
		   add_msg("too small to split!")
		  end
		 end
		end
	end
 return 0
end

function get_wait_dur()
 return 6
end

function get_change_class_dur()
 return 10
end

function get_split_dur()
 return 5
end

function get_atk_dur(b)
 return b.atkspd
end

function get_move_dur(b)
-- if(b.blob) return b.movspd+(1+b.last-b.first)\8
 return b.movspd
end

function get_dmg(b)
-- if(b.blob) return b.atk+(1+b.last-b.first)\16
 return b.atk
end
-->8
-- los

function update_los_all()
	for i=0,42*42-1 do
	 losb[i]=false
	 los[i]={}
	end
	for e in all(ents) do
	 if(e.blob!=nil) update_los(e)
 end
end

function update_los_one()
 for i=0,42*42-1 do
  if losb[i] then
	  -- only recompute los of current blob
	  los[i][current_blob]=nil
	  losb[i]=false
	  for k,v in pairs(los[i]) do
	   losb[i]=true
	   break
	  end
  end
 end
 update_los(current_blob)
end

function update_los(b)
 local p=b.pos
 local k=0
 -- current position is visible
 local i=p.x+42*p.y
	los[i][b]=true
	losb[i]=true
	seen[i]=true 
 while k<#table_los do
  if(table_los[k+1]!="") then
	  local x,y=p.x+table_los[k+1],p.y+table_los[k+2]
	  i=x+42*y
	  if x>=0 and x<42 and y>=0 and y<42 then
		  if not los[i][b] then
			  los[i][b]=true
			  losb[i]=true
			  seen[i]=true
			  wakeup(x,y)
			  if not fget(mget(x,y),1) then
			   k=(k&0xfff0)+16
			  else
			   k+=2
			  end
			 elseif fget(mget(x,y),1) then
			  k+=2
			 else
			  k=(k&0xfff0)+16
			 end
		 else
		  k=(k&0xfff0)+16 -- oob
		 end
  else
   k=(k&0xfff0)+16
  end
 end
end
-->8
-- ai/fight

function do_atk(b)
 local target=search_target(b)
 if target!="" then
  target+=cmp("suffers",{dmg=get_dmg(b)})
  return get_atk_dur(b)
 else
  return 0
 end
end

sys_suffers=sys({"suffers"},function(e)
 local dmg=max(1,e.dmg-e.armor)
 e-="suffers"
 if(dmg>0) lose_hp(e,dmg)
end)

sys_dead=sys({"dead"},function(e)
 del(ents,e)
 if(e.monster) xp+=1
end)

function can_move_to(x,y)
 return fget(mget(x,y),0) and check_collision(x,y)==nil
end

function move_to_target(e,target)
 local targetx,targety=target.x,target.y
 local dx=abs(e.x-targetx)
 local dy=abs(e.y-targety)
 local d=dx+dy-0.56*min(dx,dy)
 if d<e.rangemin then
  -- go away if enemy too close
  targetx=2*e.x-target.x
  targety=2*e.y-target.y
  dx=abs(e.x-targetx)
  dy=abs(e.y-targety)
 end
 local newx,newy=nil,nil
 if dx>dy then
  if(targetx>e.x) newx=e.x+1 newy=e.y
  if(targetx<e.x) newx=e.x-1 newy=e.y
  if(not can_move_to(newx,newy)) newx=nil newy=nil
 end
 if newx==nil then
  if(targety>e.y) newy=e.y+1 newx=e.x
  if(targety<e.y) newy=e.y-1 newx=e.x
  if(not can_move_to(newx,newy)) newx=nil newy=nil
 end
 if newx==nil then
  if(targetx>e.x) newx=e.x+1 newy=e.y
  if(targetx<e.x) newx=e.x-1 newy=e.y
  if(not can_move_to(newx,newy)) newx=nil newy=nil
 end
 return newx,newy
end

function search_target(b,ignore_range)
 target=""
 disttarget=nil
 for e in all(ents) do
  if enemies(b,e) and can_see(b,e) then
   dx=abs(e.x-b.x)
   dy=abs(e.y-b.y)
   d=dx+dy-0.56*min(dx,dy)
   if ignore_range or d>=b.rangemin and (not b.rangemax or d<=b.rangemax) then
    if(disttarget==nil or d<disttarget) disttarget=d target=e
   end
  end
 end
 return target
end

function can_see(e1,e2)
 if e1.blob then
  return los[e2.x+e2.y*42][e1]
 else
  return los[e1.x+e1.y*42][e2]
 end
end

function enemies(e1,e2)
 return (e1.blob and e2.monster) or (e1.monster and e2.blob)
end

function wakeup(x,y)
 for e in all(ents) do
  if e.monster and e.x==x and e.y==y and e.turn==nil then
   e+=cmp("turn",{t=turn+10})
  end
 end
end

function lose_hp(e,nb)
 if e.monster then
  e.hp-=nb
  e.char=e.hp+15
  if(e.hp<1) e+=cmp("dead")
 elseif e.blob then
--  shake=3
  if e.last-e.first+1<=nb then
   e+=cmp("dead")
   dirty_cells=true
   change_focus()
  else
	  for i=1,nb do
	   if rnd()<.5 then
	    e.first+=1
	   else
	    e.last-=1
	   end
	   dirty_cells=true
	  end
  end
 else
  assert(false)
 end
end

function monster_act()
 local p=acting_ent.pos
 if seen[p.x+p.y*42] then
  local dur=do_atk(acting_ent)
  if dur==0 then
   target=search_target(acting_ent,true)
   if target!="" then
	   newx,newy=move_to_target(acting_ent,target)
	   if(newx!=nil) p.x=newx p.y=newy return get_move_dur(acting_ent)
   end
  else
   return dur
  end
 end
 return 0
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000060060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000666666000660000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000060060000006600000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000060060000000060066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000600000666666000006600000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000060060000660000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11011111100111111000111110111111100011111011111110001111100011111000111101000000000000000000000000000000000000000000000000000000
10601111066011110666011106001111066601110600111106660111066601110666011116100000000000000000000000000000000000000000000000000000
06601111100601111006011106060111066011110666011110060111060601110606011116610000000000000000000000000000000000000000000000000000
10601111106011111066011106660111106601110606011110601111066601110666011116661000000000000000000000000000000000000000000000000000
06660111066601110666011110060111066601110666011110601111066601111006011116666100000000000000000000000000000000000000000000000000
10001111100011111000111111101111100011111000111111011111100011111110111116611000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111101161000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000
11011111111111111111111110111111111111111111111111101111000000000000000000000000000000000000000000000000000000000000000000000000
10601111111111111100111107011111110111111111111111060111000000000000000000000000000000000000000000000000000000000000000000000000
06060111110111111066011110701111106011111111111110601111000000000000000000000000000000000000000000000000000000000000000000000000
06001111106011111066011110070111066601111161111106001111000000000000000000000000000000000000000000000000000000000000000000000000
10660111110111111066011107701111106011111111111110660111000000000000000000000000000000000000000000000000000000000000000000000000
11001111111111111100111110011111110111111111111111001111000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
10001111066601111000011106660111100011110666011111000111066601110000111106660111000001110666011100011111066601110000011106660111
06660111066601110666611106666111066601110666011110666111066661116666011166660111666661116666611166601111666601116666611166666111
06660111066601110666611106666111066601110666011106666111066661116666011166660111666661116666611166660111666601116666611166666111
06660111066601110666611110666111066601110666011106666111066661116666011166601111666661116666611166660111666601116666611166666111
10001111100011111000011111000111066601110666011106660111066601110000111100011111000001110000011106660111066601110666011106660111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888eeeeee888777777888eeeeee888eeeeee888eeeeee888eeeeee888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88ee88eee88778887788ee888ee88ee8e8ee88ee888ee88ee8eeee88888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee8eeee8eee8777778778eeeee8ee8eee8e8ee8eee8eeee8eee8eeee88888e88888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8eeee8eee8777888778eeee88ee8eee888ee8eee888ee8eee888ee8888eee8888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee8eeee8eee8777877778eeeee8ee8eeeee8ee8eeeee8ee8eee8e8ee88888e88888888888ff888ff888822228888228222888882282888222288888
888eee888ee8eee888ee8777888778eee888ee8eeeee8ee8eee888ee8eee888ee888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee8eeeeeeee8777777778eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee888888888888888888888888888888888888888888888888888888888888888
111111111111111111111eee1eee11111bbb1bb11bb11171117117111666161616661666116611111eee1e1e1eee1ee111111111111111111111111111111111
1111111111111111111111e11e1111111b1b1b1b1b1b17111117117111611616161616111611111111e11e1e1e111e1e11111111111111111111111111111111
1111111111111111111111e11ee111111bb11b1b1b1b17111117111711611666166116611666111111e11eee1ee11e1e11111111111111111111111111111111
1111111111111111111111e11e1111111b1b1b1b1b1b17111117117111611616161616111116111111e11e1e1e111e1e11111111111111111111111111111111
111111111111111111111eee1e1111111b1b1b1b1bbb11711171171111611616161616661661111111e11e1e1eee1e1e11111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111661111116611661611116616661166111111661666111111111111111111111111111111111111111111111111111111111111
11111111111111111111111116111777161116161611161616161611111116111116111111111111111111111111111111111111111111111111111111111111
11111111111111111111111116111111161116161611161616611666111116111666111111111111111111111111111111111111111111111111111111111111
11111111111111111111111116111777161116161611161616161116111116111611111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111661111116616611666166116161661117111661666111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111eee1e1111ee1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111e111e111e111e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111ee11e111eee1ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111e111e11111e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111eee1eee1ee11eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111661111116611661611116616661166111111661661111111111111111111111111111111111111111111111111111111111111
11111111111111111111111116111777161116161611161616161611111116111161111111111111111111111111111111111111111111111111111111111111
11111111111111111111111116111111161116161611161616611666111116111161111111111111111111111111111111111111111111111111111111111111
11111111111111111111111116111777161116161611161616161116111116111161111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111661111116616611666166116161661117111661666111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111eee1ee11ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111ee11e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111eee1e1e1eee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111eee1ee11ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111ee11e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111eee1e1e1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111eee1e1111ee1eee1eee1eee1111166611111eee1e1e1eee1ee11111111111111111111111111111111111111111111111111111111111111111
1111111111111e111e111e111e1111e11e1111111161111111e11e1e1e111e1e1111111111111111111111111111111111111111111111111111111111111111
1111111111111ee11e111eee1ee111e11ee111111161111111e11eee1ee11e1e1111111111111111111111111111111111111111111111111111111111111111
1111111111111e111e11111e1e1111e11e1111111161111111e11e1e1e111e1e1111111111111111111111111111111111111111111111111111111111111111
1111111111111eee1eee1ee11eee1eee1e1111111161111111e11e1e1eee1e1e1111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111116611111611116611661666177116661111161611111c1c1ccc1717166611111616117711111eee1ee11ee111111cc11ccc111111ee1eee
1111111111111111161117771611161616111616171111611111161611711c1c111c1171116111111616111711111e1e1e1e1e1e111111c1111c11111e1e1e1e
1111111111111111161111111611161616661661171111611111116117771ccc1ccc1777116111111666111711111eee1e1e1e1e111111c111cc11111e1e1ee1
111111111111111116111777161116161116161617111161111116161171111c1c111171116111111116111711111e1e1e1e1e1e111111c1111c11111e1e1e1e
111111111111111111661111166616611661166617711161117116161111111c1ccc1717116111711666117711111e1e1e1e1eee11111ccc1ccc11111ee11e1e
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111166611111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111116161777111c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111166111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111161617771c111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111161611111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111eee1e1111ee1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111e111e111e111e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111ee11e111eee1ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111e111e11111e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111eee1eee1ee11eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111116611111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111161117771c1c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111161111111c1c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111161117771c1c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111116611111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1ee11ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1e1e1eee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa11111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee1171aa66a6a6a666a666a666a66aa666a666a6a6a17111111666111111111cc111111666166616161661166616661616111111111cc11111
1111111111e11e111711a6aaa6a6a6a6a6aaa6a6a6a6aa6aaa6aa6a6a117111116161171177711c1111116661616161616161161116116161111177711c11111
1111111111e11ee11711a666a6a6a666a66aa66aa6a6aa61aa6aa666a117111116611777111111c1111116161666116116161161116116661777111111c11111
1111111111e11e111711aaa6a6a6a6aaa6aaa6a6a6a6aa171a6aa6a6a117111116161171177711c1111116161616161616161161116116161111177711c11111
111111111eee1e111171a66aaa66a6aaa666a6a6a666a617716aa6a6a17111111616111111111ccc11111616161616161666166611611616111111111ccc1111
11111111111111111111111111111111111111111111111777111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee11711166117111111cc11ccc1c111117777111bb1bbb1bbb11bb1bbb1bbb1b111b1111711616111116161111166611111166117111111111
1111111111e11e1117111611117117771c1c11c11c11111771111b1111b11b1b1b111b1111b11b111b1117111616111116161111161611111611111711111111
1111111111e11ee117111611117111111c1c11c11c11111117111b1111b11bb11b111bb111b11b111b1117111161111116661111166111111611111711111111
1111111111e11e1117111611111117771c1c11c11c11111711111b1111b11b1b1b111b1111b11b111b1117111616117111161171161611711611111711111111
111111111eee1e1111711166117111111c1c1ccc1ccc1171111111bb1bbb1b1b11bb1b111bbb1bbb1bbb11711616171116661711161617111166117111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1ee11ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1e1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822882228222888282288288822888888888888888888888888888888888888888888228888882228822828282228228882288866688
82888828828282888888882882888882882888288288882888888888888888888888888888888888888888888828888888288282828282888282828888888888
82888828828282288888882882228882882888288222882888888888888888888888888888888888888888888828888888288282822882288282822288822288
82888828828282888888882888828882882888288282882888888888888888888888888888888888888888888828888888288282828282888282888288888888
82228222828282228888822282228882828882228222822288888888888888888888888888888888888888888222888888288228828282228282822888822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000000000000000000000000000000000000000000000000000000000000000000300030103030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0102010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102010101010101010101010101010101010101020202020202020101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101020102010101010101010101010101010101010202020101010101010202020101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101020202020201010101010202020201010101010202020202020201010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101030101010201010202010101010101010101010102020202010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102010101010101020201010102010101010101010101010101010102020201010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101010101020101010102010101010101010101010101010101010201010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010202010101010101010102010101010101010202010101010101010202010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101020201010101040101010202010101010102020101020101010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104010102010101010101010101010101010101010202010101020201010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101020202020101010101010101010201010101010201010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101020101020201010101010101020201010101010102010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101040102010101010101010201010101010101020101010101010102010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101010101010201010101010101020101010101010102010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101010101010202010101010102020101010101010102010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101010101010102010101010202010101010101010202010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101020101010101010102020202020101010101010101020201010101010201010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101020201010101010101010101010101010101010202020101010101010201010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010201010101010101010101010101010202020201010101010101010201010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010201010102020201010101010101020201010101010101010101010201010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101020201010202010202010101010102020101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101020202020201010102020101010102020101010101010102020101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101020101010101020202020202020202010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
