

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

  self.credit_x = self.flipi_x - 20
  self.credit_y = self.flipi_y - 165
  self.credit_width = 140
  self.credit_height = 60
  self.credit_text_x = self.flipi_x + 15
  self.credit_text_y = self.flipi_y - 155

  self.menu_active = true

  self.credit_image = credit()
  self.credit_active = false

end

function menu:setCreditActive(boolean)
  self.credit_active = boolean
end

function menu:getCreditActive()
  return self.credit_active
end

function menu:getMenuActive()
  return self.menu_active
end

function menu:setMenuActive(boolean)
  self.menu_active = boolean
end


function menu:update(dt)

  self.kassi_y = self.flipi_y - 360 --Y values need to be updated if they are to move up and down
  self.quit_y = self.flipi_y - 270
  self.restart_y = self.flipi_y - 270
  self.credit_y = self.flipi_y - 165

  self.flipi_text_y = self.flipi_y
  self.quit_text_y = self.flipi_y - 233
  self.restart_text_y = self.flipi_y - 233
  self.credit_text_y = self.flipi_y - 155

  if self.menu_active == true then
    if self.flipi_y < 250 then
      self.flipi_y = self.flipi_y + 250*dt
    end
  else
    if self.flipi_y > 5 then
      self.flipi_y = self.flipi_y - 250*dt
    end
  end

  if self.menu_active == true then
    self.flipi_text = "Resume"
  else
    self.flipi_text = "Pause"
  end

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

  	setColor(167, 120, 115)                --Teikna CREDITS takkann
  	love.graphics.rectangle("fill", self.credit_x, self.credit_y, self.credit_width, self.credit_height)                                      --flipi_x + 100, flipi_y - 145, 75, 35)
  	setColor(255, 255, 255)
  	love.graphics.print("ABOUT", self.credit_text_x, self.credit_text_y)

    if self.credit_active == true then
      love.graphics.draw(self.credit_image, 25)
    end


end

function menu:isCreditClicked(x, y, button, isTouch)
  if button == 1 and x > self.credit_x and x < self.credit_x + self.credit_width and y > self.credit_y and y < self.credit_y + self.credit_height then
    return true
  end
end

function menu:isRestartClicked(x, y, button, isTouch)

  if button == 1 and x > self.restart_x and x < self.restart_x + self.restart_width and y > self.restart_y and y < self.restart_y + self.restart_height then
    return true
  end

end

function menu:isQuitClicked(x, y, button, isTouch)

  if button == 1 and x > self.quit_x and x < self.quit_x + self.quit_width and y > self.quit_y and y < self.quit_y + self.quit_height then
    return true
  end

end

function menu:isMenuClicked(x, y, button, isTouch)

  if button == 1 and x > self.flipi_x and x < self.flipi_x + (self.flipi:getWidth() * self.flipi_scale) and y > self.flipi_y and y < self.flipi_y + (self.flipi:getHeight() * self.flipi_scale) then
    return true
  end

end

function credit()

    local credit_mynd = love.graphics.newImage("Resources/credit.png")
    local credit_canvas = love.graphics.newCanvas(430, 350)
  	love.graphics.setCanvas(credit_canvas)
		  love.graphics.draw(credit_mynd, 0, 0, 0, 1, 0.70) --0.70
			love.graphics.setFont(font2)
			love.graphics.print("Programming, art, sound and", 25, 5)
			love.graphics.print("game design by: Ísak Steingrímsson", 25, 45)
			love.graphics.print("Contact: ic4ruz39@gmail.com", 25, 85)
			love.graphics.print("Ending song by: G.P. Telemann", 25, 125)
			love.graphics.print("Made with:", 125, 155)
	love.graphics.setCanvas()
	return credit_canvas

end


return menu
