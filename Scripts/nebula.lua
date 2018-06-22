--Nebula generator object

local class = require("Libraries/middleclass")

local nebula = class("nebula")

function nebula:initialize()

  self.nebulas = {}

  for i = 1, 3 do
    table.insert(self.nebulas, {nebulat = nebulaGen(love.math.random(14, 28)), rammi_x = love.math.random(500, 620), rammi_y = love.math.random(-250, 175), rammi_speed = love.math.random(15, 35), rammi_scale = love.math.random(5, 12)/10})
  end

end


function nebula:update(dt)

  for lykill, gildi in pairs(self.nebulas) do
    gildi.rammi_x = gildi.rammi_x - gildi.rammi_speed*dt

  if gildi.rammi_x < -400 then
    gildi.rammi_x = love.math.random(500, 620)
    gildi.rammi_y = love.math.random(-200, 140)
    gildi.rammi_speed = love.math.random(15, 30)
    gildi.nebulat = nebulaGen(love.math.random(14, 30))
    gildi.rammi_scale = love.math.random(5, 12)/10
  end

end

end

function nebula:draw()

  for lykill, gildi in pairs(self.nebulas) do
    setColor(255, 255, 255, 50)
    love.graphics.draw(gildi.nebulat, gildi.rammi_x, gildi.rammi_y, 0, gildi.rammi_scale, gildi.rammi_scale)  --teikna nebulaið
    setColor(255, 255, 255, 255)
  end

end

function nebulaGen(circles)  --Nebula creator!!! circles = þykkni nebulans, rammi_x og rammi_y hvar á að teikna nebulað í leiknum ?

	local neb = {}

    for i = 1, circles do
	    neb[i] = {x = love.math.random(100, 300), y = love.math.random(100, 300), ra = love.math.random(70, 90), v = love.math.random(50, 60), a = love.math.random(10, 190)}
    end

	r = love.math.random(0, 255)
	g = love.math.random(0, 255)
	b = love.math.random(0, 255)

	rammi = love.graphics.newCanvas(400, 400)

	love.graphics.setCanvas(rammi)
	    love.graphics.clear(0, 0, 0, 0)
	    love.graphics.setBlendMode("alpha")
	    for lykill, gildi in pairs(neb) do
	        setColor(r, g, b, gildi.a)
	        love.graphics.circle("fill", gildi.x, gildi.y, gildi.ra, gildi.v)
		    setColor(255, 255, 255)
	    end
	love.graphics.setCanvas()

	return rammi
end

return nebula
