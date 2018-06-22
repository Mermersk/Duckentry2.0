
local class = require("Libraries/middleclass")

local asteroid = class("asteroid")

--asteroid.static.jj = 5  Example of a class variable. a class variable is a variable defined in a class of which a single copy exists, regardless of how many instances of the class exist.
function asteroid:initialize(image)

  self.asteroid_image = love.graphics.newImage(image)

  self.asteroid_scale_x = 0.1
  self.asteroid_scale_y = 0.1

  self.asteroid_collision_radius = 10

  self.aster = {}
  for i = 1, 3 do
    table.insert(self.aster, {ast_x = (1550 + love.math.random(5, 100)) , ast_y = love.math.random(5, 320), ast_speed = love.math.random(140, 260), ast_snu = love.math.random(1, 20)/10, ast_start = 0})
  end


end

function asteroid:update(dt)

  for lykill, gildi in pairs(self.aster) do
    gildi.ast_x = gildi.ast_x - gildi.ast_speed*dt
    if gildi.ast_x < -100 then
      gildi.ast_x = love.math.random(500, 675)
      gildi.ast_y = love.math.random(20, 320)
      gildi.ast_speed = love.math.random(140, 260)
    end

    --if circlecollision2(ond_x, ond_y - 6, gildi.ast_x, gildi.ast_y, ond:getHeight()*0.2, asteroid:getHeight()*0.025) == true then	--set in tölur og fæ true ef collision er en false ef ekki
        --love.audio.play(quack)
          --onoff = onoff + 1 -- Kóðinn fyrir pause takkan, skiptist alltaf á milli, + 1 þá verður pása.
    --lifteljari = lifteljari + 1
    --reset_takki = reset_takki + 1
    --love.system.vibrate(1/3)
    --end

    gildi.ast_start = gildi.ast_start + gildi.ast_snu*dt
  end

end

function asteroid:draw()
  for lykill, gildi in pairs(self.aster) do
    love.graphics.draw(self.asteroid_image, gildi.ast_x, gildi.ast_y, gildi.ast_start, self.asteroid_scale_x, self.asteroid_scale_y, 150, 150)
    --love.graphics.circle("fill", gildi.ast_x, gildi.ast_y, self.asteroid_collision_radius, 16)  --Nákvæmlega sömu tölur og í collision formúlunni, hring með dama radius þá get ég séð árekstarsvæðin!
  --love.graphics.line(duck.ond_x, duck.ond_y, gildi.ast_x, gildi.ast_y)  --Skemmtilegar linur!
  end
end

return asteroid
