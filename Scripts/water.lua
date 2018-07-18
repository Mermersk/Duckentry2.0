

local class = require("Libraries/middleclass")

local water = class("water")

function water:initialize()

  self.water_width = 500
  self.water_height = 400
  self.water_x = -1
  self.water_y = 325


  self.water_canvas = love.graphics.newCanvas(self.water_width, self.water_height)  --500x 400
  self.points = {}
  table.insert(self.points, {x = self.water_width, y = self.water_height, upp_eda_nidur = love.math.random(-5, 5)})
  table.insert(self.points, {x = 0, y = self.water_height, upp_eda_nidur = love.math.random(-5, 5)})
  table.insert(self.points, {x = 1, y = 200, upp_eda_nidur = love.math.random(-5, 5)})
  for i = 1, 16 do
    table.insert(self.points, {x = 32*i, y = 200, upp_eda_nidur = love.math.random(-5, 5)})
  end

  self.points_organized = {}

  for key, value in pairs(self.points) do --The love.graphics.polygon function only accepts simple table ex: {5, 5, 25, 25}
    table.insert(self.points_organized, value.x)
    table.insert(self.points_organized, value.y)
  end

  self.female_duck = love.graphics.newImage("Resources/fond.png")
  self.young_duck = love.graphics.newImage("Resources/fondung.png")

  self.active = false
  self.switch_to_landing = false
  self.switch_to_landing_delay = 4

end

function water:getSwitchToLanding()
  return self.switch_to_landing
end

function water:setActive(boolean)
  self.active = boolean
end

function water:getActive()
  return self.active
end

function water:update(dt)
  if self.active == true then
    for lykill, gildi in pairs(self.points) do
      if gildi.y > 205 then
        gildi.upp_eda_nidur = love.math.random(-5, -3) --Setja ölduna upp aftur
      end
      if gildi.y < 195 then
        gildi.upp_eda_nidur = love.math.random(3, 5) --setja ölduna niður aftur
      end

      gildi.y = gildi.y + gildi.upp_eda_nidur*dt

    end


    for i = 1, #self.points_organized do
      if i % 2 == 0 then --Use modulus to only change the y-values in the table
          self.points_organized[i] = self.points[i/2].y --divide by 2 because points_organized table is double the size og points
      end
    end

    if self.water_y > 50 then
      self.water_y = self.water_y - 15*dt
    end

    if self.water_y < 60 then
      self.switch_to_landing_delay = self.switch_to_landing_delay - dt
      if self.switch_to_landing_delay < 0 then
        self.switch_to_landing = true
      end
    end

    --akkera neðstu gildin, neðstu punktarnir á kassanum
  	self.points[1].x = self.water_width
  	self.points[1].y = self.water_height
  	self.points[2].x = 0
  	self.points[2].y = self.water_height

    self.points_organized[1] = self.water_width
    self.points_organized[2] = self.water_height
    self.points_organized[3] = 0
    self.points_organized[4] = self.water_height

  	love.graphics.setCanvas(self.water_canvas)
  	love.graphics.clear(0,0,0,0)  --fix? Yeebb, þessi kóði virkar eins og skog:clear() i gamla löve
  	love.graphics.setCanvas()
  end

end

function water:draw(push)
  if self.active == true then
    love.graphics.setCanvas(self.water_canvas)
      setColor(47, 79, 150)
      love.graphics.polygon("fill", self.points_organized)
      setColor(255, 255, 255, 255)
      love.graphics.draw(self.female_duck, self.points[11].x, self.points[11].y, 0, 0.3, 0.3, 500/2, 350/2)
      love.graphics.draw(self.young_duck, self.points[13].x, self.points[13].y, 0, 0.1, 0.1, 400/2, 270/2)
      love.graphics.draw(self.young_duck, self.points[14].x, self.points[14].y, 0, 0.1, 0.1, 400/2, 270/2)
    love.graphics.setCanvas()


    --love.graphics.print(#self.points, 0, 0)
    --love.graphics.print(#self.points_organized, 0, 70)
    push:start()
    love.graphics.draw(self.water_canvas, self.water_x, self.water_y)
    push:finish()
  end

end

return water
