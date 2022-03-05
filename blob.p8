pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- untitled blob game
-- by cpiod for 7drl22

function _init()

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
  __add=function(self,cmp)
   assert(cmp._cn)
   assert(self[cmp._cn]==nil) -- pas de doublons
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

function _update60()

end

-->8
-- draw

function _draw()

end
-->8
-- systems
-->8
-- map generation
-->8
-- tiles
-->8
-- spawn
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
