--Thought bubbles in the game from the duck

local class = require("Libraries/middleclass")

local thoughtBubble = class("thoughtBubble")

thoughtBubble.static.duration = 7 --Class variable, unmutable.

function thoughtBubble:initialize(image, start)

  self.hugs = love.graphics.newImage(image)
  self.starting_time = start
  self.quack1 = love.audio.newSource("Resources/duck1.ogg", "static")
  self.quack1:setLooping(false)

  self.active = false

  self.scale = 0.4
  self.alpha = 0

end

function thoughtBubble:update(dt, timer)

  if timer > self.starting_time and timer < self.starting_time + thoughtBubble.duration then --Start of animation, only true for 10 seconds
    self.alpha = self.alpha + 0.2*dt
    self.active = true
  else if self.starting_time + thoughtBubble.duration < timer then
    self.alpha = self.alpha - 0.3*dt
  end
  end

  --quack sound each time a thought bubble appears
  if timer > self.starting_time and timer < self.starting_time + 0.5 then
    self.quack1:setLooping(false)
    love.audio.play(self.quack1)
  end

end

function thoughtBubble:draw(x, y)
  if self.active == true then
    local y_offset = y - 130
    local x_offset = x + 25


    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.hugs, x_offset, y_offset, 0, self.scale, self.scale)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print(y_offset, 0, 100)
  end


end

function hugs(start, hvelengi, mynd) --function til að auðvelda teikningu hugsanna, hvenær í leiknum það á að gerast

  if start < timer and start + hvelengi > timer and alpha < 246 then
	   alpha = alpha + 8
		 fade = false
	   else
	   fade = true
	 end

	if start < timer and start + hvelengi + 2 > timer then --Annars teiknar hún bara allar hugsanir samtímis! + 2 þýðir að animationið fær 2 sek til að hverfa(alpha að lækka)
	   setColor(211, 211, 211, alpha)
		love.graphics.draw(mynd, ond_x + 40, mynd_y, 0, 0.4, 0.4)
		setColor(255, 255, 255, 255)
	end

	if fade == true and alpha > 0 then
	    alpha = alpha - 2
	end

	if start < timer and start + 0.5 > timer then
	    kakk:setLooping(false)
	    love.audio.play(kakk)
	end

	if ond_y - 120 > 0 then  --svo að myndin/hugsunin fari ekki út af skjánum þegar öndin er lengst uppi.
	    mynd_y = ond_y - 120
	else
	    mynd_y = 0
	end

end

return thoughtBubble
