--The ending animation/cinematic
local class = require("Libraries/middleclass")

local ending = class("ending")

function ending:initialize()

  self.position = 0
  self.diff_x = 0
	self.diff_y = 0
	self.active = false

  self.hearts = {}
	self.hearts_image = love.graphics.newImage("Resources/hjarta.png")
	self.heart_time = 3

	self.flute = love.audio.newSource("Resources/Telemann flute2.ogg", "stream")
	self.bibi = love.audio.newSource("Resources/bibi.ogg", "static")
  self.bibi_delay = 3
	self.tween_volume = 0
  self.curve = love.math.newBezierCurve(75, 100, 200, 5, 400, 40, 400, 120, 75, 170, 25, 210, 100, 240, 300, 300)
  self.diff_curve = self.curve:getDerivative()
  self.position = 0

  self.landing_sign = false
  self.hearts_active = false
  self.end_of_game = false
  self.end_of_game_delay = 48 --Length of the end music-song

end

function ending:getEndOfGame()
  return self.end_of_game
end

function ending:getCurvePosition()
  return self.position
end

function ending:setLandingSign(boolean)
  self.landing_sign = boolean
end

function ending:setActive(boolean)
  self.active = boolean
end

function ending:getCurvePositionX()
  return self.curve_pos_x
end

function ending:getCurvePositionY()
  return self.curve_pos_y
end

function ending:update(dt, duck_x, duck_y, duck_curve_landing_x, duck_curve_landing_y)

  self.curve = love.math.newBezierCurve(75, 100, 200, 5, 400, 40, 400, 120, 75, 170, 25, 210, 100, 240, duck_curve_landing_x, duck_curve_landing_y)
  self.curve_pos_x, self.curve_pos_y = self.curve:evaluate(self.position)

  self.diff_curve = self.curve:getDerivative()

  if self.active == true then
    if self.position < 0.95 then
      self.position = self.position + 0.075*dt

      --self.landing_sign = false
    end
    if self.position > 0.93 then
      self.hearts_active = true
    end
    self.flute:setLooping(false)
    self.flute:play()


    self.bibi_delay = self.bibi_delay - dt
    if self.bibi_delay < 0 then
      love.audio.play(self.bibi)
      self.bibi_delay = 3
    end

    if self.position > 0.1 then
      self.end_of_game_delay = self.end_of_game_delay - dt --For the credit screen
      if self.end_of_game_delay < 0 then
        self.end_of_game = true
        self.hearts_active = false
        self.end_of_game_delay = 48
      else
        self.end_of_game = false
      end
    end

  end
  if self.hearts_active == true then
    if self.heart_time > 0 then
      self.heart_time = self.heart_time - dt
    else
      table.insert(self.hearts, {x = love.math.random(duck_x + 20, duck_x + 70), y = love.math.random(duck_y - 80, duck_y - 60), rot = love.math.random(0, 10)/10, scale = love.math.random(2, 3)/15})
      self.heart_time = 3
    end

    for key, value in pairs(self.hearts) do
      value.y = value.y - 25*dt
      if value.y < duck_y - 180 then --Remove heart once it has been on the screen
        table.remove(self.hearts, 1)
      end
    end
  end

end

function ending:draw()

  if self.hearts_active == true then
    for key, value in pairs(self.hearts) do
      love.graphics.draw(self.hearts_image, value.x, value.y, value.rot, value.scale, value.scale)
    end
  end

  --love.graphics.line(self.curve:render())
  --love.graphics.line(self.diff_curve:render())

  if self.landing_sign == true then
    setColor(167, 120, 115)
  	love.graphics.polygon("fill", 130, 75, 130, 110, 100, 92.5)
  	love.graphics.rectangle("fill", 130, 75, 60, 35)
  	setColor(255, 255, 255, 255)
  	love.graphics.setFont(font2)
  	love.graphics.print("Land", 130, 75)
  end

  --love.graphics.print(tostring(self.end_of_game))
  --love.graphics.print(self.end_of_game_delay, 0, 35)

end

return ending
