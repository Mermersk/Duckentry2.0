--A little opening cinematic

local class = require("Libraries/middleclass")

local zzz = class("zzz")

function zzz:initialize()

  self.bil = 25
  self.alpha_opening = 250

  self.zzz = {}
  for i = 1, 5 do
    self.zzz[i] = {x = love.math.random(120, 170), y = -30 - (i * self.bil), rot = love.math.random(0, 10)/10, r = love.math.random(0, 255), g = love.math.random(0, 255), b = love.math.random(0, 255), timi = i/2}
  end

end

function zzz:update(dt, timer)

  if timer < 6 then
	   self.alpha_opening = 250
	else
	   self.alpha_opening = self.alpha_opening - 50*dt
	end

end

function zzz:draw(timer, ond_y, font)

  for lykill, gildi in pairs(self.zzz) do
    if timer > gildi.timi then  --timi í töflunni er að hvert {x.....} teiknast í röð, timi er frá 1 til 5 svo nýr "z" bókstafur birtist hverja sekúndu
        setColor(gildi.r, gildi.g, gildi.b, self.alpha_opening)
        love.graphics.setFont(font)
        love.graphics.print("ZZZ?", gildi.x, ond_y + gildi.y, gildi.rot)
        setColor(255, 255, 255)
      end
    end

end

return zzz
