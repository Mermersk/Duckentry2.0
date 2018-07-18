

local class = require("Libraries/middleclass")

local forest = class("forest")

function forest:initialize()

  self.tree_image = love.graphics.newImage("Resources/tre.png")

  self.trees = {}
	for i = 0, 25 do
	    self.trees[i] = {tre_x = love.math.random(-2, 600), tre_y = love.math.random(100, 300), tre_scale = love.math.random(30, 55)/100}
	end

  self.forest_x = 0 --original = 0
  self.forest_y = 250 --original = 400
  self.forest_width = 600
  self.forest_height = 300
  self.tree_timer = 0
  self.tree_collision_radius = 12

  self.forest_canvas = love.graphics.newCanvas(self.forest_width, self.forest_height)
  self.active = false

  self.forest_audio = love.audio.newSource("Resources/fugl.ogg", "stream")
	self.forest_audio_volume = 1.0
	self.forest_audio:setVolume(self.forest_audio_volume)

  self.switch_to_water = false
  self.forest_cycles = 0
  self.forest_cycles_target_tre = 45
  self.forest_cycles_target_canvas = self.forest_cycles_target_tre + 8

  self.warning_duration = 5

end

function forest:getSwitchToWater()
  return self.switch_to_water
end

function forest:getActive()
  return self.active
end

function forest:setActive(boolean)
  self.active = boolean
end

function forest:update(dt)

  if self.active == true then
    self.tree_timer = self.tree_timer + 1*dt
    self.warning_duration = self.warning_duration - 1*dt
    for lykill, gildi in pairs(self.trees) do
      if self.switch_to_water ~= true then
        gildi.tre_x = gildi.tre_x - 40*dt
      end

      if gildi.tre_x < -170 and self.forest_cycles < self.forest_cycles_target_tre then
  		  gildi.tre_x = love.math.random(520, 600)
  			gildi.tre_y = love.math.random(100, 300)
  			gildi.tre_scale = love.math.random(30, 55)/100
        self.forest_cycles = self.forest_cycles + 1
      else if self.forest_cycles >= self.forest_cycles_target_tre then --So that forest_cycles continues to count
          self.forest_cycles = self.forest_cycles + 0.1*dt
        end
  		end

    end
    love.graphics.setCanvas(self.forest_canvas)
  	love.graphics.clear(0,0,0,0)  --fix? 2016  Yeebb, þessi kóði virkar eins og skog:clear() i gamla löve
  	love.graphics.setCanvas()

    if self.forest_y > 20 then
      self.forest_y = self.forest_y - 25*dt
    end
    love.audio.play(self.forest_audio)

  end

  if self.forest_cycles > self.forest_cycles_target_canvas then
    self.switch_to_water = true
    if self.forest_x > -self.forest_width then
      self.forest_x = self.forest_x - 40*dt
    end
  end

  --if self.forest_x < -3 then
    --self.switch_to_water = true
  --end

end


function forest:draw(push)
  --Because of an advanced canvas the drawing itself to the canvas must not be scaled, but the canvas itself should be scaled
  if self.active == true then
    love.graphics.setCanvas(self.forest_canvas)
    for lykill, gildi in pairs(self.trees) do
      love.graphics.draw(self.tree_image, gildi.tre_x, gildi.tre_y, 0, gildi.tre_scale, gildi.tre_scale) --Not scale here
      --love.graphics.circle("fill", gildi.tre_x + 85, gildi.tre_y + 35 + self.forest_y, self.tree_collision_radius)
    end
    love.graphics.setCanvas()
    push:start()
    if self.warning_duration > 0 then
      setColor(167, 120, 115)
      love.graphics.setFont(font)
      love.graphics.rectangle("fill", 195, 195, 100, 50)
      setColor(255, 255, 255, 255)
      love.graphics.print("Forest ahead \n    Keep high!", 200, 195)
    end
    push:finish()
  end
  push:start()
  love.graphics.draw(self.forest_canvas, self.forest_x, self.forest_y) --Scale here YES!
  --love.graphics.print(tostring(self.switch_to_water))
  --love.graphics.print(self.forest_cycles, 0, 30)
  push:finish()



end


return forest
