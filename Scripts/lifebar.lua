--Lifebar in the game

local class = require("Libraries/middleclass")

local lifeBar = class("lifeBar")

  lifeBar.static.number_of_lifes = 3
  lifeBar.static.scale = 0.3


function lifeBar:initialize()

  self.life_image = love.graphics.newImage("Resources/lif.png")
  self.index = 1
  self.lifes = {}
  for i = 1, lifeBar.number_of_lifes do
    table.insert(self.lifes, {x = 350 + i*30, y = 5, scale_x = lifeBar.scale, scale_y = lifeBar.scale, active = true})
  end

end

function lifeBar:update(dt)

end

function lifeBar:draw()

  for key, value in pairs(self.lifes) do
    if value.active == false then
      setColor(105, 105, 105)
      love.graphics.draw(self.life_image ,value.x, value.y, 0, value.scale_x, value.scale_y)
      setColor(255, 255, 255)
    else
      love.graphics.draw(self.life_image ,value.x, value.y, 0, value.scale_x, value.scale_y)
    end
  end

end

function lifeBar:subtract()
  if self.index <= lifeBar.number_of_lifes then
    self.lifes[self.index].active = false
    self.index = self.index + 1
  end

end

return lifeBar
