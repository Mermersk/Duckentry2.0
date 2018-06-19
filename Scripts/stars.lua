local class = require("Libraries/middleclass")

local star = class("star")


function star:initialize()

  self.stjornur = {}
	for i = 1, 250 do
	    self.stjornur[i] = {xhnit = love.math.random(0, 480), yhnit = love.math.random(0, 380), r = love.math.random(0, 255), g = love.math.random(0, 255), b = love.math.random(0, 255), a = love.math.random(100, 255)} --Skapar 50 svona stykki! 50 xhnit og 50 yhnit breytur
	end

end

function star:update(dt)

  for lykill, gildi in pairs(self.stjornur) do
    gildi.xhnit = gildi.xhnit - 8*dt

    if gildi.xhnit < -0 then
      gildi.xhnit = 482
      gildi.yhnit = love.math.random(0, 320)
    end

    --if utmork_planetu < 2500 and gildi.a > 5 then  --Svo að stjörnurnar sjást ekki í gegnum plánetuna
      --gildi.a = gildi.a - 10*dt
    --end

  end

end

function star:draw()

  for lykill, gildi in pairs(self.stjornur) do
	    setColor(gildi.r, gildi.g, gildi.b, gildi.a)
	    love.graphics.points(gildi.xhnit, gildi.yhnit)
		  setColor(255, 255, 255)
	end

end


return star
