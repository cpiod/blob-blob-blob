pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- blob blob blob
-- by cpiod for 7drl22

function _init()
 w,h,mouse_show_class,hunger_delay,changed_focus,status=62,38,nil,50,0,0
 poke(0x5f2d, 1) --enable mouse
-- show_controls=false
 msg={}
-- music(0)
	srand(2)--todo
 cls()
 palt(0,false)
 menuitem(1,"controls",function() status=status==1 and 12 or status show_controls=true end)
 menuitem(2,"toggle map",function() status=status==1 and 12 or status show_map=not show_map end)
end

-- states:
-- 0: main menu
-- 1: tutorial
-- 10: player input
-- 11: monster input
-- 12: end turn
-- 13: blob auto input
-- 14: hunger
-- 20: game over

table_los=split"-1,0,-2,-1,-3,-1,-4,-2,-5,-2,,,,,,,-1,0,-2,0,-3,-1,-4,-1,-5,-1,,,,,,,-1,0,-2,0,-3,0,-4,0,-5,0,,,,,,,-1,0,-2,0,-3,1,-4,1,-5,1,,,,,,,-1,0,-2,1,-3,1,-4,2,-5,2,,,,,,,-1,-1,-2,-2,-3,-3,-4,-4,,,,,,,,,-1,-1,-2,-1,-3,-2,-4,-3,,,,,,,,,-1,1,-2,1,-3,2,-4,3,,,,,,,,,-1,1,-2,2,-3,3,-4,4,,,,,,,,,-1,-1,-1,-2,-2,-3,-3,-4,,,,,,,,,-1,1,-2,2,-2,3,-3,4,,,,,,,,,0,-1,-1,-2,-1,-3,-2,-4,-2,-5,,,,,,,0,1,-1,2,-1,3,-2,4,-2,5,,,,,,,0,-1,0,-2,-1,-3,-1,-4,-1,-5,,,,,,,0,1,0,2,-1,3,-1,4,-1,5,,,,,,,0,-1,0,-2,0,-3,0,-4,0,-5,,,,,,,0,1,0,2,0,3,0,4,0,5,,,,,,,0,-1,0,-2,1,-3,1,-4,1,-5,,,,,,,0,1,0,2,1,3,1,4,1,5,,,,,,,0,-1,1,-2,1,-3,2,-4,2,-5,,,,,,,0,1,1,2,1,3,2,4,2,5,,,,,,,1,-1,1,-2,2,-3,3,-4,,,,,,,,,1,1,2,2,2,3,3,4,,,,,,,,,1,-1,2,-2,3,-3,4,-4,,,,,,,,,1,-1,2,-2,3,-2,4,-3,,,,,,,,,1,1,2,2,3,2,4,3,,,,,,,,,1,1,2,2,3,3,4,4,,,,,,,,,1,0,2,-1,3,-1,4,-2,5,-2,,,,,,,1,0,2,0,3,-1,4,-1,5,-1,,,,,,,1,0,2,0,3,0,4,0,5,0,,,,,,,1,0,2,0,3,1,4,1,5,1,,,,,,,1,0,2,1,3,1,4,2,5,2,,,,,,,"

-- font
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
--   printh("not found! "..a)
--   assert(false)
  end,
  __add=function(self,cmp)
--   assert(cmp._cn)
   rawset(self,cmp._cn,cmp)
   return self
  end,
--  __sub=function(self,cn)
--   assert(rawget(self,cn)!=nil) -- le composant existait
--   self[cn]=nil
--   return self
--  end
  })
end

function cmp(cn,t)
 t=t or {}
 t._cn=cn
 return t
end

function sys(cns,f)
 return function(ents,...)
--  assert(ents)
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
-- local restart=true
-- local restart_nb=4
-- while restart and restart_nb>0 do
--  restart=false
--  restart_nb-=1
 if status==0 and btn(4) and btn(5) then
  music(-1)
  input[4]=-1
  input[5]=-1
  consume_inputs()
  screen_dx,screen_dy=0,0
  show_map,force_map,redraw=false,false,false
  status,points,turn,can_grab=1,0,0,true
	 xp={[0]=0,0,0,0,0}
	 ents={}
	 depth=0
	 current_blob=nil
	 mapgen()
	elseif status==20 and btnp(5) then
	 status=0
	 consume_inputs()
 elseif status>0 then
  if status==1 and short[5] then
	  status=12
	  consume_inputs()
  end
	 if status==12 then
	  search_next_entity()
	  if acting_ent.blob then
	--	  status=
	   if acting_ent==current_blob then
	    status=10
	   else
	    status=13
	   end
	  elseif acting_ent.monster then
	   status=11
	  elseif acting_ent.hunger then
	   local poisoned=false
	   for e in all(ents) do
	    if e.blob and e.adj==6 then
	     local done=false
	     for e2 in all(ents) do
	      if e2.monster and los[e2.x+e2.y*42][e] then
	       done=true
		      e2+=cmp("suffers",{dmg=1,dmgfrom=e})
	      end
	     end
	     if(done) poisoned=true e+=cmp("suffers",{dmg=1,dmgfrom=""})
	    end
	   end
	   if(poisoned) add_msg("pOISONED...",9)
	   acting_ent.t+=hunger_delay
	--	  else
	--	   assert(false)
	  end
	 end
	
	 if(status>0) update_input()
	 if status==10 then
	  moved=false
	  local dur=player_input()
	  if(moved) can_grab=true
	  consume_inputs()
	  if(mget(current_blob.x,current_blob.y)==35)	mapgen()
	  check_food()
	  check_drop()
	  if(dur>0) then
	   status=12
	   acting_ent.t+=dur
	--	   restart=true
	  end
	 elseif status==11 then
	  local dur=monster_act()
	  if(dur==0) dur=wait_dur
	  acting_ent.t+=dur
	--	  restart=true
	  status=12
	 elseif status==13 then
	  local dur=do_atk(acting_ent)
	  if(dur==0) dur=wait_dur
	  acting_ent.t+=dur
	--	  restart=true
	  status=12
	 end
	 
	 local beforehp=0
	 for e in all(ents) do
	  if(e.blob) beforehp+=e.last-e.first+1
	 end
	 
	 sys_heal(ents)
	 sys_suffers(ents)
	 sys_dead(ents)
	 
	 -- check deaths
	 local hp=0
	 for e in all(ents) do
	  if(e.blob) hp+=e.last-e.first+1 update_target(e)
	 end
	 -- game over
	 if(hp==0) status=20
	 if hp<beforehp and hp<=12 then
	  show_map=true
	--	 elseif hp!=beforehp and hp>12 then
	--	  show_map=false
	 end
	-- end
	 
	 if dirty_cells then
	  update_tx_ty(ents)
	  remove_dead_tiles()
	  create_tiles(ents,true)
	  dirty_cells=false
		 update_los_all()
		 update_class_blobs()
		 redraw_heavy=true
	 elseif rerender then
	  create_tiles_one_blob(current_blob,false)
	  update_los_one()
	  redraw_light=true
	  current_blob.target=search_target(current_blob)
	 end
	 rerender=false
	end
end

function check_food()
 for e in all(ents) do
  if e.food and e.x==current_blob.x and e.y==current_blob.y then
   del(ents,e)
   current_blob+=cmp("healed",{healamount=e.heal})
   break
  end
 end
end

function check_drop()
 if(new_class or not can_grab) return -- already in menu
 for e in all(ents) do
  if e.drop and e.x==current_blob.x and e.y==current_blob.y then
   can_grab=false
   new_class=e
   selected_class=0
   break
  end
 end
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
--   else
--    assert(false)
   end
  else -- not a blob
   if short then
	   if current_blob.rangemin<=1 then
	    current_blob.target=e
	 	  return do_atk(current_blob)
	 	 else
	 	  add_msg("too close to target")
	 	  return 0
	 	 end
 	 end
  end
 end
 -- successful move
 if short or long then
  moved=true
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
--   assert(t.t>=turn)
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
 local invnb=selected_class+1
 current_blob.invnb=invnb
 current_blob.class=update_class(inv[invnb][1],inv[invnb][2],current_blob)
 changed_focus=5
 update_target(current_blob)
end

-->8
-- draw

hx,hy,skip,shake,whoshake=1,1,0,0,{}

function _draw()
 if status==0 then
  cls(3)
  nice_print("blob blob blob",nil,40)
  if(t()%1<.7) nice_print("press x+z to start",nil,80,12,false)
  nice_print("by a cheap plastic imitation",nil,113,1,false)
  nice_print("of a game dev (cpiod)",nil,121,1,false)
 else
	-- keep dithering even if game over
	 if redraw_light or redraw_heavy or screen_dx!=0 or screen_dy!=0 then
			if(screen_dx>0) screen_dx-=1
			if(screen_dy>0) screen_dy-=1
			if(screen_dx<0) screen_dx+=1
			if(screen_dy<0) screen_dy+=1
	  nodithering(redraw_heavy)
	 end
	 dithering(500)
	 if status!=20 then
		 draw_background_entities()
		 draw_xp()
		 if(show_map) draw_map()
		 if(show_classes) draw_classes()
		 ?nice_print("T:"..turn,0,121)
		 draw_mouse()
		 if(show_controls) draw_controls()
		 if(new_class) draw_new_class()
		 if(mouse_show_class) draw_one_class(mouse_show_class,33,20,true)
		 draw_msg()
		 if status==1 then
		  local tuto=split"you are a blob escaped from,a secret laboratory. these,scientists studied you for,years because of your,capabitilies: you are very,adaptive and you can split,your body at will. show them,what it takes to stop you!,,each color is an archetype.,learn their strengths and,weaknesses!,,press p to show the controls,press z to start"
		  local y=10
		  for t in all(tuto) do
     nice_print(t,nil,y,6,false)
     y+=7
    end
   end
	 else
	  nice_print("game over!",nil,60,8)
	  nice_print(points.." POINTS",nil,70,8)
	  nice_print("z TO RESTART",nil,90,6,false)
	 end
 end
end

function draw_xp()
 nice_print("xp",121,2,6,false)
 local x,y=124,110
 rectfill(x-1,y-100,x+1,y+1,5)
 line(x,y,x,y-99,0)
 for i=0,4 do
  if(xp[i]!=0) line(x,y-xp[i]+1,x,y,class_attr[i].c2)
  y-=xp[i]
 end
end

function draw_mouse()
 local mousex,mousey=stat(32),stat(33)
 if mousex!=mouse_last_x or mousey!=mouse_last_y then
  mouse_last_x,mouse_last_y=mousex,mousey
  mouse_last_move=t()
 end
 if t()-mouse_last_move<2 then
  palt(0,true)
  spr(25,mousex-1,mousey-1)
	 palt(0,false)
	 local found=nil
	 local tx=(mousex-hx-1)\5
	 local ty=(mousey-hy-1)\5
	 local t=tiles[tx+ty*24]
  if t then
   local mx=t.x
   local my=t.y
   local mnb=mx+my*42
   local y=mousey>64 and mousey-9 or mousey+6
			if losb[mnb] then
	   for e in all(ents) do
	    local p=rawget(e,"pos")
	    if p and mx==p.x and my==p.y then
	     local t=rawget(e,"desc").txt
	     x=mousex-#t*4
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
	    	x=mousex-#t*4
	     if(x+#t*8>128) x=128-#t*8
	     if(x<0) x=0
	     nice_print(t,x,y)
	    end
	   end
	  end
	 end
	 if found and found.class then
	  if(time()%1<.5) nice_print("cLICK FOR STATS",nil,115)
	  if(stat(34)>0) mouse_show_class=found
	 else
 	 mouse_show_class=nil
  end
 end
end

function add_msg(text,col,dur)
 add(msg,{text,dur or 30,col})
end

function draw_controls()
 local t=split"gAMES cONTROLS,10,z (SHORT PRESS),8,aTTACK,10,z (LONG PRESS),8,CHANGE SPECIES,10,c (SHORT PRESS),8,wAIT/NEXT BLOB,10,c (LONG PRESS),8,sPLIT THE BLOB,10,hOVER WITH MOUSE,8,gET MORE INFO,10,aRROWS,8,mOVE/ATTACK,10"
 local y=5
 for i=1,#t/2 do
  local dy=t[2*i]
	 nice_print(t[2*i-1],nil,y,dy==10 and 7 or 6)
	 y+=dy
 end
end

function nice_print(t,x,y,c,big)
 if(big==nil) big=true
 if big then
  x=x or 64-#t*4
  t="\014"..t
 else
  x=x or 64-#t*2
 end
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

function draw_new_class(right)
 local y=2+selected_class*(h+3)
 draw_classes(true)
 local y2=nil
 if selected_class<2 then
  y2=y+h+2
 else
  y2=y-h+2
 end
 draw_one_class(new_class,1,y,true)
 nice_print("a NEW",12,y2)
 nice_print("SPECIES!",0,y2+8)
 nice_print("z CHANGE",0,y2+16)
 nice_print("c CANCEL",0,y2+24)
end

function draw_classes(right)
 local nb,x,y=0,right and 65 or 33,2
 for cnb in all(inv) do
  local c=update_class(cnb[1],cnb[2],nil)
  draw_one_class(c,x,y,nb==selected_class)
  nb+=1
  y+=h+3
 end
end

function draw_one_class(c,x,y,hl)
 local col=hl and 7 or 6
 local col2=hl and class_attr[c.c].c1 or class_attr[c.c].c2
 rectfill(x,y,x+w-1,y+h,col2)
 rectfill(x+1,y+1,x+w-2,y+h-1,col)
 nice_print(desc[c.adj][1],x+2,y+2,col2,false)
 nice_print(desc[c.adj][2],x+2,y+8,col2,false)
 nice_print(desc[c.adj][3],x+2,y+14,col2,false)
 color(hl and 5 or 1)
 local h=carac_hilite[c.c]
 co=function(t)
  return h[1]==t and 11 or (h[2]==t and 8 or nil)
 end
 local t="aTK"
 nice_print(t,x+2,y+20,nil,false)
 nice_print(c.atk,x+24,y+20,co(t),false)
 t="aTKsPD"
 nice_print(t,x+30,y+20,nil,false)
 nice_print(10-c.atkspd\2,x+57,y+20,co(t),false)
 t="aRMOR"
 nice_print(t,x+2,y+26,nil,false)
 nice_print(c.armor,x+24,y+26,co(t),false)
 t="mOVsPD"
 nice_print(t,x+30,y+26,nil,false)
 nice_print(10-c.movspd\2,x+57,y+26,co(t),false)
 t="rANGE"
 nice_print(t,x+2,y+32,nil,false)
 nice_print(c.rangemin..(c.rangemin==c.rangemax and "" or "-"..c.rangemax),x+24,y+32,co(t),false)
end

function draw_map()
-- rectfill(21,21,107,107,0)
 for x=0,41 do
  local sx=22+2*x
  for y=0,41 do
   local sy=22+2*y
   if seen[x+42*y] then
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
	  else
		  if(seen[x-1+42*y]) line(sx,sy,sx,sy+1,0)
		  if(seen[x+1+42*y]) line(sx+1,sy,sx+1,sy+1,0)
		  if(seen[x+42+42*y]) line(sx,sy+1,sx+1,sy+1,0)
		  if(seen[x-42+42*y]) line(sx,sy,sx+1,sy,0)
	  end
  end
 end
	fillp(▒-.5)
	pal(13,1)
 for e in all(ents) do
	 local p=rawget(e,"pos")
	 if p then
	  if losb[p.x+42*p.y] then
		  local sx=22+2*p.x
		  local sy=22+2*p.y
	   if rawget(e,"monster") or rawget(e,"blob") then
			 	local c=class_attr[rawget(e,"class").c]
			 	local col=(c.c1<<4)+c.c1
			 	if rawget(e,"blob")==nil then
		 	 	col=(c.c1<<4)+c.c2
			 	end
			 	if e==current_blob then
		 	  rectfill(sx-1,sy,sx+2,sy+1,col)
		 	  rectfill(sx,sy-1,sx+1,sy+2,col)
			 	else
		 	  rectfill(sx,sy,sx+1,sy+1,col)
			  end
			 elseif rawget(e,"food") then
		 	 rectfill(sx,sy,sx+1,sy+1,0xff)
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
	  if tiles[i] then
	   local mx=tiles[i].x
	   local my=tiles[i].y
	   local mnb=mx+my*42
	   if seen[mnb] then
	    local m=mget(mx,my)
	    if(m!=0) then
		    local sx=hx+5*x+1
		    local sy=hy+5*y
		    if (screen_dx!=0 or screen_dy!=0) and tiles[i].b==current_blob then
--		     if (screen_dx<0 and tiles[i-1].f)
--		        or (screen_dx>0 and tiles[i+1].f)
--		        or (screen_dy<0 and tiles[i-24].f)
--		        or (screen_dy>0 and tiles[i+24].f) then
--		        goto skip
--		     end
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
			     local b=tiles[i].b
			     local p=rawget(e,"pos")
			     if p!=nil and mx==p.x and my==p.y then
								 local ch=rawget(e,"render").char
								 if rawget(e,"class") then
			 	     local col=class_attr[rawget(e,"class").c].c1
			 	     local col2=class_attr[rawget(e,"class").c].c2
			  	    pal(6,col)
			 	     if(b==e) pal(0,col) pal(6,col2)
			 	     if(b==e and b==current_blob) pal(0,7)
		 	     end
	   	    if(b.target==e) circfill(sx+2,sy+3,3+(t()*4)%2,8)
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
 redraw_light,redraw_heavy=false,false
 clip(hx,hy,120,120)
 -- not los, not frontier
 for tx=0,23 do
  for ty=0,23 do
   local i=tx+ty*24
	  local t=tiles[i]
   local x=hx+5*tx
   local y=hy+5*ty
	  if t and t.f==0 and not losb[t.x+42*t.y] then
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
	  if t and losb[t.x+42*t.y] then
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
-- for tx=0,23 do
--  for ty=0,23 do
--	  local t=tiles[tx+ty*24]
--   local x=hx+5*tx
--   local y=hy+5*ty
--	  if t and t.f>0 and (t.b==current_blob or heavy) then
--	   local colors=class_attr[rawget(t.b,"class").c]
--	   local c=t.b==current_blob and colors.c1 or colors.c2
--	   circfill(x+3,y+3,2,c)
----	  elseif t==nil and heavy then
----	  	rectfill(x,y,x+4,y+4,0)
--   end
--  end
-- end
 clip()
end

function dithering(imax)
	for i=1,imax do -- todo imax
	 local x=rnd(127)
	 local y=rnd(127)
	 local c=nil
	 local r=1
	 if x<hx or x>=hx+5*24 or y<hy or y>=hy+5*24 then
	  c=0
	 else
	  local dx=flr((x-hx)%5)
	  local dy=flr((y-hy)%5)
	  local tx=(x-hx)\5
	  local ty=(y-hy)\5
	  local t=tiles[tx+ty*24]
	  local f=t and ((t.f&1>0 and dx==0)
	  or (t.f&2>0 and dx==4)
	  or (t.f&4>0 and dy==0)
	  or (t.f&8>0 and dy==4))
	  if t and f then
 	  local thres=.05 -- color
 	  local chance=1
 	  r=0
		  -- current blob has bigger frontier
	   if t.b==current_blob then
--	    if(imax>200 and changed_focus==0) chance=.5
	    r=1
	    thres=.95
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
 nice_print("mAP GEN...",nil,60)
 flip()
 depth+=1
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
 
 for i=1,10+5*depth do
  local cnb=rnd(5)\1
  if(depth<=3) cnb=rnd(3)\1
  add_monster(cnb)
 end
 
 for i=1,5+depth do
  add_food()
 end
 
 local h=ent()+cmp("hunger",{})
 h+=cmp("turn",{t=turn+hunger_delay})
 h+=cmp("hunger",{})
 add(ents,h)
end

function search_adjacent_space(x,y)
 for d in all(dir) do
  if(can_move_to(x+d[1],y+d[2])) return x+d[1],y+d[2]
 end
 return nil
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
    local f=0
    if(renew and (dx!=1 or dy!=1)) then
-- 1: left
-- 2: right
-- 4: up
-- 8: down
     if(dx==0 and is_frontier(first,last,cxb,cyb,dx,1)) f|=1
     if(dx==2 and is_frontier(first,last,cxb,cyb,dx,1)) f|=2
     if(dy==0 and is_frontier(first,last,cxb,cyb,1,dy)) f|=4
     if(dy==2 and is_frontier(first,last,cxb,cyb,1,dy)) f|=8
    elseif not renew then
     f=tiles[i].f
    end
--    if(f==0) f=nil
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
-- assert(#best>0)
 local mindist=5000
 for c in all(best) do
  local cxb,cyb=unpack(hilb[c])
  for x2=1,1 do
   for y2=1,1 do
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

ename={[0]="pHd sTUDENT",
"pROFESSOR","cHEMIST",
"jANITOR","hAZMAT TECH"}
bname={[0]="pH. vOLEXUM",
"pH. pOTENSUM","pH. jACTARUM",
"pH. sOLLICITUM","pH. lENTUSUM"}
adj={[0]="bASIC","vAMPIRIC",
"cAUTIOUS","iMPULSIVE",
"bIG","sMALL",
"rADIOACTIVE"}

desc={[-10]={"pHd STUDENT:","MOVES FAST,","VERY AGILE."},
[-11]={"pROFESSOR:","KNOWS HOW TO","HURT YOU..."},
[-12]={"cHEMIST: tHROWS","CHEMICALS!",""},
[-13]={"jANITOR: DEATH","BY A THOUSAND","SCRATCHINGS."},
[-14]={"hAZMAT TECH:","HAS THE BEST","PROTECTION."},
[0]={"basic: JUST A","REGULAR BLOB.",""},
{"vampiric: hEALS","2hp WHEN KILLS",""},
{"cautious:","aTKsPD -1","aRMOR  +1"},
{"impulsive:","aTKsPD +1","aRMOR  -1"},
{"big:","aRMOR +1 IF","hp>=32"},
{"small:","aTKsPD +1 IF","hp<=16"},
{"radioactive:","pOISONED, BUT","AREA OF EFFECT"}}

adjrnd=split("0,0,0,0,0,0,1,2,2,3,3,4,4,4,4,5,5,5,5,6")

default_hp={[0]=4,5,2,3,5}
rewards={[0]=0,0,0,0,0}

carac_hilite={
[0]={"mOVsPD","aRMOR"},
{"aTK","mOVsPD"},
{"rANGE","aRMOR"},
{"aTKsPD","mOVsPD"},
{"aRMOR","aTK"}}

default_classes={
[0]={c=0,adj=2,atk=4,atkspd=10,
 armor=2,movspd=6,rangemin=1,rangemax=1},
{c=1,adj=0,atk=8,atkspd=14,
 armor=4,movspd=16,rangemin=1,rangemax=1},
{c=2,adj=0,atk=5,atkspd=16,
 armor=1,movspd=10,rangemin=3,rangemax=5},
{c=3,adj=0,atk=3,atkspd=4,
 armor=3,movspd=14,rangemin=1,rangemax=1},
{c=4,adj=0,atk=2,atkspd=10,
 armor=7,movspd=10,rangemin=1,rangemax=1}}

function update_class_blobs()
 for e in all(ents) do
  if(e.blob) e.class=update_class(inv[e.invnb][1],inv[e.invnb][2],e)
 end
end

-- update class based on the adjective
function update_class(cnb,adj,e)
 local c={}
 for k,v in pairs(default_classes[cnb]) do
  c[k]=v
 end
 if e and e.blob then
	 c.movspd-=rewards[0]*2
	 c.atk+=rewards[1]
	 c.rangemin-=rewards[2]
	 c.atkspd-=rewards[3]*2
	 c.armor+=rewards[4]
 end
 c.adj=adj
-- if(e and e.last-e.first+1>=32) c.atk+=1
-- if(e and e.last-e.first+1<=16) c.movspd-=2
 if(adj==2) c.atkspd+=2 c.armor+=1
 if(adj==3) c.atkspd-=2 c.armor-=1
 if(adj==4 and e and e.last-e.first+1>=32) c.armor+=1
 if(adj==5 and e and e.last-e.first+1<=16) c.atkspd-=2
 if(c.atkspd<2) c.atkspd=2
 if(c.armor<0) c.armor=0
 if(c.rangemin<1) c.rangemin=1
 if(c.movspd<2) c.movspd=2
 return c
end

function spawn_drop(x,y,cnb)
 local a=rnd(adjrnd)
 local c=update_class(cnb,a,nil)
 local e=ent()+cmp("drop")
 add_cmps(e,x,y,40,adj[a])
 e+=cmp("class",c)
 add(ents,e,1) -- add at start for render order
 rerender=true
end

function add_cmps(e,x,y,char,txt,c)
 e+=cmp("pos",{x=x,y=y})
 e+=cmp("render",{char=char})
 e+=cmp("desc",{txt=txt}) 
 if(c) e+=cmp("class",c)
end

function add_food()
 local x,y=nil,nil
 while not can_move_to(x,y) do
  x,y=get_empty_space()
 end
 local e=ent()+cmp("food",{heal=4})
 add_cmps(e,x,y,39,"sOME FOOD")
 add(ents,e,1) -- add at start for render order
 rerender=true
end

function add_monster(cnb)
 local x,y=nil,nil
 while not can_move_to(x,y) do
  x,y=get_empty_space()
 end
 local c=update_class(cnb,-10-cnb,nil)
 local e=ent()+cmp("monster",{hp=default_hp[cnb]})
 add_cmps(e,x,y,e.hp+15,ename[c.c],c)
 -- no turn before woke up
 add(ents,e)
 rerender=true
end

function reset_blob()
 local hp=6 -- mercy
 for e in all(ents) do
  if(e.blob) hp+=e.last-e.first+1
 end
 ents={}
 local b=current_blob
 add(ents,b)
 b.first,b.last,b.target=0,min(64,hp)-1,"" 
 b.x,b.y=get_empty_space()
 dirty_cells=true
end

function spawn_first_blob()
 inv={{0,0},{1,0},{2,0}}
 local x,y=get_empty_space()
 current_blob=ent()+cmp("blob",{first=0,last=63,tx=-1,ty=-1,target="",invnb=1})
 add_cmps(current_blob,x,y,32,"yOUR BLOB",update_class(inv[1][1],inv[1][2],current_blob))
 current_blob+=cmp("turn",{t=0})
 add(ents,current_blob)
 dirty_cells=true
end

function split_blob()
 local b=current_blob
 local x,y=search_adjacent_space(b.x,b.y)
 if(x==nil) then
  add_msg("nO SPACE!")
  return 0
 end
 local s=(b.last+b.first)\2
 local b2=ent()
 b2+=cmp("blob",{first=s+1,last=b.last,tx=-1,ty=-1,target="",invnb=b.invnb})
 add_cmps(b2,x,y,32,"yOUR BLOB",update_class(inv[b.invnb][1],inv[b.invnb][2],b2))
 b2+=cmp("turn",{t=b.t+split_dur})
 add(ents,b2)
 b.last=s
 dirty_cells=true
 return split_dur
end

-- components
-- blob: first last tx ty target invnb
-- monster: hp
-- pos: x y
-- class: c adj atk atkspd armor
--   movspd rangemin rangemax
-- render: char
-- turn: t
-- desc: txt
-- suffers: dmg dmgfrom
-- food: heal
-- healed: healamount
-- drop
-- hunger
-- dead: killer

-- class:
-- 0: move speed
-- 1: dps
-- 2: range
-- 3: atk speed
-- 4: armor
-->8
-- input

input={[0]=0,0,0,0,0,0}
short,long={},{}
--short={[0]=false,false,false,false,false,false}
--long={[0]=false,false,false,false,false,false}
dir={[0]={-1,0},{1,0},{0,-1},{0,1}}
function update_input()
 for i=0,5 do
  if btn(i) then
   if(input[i]>=0) input[i]+=1
   if input[i]==20 then
    long[i]=true
    input[i]=0
   end
  else -- release
   if(input[i]>0) short[i]=true
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
 elseif show_classes or new_class then
  if(short[2] and selected_class>0) selected_class-=1
  if(short[3] and selected_class<2) selected_class+=1
  if(short[5]) then
   if new_class then
    local double=false
    for i=1,3 do
     if(i!=selected_class+1 and inv[i][1]==new_class.c) double=true break
    end
    if double then
     add_msg("nO DUPLICATES",8)
    else
	    inv[selected_class+1]={new_class.c,new_class.adj}
	    del(ents,new_class)
	    new_class=nil
	    add_msg("sPECIES REPLACED")
	    update_class_blobs()
    end
   else
	   show_classes=false
	   if current_blob.class==inv[selected_class+1] then
	    add_msg("nO CHANGE")
	    return 0
	   else
	    change_class()
	    return change_class_dur
	   end
   end
  end
  if(short[4]) show_classes=false new_class=nil
 else	
	 local p=current_blob.pos
	 local x,y=p.x,p.y
	 local move=false
	 for i=0,3 do
	  if short[i] or long[i] or input[i]>0 then
	   x=p.x+dir[i][1]
	   y=p.y+dir[i][2]
	   local m=try_move(x,y,p,input[i]>0,short[i],long[i])
	   if(m>0) return m
	   break
	  end
	 end

	 if(short[4]) then
	  change_focus()
	  local dur=do_atk(current_blob)
	  if(dur==0) dur=wait_dur
	  return dur
	 end
	 if long[5] then
   input[5]=-1
   show_classes=true
   selected_class=0
   return 0
	 end
	 if(short[5]) then
	  local dur=do_atk(current_blob)
   if(dur==0) add_msg("nO TARGET!",8)
	  return dur
	 end
	 if long[4] then
	  input[4]=-1
	  if current_blob.last-current_blob.first>=8 then
	   return split_blob()
	  else 
	   add_msg("cANNOT SPLIT!")
	  end
	 end
	 if(input[4]>5) then
	  if(shake==0) add_msg("sPLITTING!",nil,15)
		 shake=2
		 whoshake={current_blob}
		end

	end
 return 0
end

wait_dur,change_class_dur,split_dur=6,30,5

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
	for i=0,1763 do
	 losb[i]=false
	 los[i]={}
	end
	for e in all(ents) do
	 if(e.blob!=nil) update_los(e)
 end
end

function update_los_one()
 for i=0,1763 do
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
 local target=nil
 if(b.monster) target=search_target(b)
 if(b.blob) target=update_target(b) 
 if target!="" then
  target+=cmp("suffers",{dmg=get_dmg(b),dmgfrom=b})
  return get_atk_dur(b)
 end
 return 0
end

sys_suffers=sys({"suffers"},function(e)
 local dmg=max(0,e.dmg-e.armor)
 -- if good armor, 20% chance of getting no dmg
 if(dmg==0 and e.dmg>0 and rnd()<.8) dmg=1
 if(dmg>0) lose_hp(e,dmg,e.dmgfrom)
 e["suffers"]=nil
end)

sys_dead=sys({"dead"},function(e)
 del(ents,e)
 if e.monster then
--  assert(e.killer!=nil)
  if e.killer.blob then
   points+=100
   xp[e.killer.c]+=10
   
		 local sum=0
		 local mx=nil
		 local cmx=nil
		 for i=0,4 do
		  sum+=xp[i]
		  if(mx==nil or xp[i]>mx) mx=xp[i] cmx=i
		 end
		 if(sum>=100) then 
		  rewards[cmx]+=1
		  update_class_blobs()
		  add_msg("lEVEL UP!",11)
		  add_msg(carac_hilite[cmx][1].."+1")
		  for i=0,4 do
		   xp[i]=0
		  end
		 end
		 
   e.killer.target=""
   if(e.killer.adj==1) e.killer+=cmp("healed",{healamount=2})
  end
  if(rnd()<.3) spawn_drop(e.x,e.y,e.c)
 elseif e.blob then
  change_focus()
 end
end)

sys_heal=sys({"healed"},function(e)
 local h=e.healamount
 e["healed"]=nil
 if e.monster then
  e.hp=min(9,e.hp+h)
 elseif e.blob then
  local sf,sl=e.first,63-e.last
  for e2 in all(ents) do
   if e2.blob then
	   if e2.last<e.first then
	    local sf2=e.first-e2.last-1
	    if(sf2<sf) sf=sf2
	   elseif e2.first>e.last then
	    local sl2=e2.first-e.last-1
	    if(sl2<sl) sl=sl2
	   end
   end
  end
  for i=1,h do
   if sf!=0 and sl!=0 then
    if rnd()<.5 then
     sf-=1
     e.first-=1
    else
     sl-=1
     e.last+=1
    end
   elseif sf==0 and sl!=0 then
    sl-=1
    e.last+=1
   elseif sf!=0 and sl==0 then
    sf-=1
    e.first-=1
   end
  end
  dirty_cells=true
-- else
--  assert(false)
 end
end)

function can_move_to(x,y)
 return fget(mget(x,y),0) and check_collision(x,y)==nil
end

function check_collision(x,y)
 for e in all(ents) do
  if((e.monster or e.blob) and e.x==x and e.y==y) return e
 end
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

function update_target(b)
 local e=b.target
 if e!="" then
  dx=abs(e.x-b.x)
  dy=abs(e.y-b.y)
  d=dx+dy-0.56*min(dx,dy)
  if d<b.rangemin or (b.rangemax and d>b.rangemax) then
   e=""
  end
 end
 if(e=="") b.target=search_target(b)
 return b.target
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
 if(e1.blob) e1,e2=e2,e1
 return los[e1.x+e1.y*42][e2]
end

function enemies(e1,e2)
 return (e1.blob and e2.monster) or (e1.monster and e2.blob)
end

function wakeup(x,y)
 for e in all(ents) do
  if e.monster and e.x==x and e.y==y and e.turn==nil then
   e+=cmp("turn",{t=turn+4}) --mercy
  end
 end
end

function lose_hp(e,nb,from)
-- assert(from!=nil)
 if e.monster then
  e.hp-=nb
  e.char=e.hp+15
  if(e.hp<1) e+=cmp("dead",{killer=from})
 elseif e.blob then
--  shake=3
  dirty_cells=true
  if e.last-e.first+1<=nb then
   e+=cmp("dead",{killer=from})
   change_focus()
  else
	  for i=1,nb do
	   if rnd()<.5 then
	    e.first+=1
	   else
	    e.last-=1
	   end
	  end
  end
-- else
--  assert(false)
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
11011111111111111111111110111111111111111111111111101111101011111111111100000000000000000000000000000000000000000000000000000000
106011111111111111001111070111111101111111111111110601110f0f01111000111100000000000000000000000000000000000000000000000000000000
0606011111011111106601111070111110601111111111111060111110ff01110666011100000000000000000000000000000000000000000000000000000000
060011111060111110660111100701110666011111611111060011110ff011111000111100000000000000000000000000000000000000000000000000000000
106601111101111110660111077011111060111111111111106601110f0f01110666011100000000000000000000000000000000000000000000000000000000
11001111111111111100111110011111110111111111111111001111101011111000111100000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000
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
__sfx__
01120000395003b5003c5003c50539500395053750037505395003950537500375053650036505345003450532500325053450034500345003450034500345000050000500005000050000500005000050000500
0118000000000000000000000000000000000000000000002e465304552e4452d4352b4402b4312b4212b4112b4112b4122b4452d4452e4452d4452b445294350000000000000000000000000000000000000000
0118000028440284312842128411284112841228400284002844529445284452543524440244312442124411244112441224400244002440024400244001f406000000000000000000000000000000000001f407
010c00002b2572d4572e4402e4312e4212e4112e4112e4122e4112e2112e4122e2112e4002e2002e4002e4002e4402e42530440304252e4402e4252d2302d21500000000002e4002e4002e4052d2002d2002d205
010c00002b4402b4412b4312b4312b4212b4212b4112b4112b4122b4122b4002b4002e4402e4312e4212e4112d4402d41500000000002b4002b4002d4302d4052b4002b4002e4002e4002d4002e4002e4002d200
011800002b4402b4312b4212b4112b4112b4112b4122b400282452840025400252352444024431244212441124411244112441124412244002440000000000000000000000000000000000000000000000000000
011800000044000411074350f40007430074110043000411074351040507430074110043000411074350f40007430074110043000411084200841105430054110000000000000000000000000000000000000000
0118000000400004000c435084000c4300c41102400024000c435084000c4300c41102400024000c435084000c4300c4110d4000d4000d4200d41107400074000000000000000000000000000000000000000000
011800000743007421074210742107421074110741107411074000740009400094000940009400094000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800000c4300c4210c4210c4210c4110c4110c4110c4110c4110c40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010900002b2002e2002e2002e2002e2002e2002e2002e2002e405304052e4052d205000000000000000000002e4002e40030400304002e4002e4002d2002d2000000000000000000000000000000000000000000
010c00000044000431004210041107430074150740526505074300742107421074110044000431004210041107430074153200526505074300742107421074110740007400004000040007400104000740007400
010c0000004400043100421004110743007415340052650507430074210742107411004400043100421004110c4300c4210c4210c41108430084210842108411074000740000400004000d4000d4000840008400
010c0000265002650026500265000c4300c41526500265000c4300c4210c4210c411265002650026500265000c4300c41526500265000c4300c4210c4210c4110c4000c40002400024000c400084000c4000c400
010c0000265002650026500265000c4300c41526500265000c4300c4210c4210c4112650026500265002650026000260002600026000260002600026000260002600026000260002600026000260001a0001a000
01120000350652d535370652d535390652d535370652d535350652d535340652d5353506527505000052d535350652d535370652d535390652d535370652d535350652d535370652d5353406500505000052d535
01120000350652d535370652d535390652d535370652d535350652d535340652d5353506527500000052d535350652d535370652d535390652d5353a0652d535390652d535370652d53535065350003550032505
010c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001a3501a3211c3501c3211d3501d3211f3501f3311f3211f3111d3571c3500c356183321832118311183111a10018350183211c3501c3211a3501a3210010000100001000010000100001000010000100
011000001a3501a3211c3501c3211d3501d3211f3501f3311f3211f3111d3571c3500c356183321832118311183111f30218340183211d3401d3211c3401c3211830000000000000000000000000000000000000
011000000944715430154211541115412154111520015200002000020000200002000744713430134211341113412134111320013200131001310013100131001310013100111001110000000000000000000000
01100000003560e3400e3310e3210e3110e3110e3110e3110e300183001a3001a1001a4000e1000e1000e1000e1000e1000e1000e10011100111001010010100021060e1000e1000e1000e1000e1020e1000e100
011000000945615440154311542115411154111541115411154001320013200214002120013100131001310013102131001310013100131001310013100131000910715100151001510015100151001510015100
01100000113561d3401d3311d3211d3111d3111d3111d3111d3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00002415424131241122411128154281312811228111261542613126111261122611226100261002410024154241312411224111281542813128112281112615426131261112611226112261002610024100
010c00001c4562843028412284111f4562b4302b4122b4111d456294302941129412294122940029400004001c4562843028412284111f4562b4302b4122b4111d45629430294112941229412294002940000400
010c00001f7542b7322b7122b711237542f7322f7122f711217542d7322d7112d7122d7122d7112d700007001f7542b7322b7122b711237542f7322f7122f711217542d7322d7112d7122d7122d7112d70000700
010c00002415424131241122411128154281312811228111261542613126112261112915429131291122911128154281312811228111261542613126112261112415424131241112411224112241112411100100
010c00001c4562843028412284111f4562b4302b4122b4111d456294302941229411214562d4302d4122d4111f4562b4302b4122b4111d4562943029412294111c45628430284112841228412284112840000400
010c00001f7542b7322b7122b711237542f7322f7122f711217542d7322d7122d71124754307323071230711237542f7322f7122f711217542d7322d7122d7111f7542b7322b7112b7122b7122b7112b70000700
01300000260542605226042260212d0342d0422d0522d03130034300322f0302f0322b0402b0522b0422b0312e0542e0422d0502d0422c0502c0422c041290542b0502b042280542804229040290522902128054
0130000002435094350e435104351143511400024250e400074350e435134351543517435174001d4051c400024350a4350e4351043514435154050a4250e400094350c435104351343516425094251542509425
0130000007405094050e4100e4110e4110e4000c40509405074050940507410074110741007411074002840004405054050740509405044100440004405284000040000400004000040010412104111042510415
01300000260542605226042260212d0342d0422d0522d03130034300322f0302f0322b0402b0522b0422b031290342d0322b04229052280422803126036240522805228031260542605526054260522604226031
0130000002435094350e435104351143511400024250e400074350e43513435154351643517400074251c40002435094350e4350943515435094350e4350c4350243509435104350943511435054000540008400
013000000e4220e4110e4000c40511410114110c4050940507405094050a4050c4050e4200e4112940528400044050540507405094051041210411044052840000400004000c4220c41102422024110240000400
013000001d7341d7411d7511d7211d7441a73215734157111f7341f7411f7511f7411f7311f7211f7111a7341d7341d7411d7511d741207342073120721207111f7341f7411f7511f7111f7441f7511f7311f711
013000001d7341d7411d7511d7211d7441a73215734157111f7341f7411f7511f7311f7211f7111a7341a7311d7441d731157241a7441c7341c73215724187241d7541d7311c7241c7111d7441d7311d7211d711
0130000000000000000000035500295102951129511295001f5101f50021510215002351023511235000000000000000000000000000225202251122511225002152021511215112150000000000000000000000
01300000000000000000000000002951029511295112950000000000001f5201f5112b5102b5112b5112b50026510265112651126500215102151121511215001a5201a5211a5111a50000000000000000000000
011c00001d1321d11121132211111f1321f1111d1321d1111c1321c1211c1111d1561a1321a11118132181211c1421c1321c1211c1111a1521a1421a1211a1111a1111a1521a1421a1321a1211a1111a1111a112
011c00000a4300a4320a4320a4220a4210a4110a4110a40009430094320943209422094210941109411094000243002432024320242202421024210241102411024000e4300e4320e4220e4220e4110e4110e412
011c00002e5202e5112e5112e5002e5002e5002e5002e500240002400024000245023052230511305113050032520325113251132511325003250032500300003000030000300003000030000300003000030000
011800000041000411004110041100411004110041100411004110041100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011200003203500000340350000035035000003403500000320350000030035000003203500000000000000032035000003403500000350350000034035000003203500000340350000030035000000000000000
011200003203500000340350000035035000003403500000320350000030035000003203500000000000000032035000003403500000350350000037035000003503500000340350000030035350000000000000
01100000020360e0200e0110e0110e0120e0110e0000000000000000000000000000000360c0200c0110c0110c0120c0110e00000000000000000000000000000000000000000000000000000000000000000000
010f0000395003b5003c5003c50539500395053750037505395003950537500375053650036505345003450532500325053450034500345003450034500345000050000500005000050000500005000050000500
01140000395303b7303c5303c51539530397153753037515395303951537530377153653036515345303451532530325153453034531345213451134511345000000000000000000000000000000000000000000
011400003453034515365303651537530375153253032515345303451536530365153053030515325303251534530345152f5302f5312f5212f5112f5112f5000050000500005000050000500005000050000500
01140000395303b7203c5303c7153953039515375303751539530395153753037715365303651534530345153b5203b7153453034531345213451134511345000050000500005000050000500005000050000500
0014000034530345302f5302f5152f5302f51536530365303253032515325303251534530345302f5302f5152f5302f5153653036530325303251532530325150050000500005000050000500005000050000500
010f00002d5202d5212d5212d5212d5112d5112d5112d5112b5202b5212b5212b5212b5112b5112b5112b5112a5202a5212a5212a5212a5112a5112a5112a5112852028521285212852128511285112851128511
010f00002852028521285212852128511285112851128511265202652126521265212651126511265112651124520245212452124521245112451124511245112352023521235212352123511235112351123511
010f00002852028521285212852128511285112851128511235202352123521235212351123511235112351128520285212852128521285112851128511285112352023521235212352123511235112351123511
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800000f6100f645030000e6000f6050f6050f60500500005000050000500005000056000551005410053100521005110051100521005210052100531005310053100521005110051100511005110050000500
__music__
00 00010607
00 00020607
00 0a030b0d
00 0a040c0e
00 00050607
04 0a08092b
00 400f2c52
04 40102d53
00 1112142e
00 1113142e
00 1112142e
04 11151617
00 5818191a
04 581b1c1d
00 261e1f20
00 27212223
00 241e1f20
00 25212223
04 4128292a
00 74343044
00 6f353144
00 6f343244
00 6f363344
00 6f363344
00 74343044
00 6f353144
00 6f343244
00 6f363344
04 6f363344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 2f334344

