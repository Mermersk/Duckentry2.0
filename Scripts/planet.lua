--Planet

local class = require("Libraries/middleclass")

local planet = class("planet")

function planet:initialize(start)

  --self.planet = planetGen(30, 125, 80, 2.667)
  self.planet = love.graphics.newImage("Resources/jord.png")
  self.planet_x = -25 --Original á að ver -25
  self.planet_y = -25  --Original á að ver -25
  self.planet_speed = 40 --ATH planet speed should be 40 in final version
  self.starting_time = start
  --data = self.planet:newImageData()
  self.active = false
  self.warning_duration = 5
  --data:encode("png", "jord")
  self.switch_to_clouds = false

end

function planet:getSwitchToClouds()
  return self.switch_to_clouds
end

function planet:getActive()
  return self.active
end

function planet:update(dt, timer)
  if timer > self.starting_time then
    self.active = true
  end

  if self.active == true then
    if self.planet_x > -2300 then
      self.planet_x = self.planet_x - self.planet_speed*dt
      self.planet_y = self.planet_y - self.planet_speed*dt
    end

    self.warning_duration = self.warning_duration - 1*dt
  end

  if self.planet_x < -1750 then --A little bit before the planet stop moving we make the swithc from asteroids to clouds
    self.switch_to_clouds = true
  end
end

function planet:draw(timer)
  if self.active == true then
    love.graphics.draw(self.planet, self.planet_x, self.planet_y)

    if self.warning_duration > 0 then
      setColor(167, 120, 115)
      love.graphics.setFont(font2)
      love.graphics.rectangle("fill", 195, 195, 100, 40)
      setColor(255, 255, 255, 255)
      love.graphics.print("Gravity!", 200, 195)
    end

  end

end

function planetGen(hringir, circle_size, alpha_start, alpha_decrease)  --Gufuhvols-vél, svone eitthvern megin (:

  local cir = {}
	for i = 1, hringir do
        cir[i] = {radius = 2 + (i * circle_size) - circle_size, alpha = alpha_start + (i * -alpha_decrease) + alpha_decrease}  --Með alpahið, þá fer hvert gildi hærra um 2 ! ég geri -2 svo að fyrsta gildið byrji í 100, svo 102 og so on
    end
  --local settings = {"2d", "rgba4", true, 0, love.graphics.getDPIScale(), "none"}
	local planetan = love.graphics.newCanvas(1000, 1000) --2800, 2800 original  2000*3 = 6000 (error on my adnroid phone)
	love.graphics.setCanvas(planetan)
	--love.graphics.clear(0,0,0,0)
	love.graphics.setBlendMode("alpha")
	for lykill, gildi in pairs(cir) do  --annars get ég ekki breytt planet_x og planet_y
	    setColor(0, 191, 255, gildi.alpha)   --0, 191, 255
      love.graphics.circle("fill", 2500, 2500, gildi.radius, 1500)  --Teikna þetta 3750 þar sem að það er miðjan á canvasinum!
		  setColor(255, 255, 255, 255)
	end
	love.graphics.setCanvas()

	return planetan

end


return planet
