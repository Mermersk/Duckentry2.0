

local class = require("Libraries/middleclass")

local cloud = class("cloud")

function cloud:initialize()
  self.cloud_image = love.graphics.newImage("Resources/skyh.png")

  self.clouds_table = {}
	for i = 1, 6 do
	    self.clouds_table[i] = {sky_x = love.math.random(500, 800), sky_y = love.math.random(30, 330), sky_speed = love.math.random(40, 60), scale = love.math.random(5, 10)/10, sky_alpha = love.math.random(100, 210)}
	end
  self.switch_to_forest = false
  self.clouds_cycles = 0

  self.vind = love.audio.newSource("Resources/vindur.ogg", "stream")
	self.vind_volume = 0
  self.vind:setVolume(self.vind_volume)
  self.vind_volume_target = 0


  self.vind_audio_active = false
  self.vind_active = false
end

function cloud:getSwitchToForest()
  return self.switch_to_forest
end

function cloud:setVindVolume(number)
  self.vind_volume_target = number
end

function cloud:setVindAudioActive(boolean)
  self.vind_audio_active = boolean
end

function cloud:setVindActive(boolean)
  self.vind_active = boolean
end

function cloud:update(dt)
  if self.vind_audio_active == true then
    love.audio.play(self.vind)
    self.vind:setVolume(self.vind_volume)
    if self.vind_volume < self.vind_volume_target then
      self.vind_volume = self.vind_volume + 0.01*dt
    else if self.vind_volume > self.vind_volume_target then
      self.vind_volume = self.vind_volume - 0.05*dt
    end
    end
  end

  if self.vind_active == true then
    for key, value in pairs(self.clouds_table) do
      value.sky_x = value.sky_x - value.sky_speed*dt
      value.sky_y = value.sky_y - 3.5*dt

      if value.sky_x < -180 and self.clouds_cycles <= 8 then --Creates new cloud when it has crossed the screen
        value.sky_x = love.math.random(500, 800)
        value.sky_y = love.math.random(30, 330)
        value.sky_speed = love.math.random(40, 60)
        value.scale = love.math.random(5, 10)/10
        value.sky_alpha = love.math.random(75, 230)
        self.clouds_cycles = self.clouds_cycles + 1
      end
    end
  end


  if self.clouds_cycles >= 8 then
    self.switch_to_forest = true
  end


end

function cloud:draw()
  if self.vind_active == true then
    for key, value in pairs(self.clouds_table) do
      setColor(255, 255, 255, value.sky_alpha)
      love.graphics.draw(self.cloud_image, value.sky_x, value.sky_y, 0, value.scale, value.scale)
      setColor(255, 255, 255, 255)
    end
  end


end

return cloud
