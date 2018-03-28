local turtle  = require("turtle")
local complex = require("complex")
local common  = require("common")
local col     = require("colormap")
local crt     = require("chartmap")

local dX,dY = 1,1
local W , H = 300, 300
local minX, maxX = -8, 8
local minY, maxY = -8, 8
local greyLevel  = 200
local intX  = crt.New("interval","WinX", minX, maxX, 0, W)
local intY  = crt.New("interval","WinY", minY, maxY, H, 0)
local clGry = colr(greyLevel,greyLevel,greyLevel)
local clB = colr(col.getColorBlueRGB())
local clR = colr(col.getColorRedRGB())
local clBlk = colr(col.getColorBlackRGB())
local p1 = complex.getNew(-3,0) 
local p2 = complex.getNew(-2,5) 
local p3 = complex.getNew(7,0)

local tS = p1:getBezierCurve(p2,p3)

local function drawComplexLine(S, E, Cl)
  local x1 = intX:Convert(S:getReal()):getValue()
  local y1 = intY:Convert(S:getImag()):getValue()
  local x2 = intX:Convert(E:getReal()):getValue()
  local y2 = intY:Convert(E:getImag()):getValue()
  pncl(Cl); line(x1, y1, x2, y2)
end; complex.setAction("ab", drawComplexLine)

local function drawCoordinateSystem(w, h, dx, dy, mx, my)
  local xe, ye = 0, 0
  for x = 0, mx, dx do
    local xp = intX:Convert( x):getValue()
    local xm = intX:Convert(-x):getValue()
    if(x == 0) then xe = xp
    else  pncl(clGry); line(xp, 0, xp, h); line(xm, 0, xm, h) end
  end
  for y = 0, my, dx do
    local yp = intY:Convert( y):getValue()
    local ym = intY:Convert(-y):getValue()
    if(y == 0) then ye = yp
    else  pncl(clGry); line(0, yp, w, yp); line(0, ym, w, ym) end
  end; pncl(clBlk)
  line(xe, 0, xe, h); line(0, ye, w, ye)
end

open("Complex ray reflection demo")
size(W,H); zero(0, 0); updt(false) -- disable auto updates

drawCoordinateSystem(W, H, dX, dY, maxX, maxY)

p1:Action("ab", p2, clB)
p2:Action("ab", p3, clB)

for ID = 1, (#tS-1) do
  tS[ID]:Action("ab", tS[ID+1], clR)
  updt(); wait(0.02)
end

wait()