

local class = require("Libraries/middleclass")

local reset = class("reset")

function reset:initialize()

  self.color_r = 167
  self.color_g = 120
  self.color_b = 115

  self.box_x = 180
  self.box_y = 130
  self.box_width = 90
  self.box_height = 45

  self.text = "Reset?"
  self.text_x = 195
  self.text_y = 130

  self.active = false
  self.font = font2

end

function reset:setText(string)
  self.text = string
end

function reset:setFont(font)
  self.font = font
end

function reset:setActive(boolean)
  self.active = boolean
end

function reset:getActive()
  return self.active
end

function reset:isClicked(x, y, button, isTouch)

  if self.active == true then
    if button == 1 and x > self.box_x and x < self.box_x + self.box_width and y > self.box_y and y < self.box_y + self.box_height then
      self.active = false
      return true
    end
  end

end

function reset:update(dt)


end

function reset:draw()

  if self.active == true then
    setColor(self.color_r, self.color_g, self.color_b)
    love.graphics.rectangle("fill", self.box_x, self.box_y, self.box_width, self.box_height)
    setColor(255, 255, 255)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.text_x, self.text_y)
  end

end


return reset
