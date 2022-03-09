pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
function _init()
 s=""
 index=0
 for x=-10,10 do
  for y=-10,10 do
   dx=abs(x)
   dy=abs(y)
   d=dx+dy-0.56*min(dx,dy)
   los=6
  	if(d<los and d>=los-1) then
  	 first=true
   	los_line(0,0,x,y,save)
  	end
  	while index%8!=0 do
  	 s..=",,"
  	 index+=1
  	end
  end
 end
 printh(s,"@clip")
end

function save(x,y)
 if not first then
  s=s..tostr(x)..","..tostr(y)..","
  index+=1
 end
 first=false
 return true
end

-- bresenham line algorithm
-- adapted from roguebasin
function los_line(x1,y1,x2,y2,transparent,...)
 local dx=x2-x1
 local ix=dx>0 and 1 or -1
 local dx=2*abs(dx)

 local dy=y2-y1
 local iy=dy>0 and 1 or -1
 local dy=2*abs(dy)
 
 if(not transparent(x1,y1,...)) return false
 
 if dx>=dy then
  local error=dy-dx/2
 
  while x1!=x2 do
   if (error>0) or ((error==0) and (ix>0)) then
    error=error-dx
    y1=y1+iy
   end
 
   error=error+dy
   x1=x1+ix
   if(not transparent(x1,y1,...)) return false
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
   if(not transparent(x1,y1,...)) return false
  end
 end
 return true
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
