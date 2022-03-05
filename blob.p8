pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- untitled blob game
-- by cpiod for 7drl22

function _init()
 ents={}
 local b=ent()+cmp("blob",{first=0,last=63,tx=12,ty=12})
 b+=cmp("pos",{x=2,y=7})
 b+=cmp("class",{c=0})
 b+=cmp("render",{char=10})
 add(ents,b)
 current_blob=b
 update_tiles()
 cls()
end


-- libs

-- bresenham line algorithm
-- adapted from roguebasin
function los_line(x1, y1, x2, y2, transparent)
 local dx=x2-x1
 local ix=dx>0 and 1 or -1
 local dx=2*abs(dx)

 local dy=y2-y1
 local iy=dy>0 and 1 or -1
 local dy=2*abs(dy)
 
 if(not transparent(x1,y1)) return false
 
 if dx>=dy then
  local error=dy-dx/2
 
  while x1!=x2 do
   if (error>0) or ((error==0) and (ix>0)) then
    error=error-dx
    y1=y1+iy
   end
 
   error=error+dy
   x1=x1+ix
   if(not transparent(x1,y1)) return false
  end
 else
  error=dx-dy/2
 
  while y1!=y2 do
   if (error>0) or ((error==0) and (iy>0)) then
    error=error-dy
    x1=x1+ix
   end
 
   error=error+dx
   y1=y1+iy
   if(not transparent(x1,y1)) return false
  end
 end
 return true
end

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
   assert(false)
  end,
  __add=function(self,cmp)
   assert(cmp._cn)
   self[cmp._cn]=cmp
   return self
  end,
  __sub=function(self,cn)
   assert(self[cn]!=nil) -- le composant existait
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
  for e in all(ents) do
   for cn in all(cns) do
    if(not e[cn]) goto _
   end
   f(e,...)
   ::_::
  end
 end
end
-->8
-- update

function _update()
 player_input()
end

function player_input()
 local p=current_blob.pos
 local x,y=p.x,p.y
 local move=false
 if(btnp(➡️)) x=p.x+1
 if(btnp(⬅️)) x=p.x-1
 if(btnp(⬆️)) y=p.y-1
 if(btnp(⬇️)) y=p.y+1
 if(x!=p.x or y!=p.y)	try_move(x,y,p) 

 if(btnp(❎)) change_focus()
 if(btnp(🅾️)) split_blob()
 
end

function try_move(x,y,p)
 -- wall?
 if(not fget(mget(x,y),0)) return
 e=check_collision(x,y)
 -- collision
 if e then
  if e.blob then
   merge(e)
  else -- not a blob
   return
  end
 end
 -- successful move
 p.x=x
 p.y=y
 update_tiles()

end

function change_focus()
 local tmp=nil
 local nxt=false
 for e in all(ents) do
  if e.blob!=nil then
   if(tmp==nil) tmp=e
   if(nxt) nxt=false current_blob=e break
   if(e==current_blob) nxt=true
  end
 end
 -- if last of the list
 if(nxt) current_blob=tmp
end

-- todo ameliorer
function update_tx_ty(b)
 local c=flr((b.first+b.last)/2)
 local tx,ty=unpack(hilb[c])
 b.tx=tx*3+1
 b.blob.ty=ty*3+1
end

function split_blob()
 local b=current_blob
 local s=flr((b.blob.last+b.blob.first)/2)
 local b2=ent()+cmp("blob",{first=s+1,last=b.blob.last})
 b2+=cmp("class",{c=b.class.c+1})
 b2+=cmp("pos",{x=b.pos.x+1,y=b.pos.y})
 b2+=cmp("render",{char=10})
 add(ents,b2)
 b.blob.last=s
 update_tx_ty(b)
 update_tx_ty(b2)
 update_tiles()
end

function merge(b2)
 local b=current_blob
 
 update_tx_ty(b)
end
-->8
-- draw

hx=2
hy=2

skip=0

function _draw()
 skip+=1
 skip%=2
 if(skip==0) dithering()
	
	local chars={".","A"}

	-- tiles
	for x=0,23 do
	 for y=0,23 do
 	 -- tile dead ?
 	 local i=x+24*y
	  if tiles[i]!=nil then
	   local mx=tiles[i].x
	   local my=tiles[i].y
    local m=mget(mx,my)
    if(m==0) m=2
 	  ?chars[m],hx+5*x,hy+5*y,5
 	  render_units(ents,mx,my,hx+5*x,hy+5*y)
 	 end
	 end
	end
end

function dithering()
	for i=1,300 do
	 local x=rnd(127)
	 local y=rnd(127)
  dithering_once(x,y)
	end
end

function dithering_once(x,y)
	-- dithering
 local c=0
 local r=3
 if x<hx or x>=hx+5*24 or y<hy or y>=hy+5*24 then
  c=0
 else
  local cellx=flr((x-hx)/15)
  local celly=flr((y-hy)/15)
  local cell=cells[cellx+celly*8]
  for e in all(ents) do
   if e.blob.first!=nil then
    if cell>=e.blob.first and cell<=e.blob.last then
     c=class_attr[e.class.c].c2
--      if(rnd()<.3) r=1 c=class_attr[e.class.c].c1
     break
    end
   end
  end
 end
 circfill(x,y,r,c)
end

render_chars={[10]="@"}

render_units=sys({"render","pos","class"},
function(e,mx,my,sx,sy)
 if(mx==e.pos.x and my==e.pos.y) ?render_chars[e.render.char],sx,sy,class_attr[e.class.c].c1
end)
-->8
-- systems

function check_collision(x,y)
 for e in all(ents) do
  if(e.pos and e.pos.x==x and e.pos.y==y) return e
 end
end

render_units=sys({"render","pos","class"},
function(e,mx,my,sx,sy)
 if(mx==e.pos.x and my==e.pos.y) ?render_chars[e.render.char],sx,sy,class_attr[e.class.c].c1
end)
-->8
-- map generation

-- map values
-- 1: open
-- 2: wall

-- flags:
-- 0: traversable
-- 1: transparent
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

create_tiles=sys({"blob"},
function(b)
 for c=b.first,b.last do
  local cx,cy=unpack(hilb[c])
  cx*=3
  cy*=3
  local x=b.x+cx-b.tx
  local y=b.y+cy-b.ty
  for dx=0,2 do
   for dy=0,2 do
    local i=(cx+dx)+(cy+dy)*24
--    printh((x+dx).." "..(y+dy))
    tiles[i]={x=x+dx,y=y+dy}
   end
  end
 end
end)

function update_tiles()
 tiles={}
 create_tiles(ents)
end

-->8
-- spawn
class_attr={[0]={c1=10,c2=9},
{c1=8,c2=4},
{c1=11,c2=3},
{c1=14,c2=2},
{c1=12,c2=1}}

-- class:
-- 0: move speed
-- 1: dps
-- 2: range
-- 3: atk speed
-- 4: armor
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000060060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000060060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000060060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000600000666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000060060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0102010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102010101010101010101010101010101010101020202020202020101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101020102010101010101010101010101010101010202020101010101010202020101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101020202020201010101010202020201010101010202020202020201010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101010101010201010202010101010101010101010102020202010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102010101010101020201010102010101010101010101010101010102020201010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101020101010102010101010101010101010101010101010201010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010202010101010101010102010101010101010202010101010101010202010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101020201010101010101010202010101010102020101020101010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101010101010101010101010101010202010101020201010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101020202020101010101010101010201010101010201010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101020101020201010101010101020201010101010102010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010101010101010201010101010101020101010101010102010101010102010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
