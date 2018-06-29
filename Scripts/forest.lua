

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
  self.tree_timer = 0
  self.tree_collision_radius = 12

  self.forest_canvas = love.graphics.newCanvas(600, 300)
  self.active = false

  self.forest_audio = love.audio.newSource("Resources/fugl.ogg", "stream")
	self.forest_audio_volume = 1.0
	self.forest_audio:setVolume(self.forest_audio_volume)


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
    for lykill, gildi in pairs(self.trees) do
      gildi.tre_x = gildi.tre_x - 40*dt

      if gildi.tre_x < -170 then --Svo að vatnið geti komið, -3 svo að við sjáum aldrei bara hálft tré.
  		  gildi.tre_x = love.math.random(520, 600)
  			gildi.tre_y = love.math.random(100, 300)
  			gildi.tre_scale = love.math.random(30, 55)/100
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

end


function forest:draw()
  if self.active == true then
    love.graphics.setCanvas(self.forest_canvas)
    for lykill, gildi in pairs(self.trees) do
      love.graphics.draw(self.tree_image, gildi.tre_x, gildi.tre_y, 0, gildi.tre_scale, gildi.tre_scale)
      love.graphics.circle("fill", gildi.tre_x + 85, gildi.tre_y + 35 + self.forest_y, self.tree_collision_radius)
    end
    love.graphics.setCanvas()
  end
  love.graphics.draw(self.forest_canvas, self.forest_x, self.forest_y)

end


return forest
