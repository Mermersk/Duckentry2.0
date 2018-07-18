
local class = require("Libraries/middleclass")

local asteroid = class("asteroid")

--asteroid.static.jj = 5  Example of a class variable. a class variable is a variable defined in a class of which a single copy exists, regardless of how many instances of the class exist.
function asteroid:initialize(image)

  self.asteroid_image = love.graphics.newImage(image)

  self.asteroid_scale_x = 0.1
  self.asteroid_scale_y = 0.1

  self.asteroid_collision_radius = 10
  self.asteroid_destroy = false
  self.aster = {}
  for i = 1, 2 do
    table.insert(self.aster, {ast_x = (1550 + love.math.random(5, 100)) , ast_y = love.math.random(5, 320), ast_speed = love.math.random(140, 260), ast_snu = love.math.random(1, 20)/10, ast_start = 0})
  end

  --Particles:

  self.p_image = love.graphics.newImage("Resources/gul.png")

  self.p_rot = 0
  self.p_opacity = 0
  self.p_asteroid = love.graphics.newParticleSystem(self.p_image, 100) --Original 500
  self.p_asteroid:setEmissionRate(60)
  self.p_asteroid:setParticleLifetime(2)
  self.p_asteroid:setDirection(self.p_rot)
  self.p_asteroid:setSpeed(30, 40)
  self.p_asteroid:setSizes(1, 1.2, 0.8)
  self.p_asteroid:setSpread(0.3)
  self.p_asteroid:setColors(95/255, 158/255, 160/255, 60/255, 255/255, 255/255, 255/255, 60/255)
  self.p_asteroid:setSpin(0, 3, 1)


end

function asteroid:destroy(boolean)
  self.asteroid_destroy = boolean
end

function asteroid:update(dt, planet_boolean)

  for lykill, gildi in pairs(self.aster) do
    --if self.asteroid_destroy == false then
      gildi.ast_x = gildi.ast_x - gildi.ast_speed*dt
      gildi.ast_start = gildi.ast_start + gildi.ast_snu*dt
    --end
    if gildi.ast_x < -100 and self.asteroid_destroy == false then --If asteroid_destroy is true then stop respawning asteroids
      gildi.ast_x = love.math.random(500, 675)
      gildi.ast_y = love.math.random(20, 320)
      gildi.ast_speed = love.math.random(140, 260)

    end

    --particles
    if planet_boolean == true then
      self.p_asteroid:start()
      self.p_asteroid:update(dt)
      self.p_rot = self.p_rot - 0.005*dt
      self.p_asteroid:setDirection(self.p_rot)
      self.asteroid_scale_x = self.asteroid_scale_x - 0.0001*dt
      self.asteroid_scale_y = self.asteroid_scale_y - 0.0001*dt
      self.p_asteroid:setColors(95/255, 158/255, 160/255, self.p_opacity/255, 255/255, 255/255, 255/255, self.p_opacity/255)
      if self.p_opacity < 100 then
        self.p_opacity = self.p_opacity + 0.5*dt
      end
    end
  end

end

function asteroid:draw()
  for lykill, gildi in pairs(self.aster) do
    love.graphics.draw(self.p_asteroid, gildi.ast_x, gildi.ast_y)
    love.graphics.draw(self.asteroid_image, gildi.ast_x, gildi.ast_y, gildi.ast_start, self.asteroid_scale_x, self.asteroid_scale_y, 150, 150)

    --love.graphics.circle("fill", gildi.ast_x, gildi.ast_y, self.asteroid_collision_radius, 16)  --Nákvæmlega sömu tölur og í collision formúlunni, hring með dama radius þá get ég séð árekstarsvæðin!
  --love.graphics.line(duck.ond_x, duck.ond_y, gildi.ast_x, gildi.ast_y)  --Skemmtilegar linur!
  end
end

return asteroid
