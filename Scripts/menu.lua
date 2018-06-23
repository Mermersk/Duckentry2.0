

local class = require("Libraries/middleclass")

local menu = class("menu")

function menu:initialize()

  self.flipi = love.graphics.newImage("Resources/flipi.png")
	self.flipi_x = 175
	self.flipi_y = 250
  self.flipi_scale = 0.7
  self.flipi_text = "Start"
  self.flipi_text_x = self.flipi_x + 37
  self.flipi_text_y = self.flipi_y

  self.kassi = love.graphics.newImage("Resources/kassi.png")
  self.kassi_x = self.flipi_x - 150
  self.kassi_y = self.flipi_y - 360

  self.quit_x = self.flipi_x + 50
  self.quit_y = self.flipi_y - 270
  self.quit_width = 180
  self.quit_height = 100
  self.quit_text_x = self.flipi_x + 115
  self.quit_text_y = self.flipi_y - 233

  self.restart_x = self.flipi_x - 140
  self.restart_y = self.flipi_y - 270
  self.restart_width = 180
  self.restart_height = 100
  self.restart_text_x = self.flipi_x - 90
  self.restart_text_y = self.flipi_y - 233

end


function menu:update(dt)


end

function menu:draw()

  love.graphics.draw(self.flipi, self.flipi_x, self.flipi_y, 0, self.flipi_scale, self.flipi_scale)
	love.graphics.setFont(font2) --teiknar allt her eftir í stóra fontinum
	love.graphics.print(self.flipi_text, self.flipi_text_x, self.flipi_text_y)

	setColor(255, 255, 255, 230)
	love.graphics.draw(self.kassi, self.kassi_x, self.kassi_y)   --love.graphics.rectangle("fill", flipi_x - 175, flipi_y - 360, 430, 350)
	setColor(255, 255, 255, 255)

	setColor(100, 1, 1)                --Þessi kóðaklasi teiknar QUIT takkan
	love.graphics.rectangle("fill", self.quit_x, self.quit_y, self.quit_width, self.quit_height)
	setColor(255, 255, 255)
	love.graphics.print("QUIT", self.quit_text_x, self.quit_text_y)

  setColor(167, 120, 115)                --Teikna RESTART takkann
	love.graphics.rectangle("fill", self.restart_x, self.restart_y, self.restart_width, self.restart_height)                                      --flipi_x + 100, flipi_y - 145, 75, 35)
	setColor(255, 255, 255)
	love.graphics.print("RESTART", self.restart_text_x, self.restart_text_y)

  self.credit_x = self.flipi_x - 20
  self.credit_y = self.flipi_y - 165
  self.credit_width = 140
  self.credit_height = 60
  self.credit_text_x = self.flipi_x + 15
  self.credit_text_y = self.flipi_y - 155

	setColor(167, 120, 115)                --Teikna CREDITS takkann
	love.graphics.rectangle("fill", self.credit_x, self.credit_y, self.credit_width, self.credit_height)                                      --flipi_x + 100, flipi_y - 145, 75, 35)
	setColor(255, 255, 255)
	love.graphics.print("ABOUT", self.credit_text_x, self.credit_text_y)

end

function menu:isMenuClicked(x, y, button, isTouch)

  if x > self.flipi_x and x < self.flipi_x + (self.flipi:getWidth() * self.flipi_scale) and y > self.flipi_y and y < self.flipi_y + (self.flipi:getHeight() * self.flipi_scale) then
    self.restart_x = 3000
  end
end


return menu
