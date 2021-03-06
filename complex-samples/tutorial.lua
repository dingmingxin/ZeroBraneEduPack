require("turtle")
local complex   = require("complex")
local chartmap  = require("chartmap")
local colormap  = require("colormap")
local common    = require("common")
local logStatus = common.logStatus

io.stdout:setvbuf("no")

local tPar
local function makeTastCase(fCompl)
  for ID = 1, #tPar do
    local test = tPar[ID]
    logStatus("Status: "..test.Name)
    for IR = 1, #test do
      local row = test[IR]
      local fun = (row.Foo or fCompl)
      local num = tostring(fun(unpack(row.Arg)))
      if(num ~= row.Out) then
        logStatus("  FAIL: ("..row.Typ..") <"..num.."> = <"..row.Out..">")
        logStatus("     Converting complex test #"..ID.." found mistmatch at index #"..IR)
      else
        logStatus("  OK: ("..row.Typ..") <"..num..">")
      end
    end
  end
end

logStatus("\nMethods starting with upper letter make internal changes and return /self/ .")
logStatus("\nMethods starting with lower return something and do not change internals .")

logStatus("\nCreating complex")
local a = complex.getNew(7,7):Print("1: ","\n")
complex.getNew(a):Print("2: ","\n")
a:getNew():Print("3: ","\n")
a:getNew(complex.getNew(1,-1)):Print("3: ","\n")
a:getNew(-7,nil):Print("4: ","\n")
a:getNew(nil,-7):Print("5: ","\n")
a:getNew(-7,-7):Print("6: ","\n")

--------------------------------------------------------------------------
logStatus("\nConverting complex from something else "..tostring(a))
logStatus("The type of the first argument is used to identify what is converted !"); tPar = {}

tPar[1] = {
  Name = "Directly using a complex with copy-constructor",
  {Typ="copy-constructor", Arg={a}, Out="{7,7}"}
}

tPar[2] = {
  Name = "Converting tables to a complex number. Convert form a table with given keys",
  {Typ="table number keys 1,2", Arg={{a:getReal(),a.getImag()}},Out="{7,7}"},
  {Typ="table predefined keys", Arg={{["r"] = a:getReal(), ["i"]=a.getImag()}},Out="{7,7}"},
  {Typ="table custom key data", Arg={{["asd"] = a:getReal(), ["fgh"]=a.getImag()},"asd","fgh"},Out="{7,7}"},
}

tPar[3] = {
  Name = "Table with variety of key storage",
  {Typ="string j", Arg={"7+j7"},Out="{7,7}"},
  {Typ="string j", Arg={"7+j7"},Out="{7,7}"},
  {Typ="string i", Arg={"7+7i"},Out="{7,7}"},
  {Typ="string J", Arg={"7+J7"},Out="{7,7}"},
  {Typ="string I", Arg={"7+7J"},Out="{7,7}"}
}

tPar[4] = {
  Name = "Table with variety of key storage",
  {Typ="default format", Arg={"7,7"},Out="{7,7}"},
  {Typ="default format", Arg={"7,-7"},Out="{7,-7}"},
  {Typ="default format", Arg={"-7,7"},Out="{-7,7}"},
  {Typ="default format", Arg={"-7,-7"},Out="{-7,-7}"},
  {Typ="string custom delimiter &", Arg={"7&7","&"},Out="{7,7}"},
  {Typ="string complex format {}", Arg={"{7,7}"  },Out="{7,7}"},
  {Typ="string complex format //", Arg={"/7,7/"  },Out="{7,7}"},
  {Typ="string complex format []", Arg={"[7,7]"  },Out="{7,7}"},
  {Typ="string complex format ()", Arg={"(7,7)"  },Out="{7,7}"},
  {Typ="string complex format ||", Arg={"|7,7|"  },Out="{7,7}"},
  {Typ="string complex format <>", Arg={"<7,7>"  },Out="{7,7}"},
  {Typ="string complex format /{}/", Arg={"/{7,7}/"},Out="{7,7}"},
  {Typ="string", Arg={"+i"},Out="{0,1}"},
  {Typ="string", Arg={"i" },Out="{0,1}"},
  {Typ="string", Arg={"-i"},Out="{0,-1}"},
}

tPar[5] = {
  Name = "Numbers",
  {Typ="number", Arg={7,7},Out="{7,7}"},
  {Typ="number", Arg={-7,7},Out="{-7,7}"},
  {Typ="number", Arg={7,-7},Out="{7,-7}"},
  {Typ="number", Arg={-7,-7},Out="{-7,-7}"}
}

tPar[6] = {
  Name = "Boolean and non-existent",
  {Typ="boolean", Arg={true, true  },Out="{1,1}"},
  {Typ="boolean", Arg={true, false },Out="{1,0}"},
  {Typ="boolean", Arg={true,  nil  },Out="{1,0}"},
  {Typ="boolean", Arg={false, true },Out="{0,1}"},
  {Typ="boolean", Arg={false, false},Out="{0,0}"},
  {Typ="boolean", Arg={false, nil  },Out="{0,0}"},
  {Typ="non-existent", Arg={nil  , nil  },Out="{0,0}"}
}

makeTastCase(complex.convNew)
-------------------------------------------------------------------------------------------------------
logStatus("\nComplex signum "..tostring(a)); tPar = {}

tPar[1] = {
  Name = "Test different flags for chosing the corrct sign function",
  {Typ="element-wise", Arg={a, true, false, false}, Out="{1,1}"},
  {Typ="c-sign"      , Arg={a, false, true, false}, Out=  "1"  },
  {Typ="n-sign"      , Arg={a, false, false, true}, Out="{1,1}"},
  {Typ="unit-sign"   , Arg={a}, Out="{0.70710678118655,0.70710678118655}"}
}

makeTastCase(a.getSign)
-------------------------------------------------------------------------------------------------------
logStatus("\nConverting to string. Variety of outputs "..tostring(a)); tPar = {}

logStatus("Export n/a 1: "..tostring(a))
tPar[1] = {
  Name = "Simple export",
  {Typ="Export n/s 2", Arg={a}, Out="{7,7}"}
}

tPar[2] = {
  Name = "Table export",
  {Typ="Export table 1", Arg={a,"table"}, Out="{[\"1\"]=7.000000,[\"2\"]=7.000000}"},
  {Typ="Export table 2", Arg={a,"table",1,"%f",1}, Out="{[\"1\"]=7.000000,[\"2\"]=7.000000}"},
  {Typ="Export table 3", Arg={a,"table",3,"%5.2f",4}, Out="<[\"real\"]= 7.00,[\"imag\"]= 7.00>"},
  {Typ="Export table 4", Arg={a,"table",3,"%5.2f",4,"asd","fgh"}, Out="<[\"asd\"]= 7.00,[\"fgh\"]= 7.00>"}
}

tPar[3] = {
  Name = "String export",
  {Typ="Export string 1", Arg={a,"string"}           , Out="7+7i"},
  {Typ="Export string 2", Arg={a,"string",1}         , Out="7+7i"},
  {Typ="Export string 3", Arg={a,"string",1,false}   , Out="7+7i"},
  {Typ="Export string 4", Arg={a,"string",1,true}    , Out="7+i7"},
  {Typ="Export string 5", Arg={a,"string",2,true}    , Out="7+I7"},
  {Typ="Export string 6", Arg={a,"string",3,true}    , Out="7+j7"},
  {Typ="Export string 7", Arg={a,"string",4,true}    , Out="7+J7"},
  {Typ="Export string 8", Arg={a,"string",4,true,"$"}, Out="7+$7"}
}

makeTastCase(a.getFormat)

logStatus("\nConverting to polar coordinates and back "..tostring(a))
local r, p = a:getPolar(); logStatus("1: "..r.."e^"..p.."i")
complex.getEuler(r, p):Print("2: ","\n")

logStatus("\nAngle handling radian to degree and back "..tostring(a))
local r, d = a:getAngRad(), a:getAngDeg()
logStatus("1: Angle in radian "..r.." is "..complex.toDegree(r).." in degrees")
logStatus("2: Angle in degree "..d.." is "..complex.toRadian(d).." in radians")

--------------------------------------------------------
logStatus("\nClass methods test"..tostring(a)); tPar= {}

tPar[1] ={
  Name = "Addition "..tostring(a),
  {Typ="Add 1" , Arg={a, 1}     ,Foo=a.__add , Out="{8,7}"},
  {Typ="Add 2" , Arg={a, 2}     ,Foo=a.__add , Out="{9,7}"},
  {Typ="Add 3" , Arg={a, 2}     ,Foo=a.getAdd, Out="{9,7}"},
  {Typ="Add F1", Arg={a, .7, .7},Foo=a.getAdd, Out="{7.7,7.7}"},
  {Typ="Add F2", Arg={a, a/10}  ,Foo=a.getAdd, Out="{7.7,7.7}"}
}

tPar[2] ={
  Name = "Subtraction "..tostring(a),
  {Typ="Sub 1" , Arg={a, 1}     ,Foo=a.__sub , Out="{6,7}"},
  {Typ="Sub 2" , Arg={a, 2}     ,Foo=a.__sub , Out="{5,7}"},
  {Typ="Sub 3" , Arg={a, 2}     ,Foo=a.getSub, Out="{5,7}"},
  {Typ="Sub F1", Arg={a, .7, .7},Foo=a.getSub, Out="{6.3,6.3}"},
  {Typ="Sub F2", Arg={a, a/10}  ,Foo=a.getSub, Out="{6.3,6.3}"}
}

tPar[3] ={
  Name = "Multiplication "..tostring(a),
  {Typ="Mul 1" , Arg={a, 1}     ,Foo=a.__mul , Out="{7,7}"},
  {Typ="Mul 2" , Arg={a, 2}     ,Foo=a.__mul , Out="{14,14}"},
  {Typ="Mul 3" , Arg={a, 2}     ,Foo=a.getMul, Out="{14,14}"},
  {Typ="Mul F1", Arg={a, .7, .7},Foo=a.getMul, Out="{0,9.8}"},
  {Typ="Mul F2", Arg={a, a/10}  ,Foo=a.getMul, Out="{0,9.8}"}
}

tPar[4] ={
  Name = "Division "..tostring(a),
  {Typ="Div 1" , Arg={a, 1}     ,Foo=a.__div , Out="{7,7}"},
  {Typ="Div 2" , Arg={a, 2}     ,Foo=a.__div , Out="{3.5,3.5}"},
  {Typ="Div 3" , Arg={a, 2}     ,Foo=a.getDiv, Out="{3.5,3.5}"},
  {Typ="Div F1", Arg={a, .7, .7},Foo=a.getDiv, Out="{10,0}"},
  {Typ="Div F2", Arg={a, a/10}  ,Foo=a.getDiv, Out="{10,0}"}
}

tPar[5] ={
  Name = "Power "..tostring(a),
  {Typ="Pow 1" , Arg={a, 1}     ,Foo=a.__pow , Out="{7,7}"},
  {Typ="Pow 2" , Arg={a, 2}     ,Foo=a.__pow , Out="{6.0005711337296e-015,98}"},
  {Typ="Pow 3" , Arg={a, 2}     ,Foo=a.getPow, Out="{6.0005711337296e-015,98}"},
  {Typ="Pow F1", Arg={a, .7, .7},Foo=a.getPow, Out="{-1.5827757183203,2.3963307116848}"},
  {Typ="Pow F2", Arg={a, a/10}  ,Foo=a.getPow, Out="{-1.5827757183203,2.3963307116848}"}
}

local t = a:getNew():Add(complex.convNew("0.5+0.5i"))

tPar[6] ={
  Name = "Floor "..tostring(a),
  {Typ="Nude"   , Arg={t}              ,Foo=t.getFloor, Out="{7,7}"},
  {Typ="ApplyFF", Arg={t, false, false},Foo=t.getFloor, Out="{7.5,7.5}"},
  {Typ="ApplyFT", Arg={t, false, true },Foo=t.getFloor, Out="{7.5,7}"},
  {Typ="ApplyTF", Arg={t, true, false },Foo=t.getFloor, Out="{7,7.5}"},
  {Typ="ApplyTT", Arg={t, true,  true },Foo=t.getFloor, Out="{7,7}"}
}

tPar[7] ={
  Name = "Ceil "..tostring(a),
  {Typ="Nude"   , Arg={t}              ,Foo=t.getCeil, Out="{8,8}"},
  {Typ="ApplyFF", Arg={t, false, false},Foo=t.getCeil, Out="{7.5,7.5}"},
  {Typ="ApplyFT", Arg={t, false, true },Foo=t.getCeil, Out="{7.5,8}"},
  {Typ="ApplyTF", Arg={t, true, false },Foo=t.getCeil, Out="{8,7.5}"},
  {Typ="ApplyTT", Arg={t, true,  true },Foo=t.getCeil, Out="{8,8}"}
}

tPar[8] ={
  Name = "Negate "..tostring(a),
  {Typ="Neg"  , Arg={a}              ,Foo=t.getNeg  , Out="{-7,-7}"},
  {Typ="NegRe", Arg={a, false, false},Foo=t.getNegRe, Out="{-7,7}"},
  {Typ="NegIm", Arg={a, false, true },Foo=t.getNegIm, Out="{7,-7}"},
  {Typ="Conj" , Arg={a, true, false },Foo=t.getConj , Out="{7,-7}"},
}

local ru = ( a:getNew() * 10 + complex.convNew(" 0.36+0.36j")):Print("Positive : ","\n")
local rd = (-a:getNew() * 10 + complex.convNew("-0.36-0.36j")):Print("Negative : ","\n")

tPar[9] ={
  Name = "Round positive "..tostring(a),
  {Typ="Nude"                          , Arg={nil}    ,Foo=t.getRound, Out="{0,0}"},
  {Typ="Zero"                          , Arg={0}      ,Foo=t.getRound, Out="{0,0}"},
  {Typ="Round away positive integer"   , Arg={t,  1  },Foo=t.getRound, Out="{70,70}"},
  {Typ="Round away positive float"     , Arg={t,  0.1},Foo=t.getRound, Out="{70.4,70.4}"},
  {Typ="Round towards positive integer", Arg={t, -1  },Foo=t.getRound, Out="{70,70}"},
  {Typ="Round towards positive float"  , Arg={t, -0.1},Foo=t.getRound, Out="{70.3,70.3}"}
}

tPar[9] ={
  Name = "Round positive "..tostring(ru),
  -- {Typ="Nil (ERROR)"          , Arg={ru, nil },Foo=t.getRound, Out="{0,0}"},
  {Typ="Zero"                 , Arg={ru,  0  },Foo=t.getRound, Out="{0,0}"},
  {Typ="Round away integer"   , Arg={ru,  1  },Foo=t.getRound, Out="{70,70}"},
  {Typ="Round away float"     , Arg={ru,  0.1},Foo=t.getRound, Out="{70.4,70.4}"},
  {Typ="Round towards integer", Arg={ru, -1  },Foo=t.getRound, Out="{70,70}"},
  {Typ="Round towards float"  , Arg={ru, -0.1},Foo=t.getRound, Out="{70.3,70.3}"}
}

tPar[10] ={
  Name = "Round negative "..tostring(rd),
  -- {Typ="Nil (ERROR)"          , Arg={rd, nil },Foo=t.getRound, Out="{0,0}"},
  {Typ="Zero"                 , Arg={rd,  0  },Foo=t.getRound, Out="{-0,-0}"},
  {Typ="Round away integer"   , Arg={rd,  1  },Foo=t.getRound, Out="{-70,-70}"},
  {Typ="Round away float"     , Arg={rd,  0.1},Foo=t.getRound, Out="{-70.4,-70.4}"},
  {Typ="Round towards integer", Arg={rd, -1  },Foo=t.getRound, Out="{-70,-70}"},
  {Typ="Round towards float"  , Arg={rd, -0.1},Foo=t.getRound, Out="{-70.3,-70.3}"}
}

makeTastCase()
--------------------------------------------------------

logStatus("\nComparison operators")
logStatus("Compare less            : "..tostring(complex.getNew(1,2) <  complex.getNew(2,3)))
logStatus("Compare less or equal   : "..tostring(complex.getNew(1,2) <= complex.getNew(2,3)))
logStatus("Compare grater          : "..tostring(complex.getNew(5,6) >  complex.getNew(2,3)))
logStatus("Compare greater or equal: "..tostring(complex.getNew(2,4) >= complex.getNew(2,3)))
logStatus("Compare equal           : "..tostring(complex.getNew(1,2) == complex.getNew(1,2)))

logStatus("\nComplex number call using the \"__call\" method "..tostring(a))
--[[
  When calling the complex number as a function
  the first argument is the method you want to call given as string,
  the next are var-args, which are the parameters of the method.
  The call will always return a status and varargs representing the result of the call.
  For example let's set the complex number's real and imaginery parts via complex call.
]]
local bSuccess, cNum = a:getNew()("Set",1,1)
if(bSuccess) then
  logStatus("The complex call was successful. The result is "..tostring(cNum).."\n")
else
  logStatus("The complex call was not successful.\n")
end

local tTrig = {
  {"Sine          : ","getSin  ","{1.0137832978161,0.885986829195}      "},
  {"Cosine        : ","getCos  ","{1.1633319692207,-0.7720914350223}    "},
  {"Tangent       : ","getTang ","{0.25407140331504,0.93021872707887}   "},
  {"Cotangent     : ","getCotg ","{0.27323643702064,-1.0003866917748}   "},
  {"Hyp sine      : ","getSinH ","{296.25646574921,461.392875559}       "},
  {"Hyp cosine    : ","getCosH ","{296.25695844114,461.39210823679}     "},
  {"Hyp tangent   : ","getTangH","{1.0000006920752,1.5122148957712e-006}"},
  {"Hyp cotangent : ","getCotgH","{0.999999307923,-1.5122128026371e-006}"},
  {"Logarithm     : ","getLog  ","{1.9560115027141,0.14189705460416}    "}
}

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local b = complex.getNew(7,1)
for id = 1, #tTrig do
  local suc, rez = b(trim(tTrig[id][2]))
  if(suc) then rez = tostring(rez)
    local com = trim(tTrig[id][3])
    logStatus(tTrig[id][1]..((rez == com) and "OK" or "FAIL").." >> "..com)
  else
    logStatus("There was a problem executing method <"..tTrig[id][1].."> at index #"..id)
    logStatus("Error received: "..tostring(rez))
  end
end; logStatus("")

local W, H   = 800, 800 -- Window size
local dX, dY = 1, 1     -- Coordinate system step
local gAlp   = 200      -- Coordinate system grey alpha level
local R = 5             -- Roots base

open("Graphical complex roots for "..tostring(a))
size(W, H)
zero(0, 0)
updt(false) -- disable auto updates

-- Adjust the mapping intervals according to the number rooted
local nRe, nIm = a:getParts()
local intX = chartmap.New("interval","WinX", -nRe/3.5, nRe/3.5, 0, W)
local intY = chartmap.New("interval","WinY", -nIm/3.5, nIm/3.5, H, 0)

-- Allocate colours
local clGrn = colr(colormap.getColorGreenRGB())
local clRed = colr(colormap.getColorRedRGB())
local clBlk = colr(colormap.getColorBlackRGB())
local clGry = colr(colormap.getColorPadRGB(gAlp))

--[[
  Custom function for drawing a number on the complex plane
  The the first argument must always be the complex number
  that you are gonna draw a.k.a. SELF. The other parameters are
  VARARG, which means you can use a bunch of them in the stack.
  In this example all the arguments are local for this file
  so there is no point of extending the vararg on the stack
  Prototype: drawFunction(SELF, ...)
]]
local function drawComplexFunction(C)
  local r = C:getRound(0.001)
  local x = intX:Convert(r:getReal()):getValue()
  local y = intY:Convert(r:getImag()):getValue()
  local ox = intX:Convert(0):getValue()
  local oy = intY:Convert(0):getValue()
  pncl(clGrn); line(ox, oy, x, y)
  pncl(clRed); rect(x-2,y-2,5,5)
  pncl(clBlk); text(tostring(r),r:getAngDeg()+90,x,y)
end

--[[
  It is easy for the complex numbers to be drawn using a attached drawing method
  internally as every object keeps its local data and you can draw stuff using less arguments
  Prototype: complex.setAction(KEY, FUNCTION)
]]
complex.setAction("This your action key !" ,drawComplexFunction) -- This is how you register a drawing method

local scOpe = chartmap.New("scope"):setInterval(intX, intY):setSize():setBorder()
      scOpe:setColor():setDelta(dX, dY):Draw(true, true, true)

logStatus("Complex roots returns a table of complex numbers being the roots of the base number "..tostring(a))
local r = a:getRoots(R)
if(r) then
  for id = 1, #r do
    logStatus(r[id].."^"..R.." = "..(r[id]^R))
    r[id]:Action("This your action key !")
    -- scOpe:drawComplex(r[id], nil, true) -- This is the same as above
    updt(); wait(0.1)
  end
end

wait()
