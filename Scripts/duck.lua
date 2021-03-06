--The duck class
require("Libraries/AnAL")

local class = require("Libraries/middleclass")

local duck = class("duck")

function duck:initialize()

  self.ond = love.graphics.newImage("Resources/tond.png")
  self.hond = newAnimation(self.ond, 119, 88, 0.1, 0)
	self.ond_x = 75
	self.ond_y = 150
	self.ond_rot = 3.14
	self.ond_speed = 1
	self.ond_upp = 35  --15
	self.ond_down = 35  --15
	self.ond_x_scale = 0.7
	self.ond_y_scale = 0.7

  self.ond_collision_x = self.ond_x + 10  --Because i want the collision circle to be a bit different than the normal xy of the brid
  self.ond_collision_y = self.ond_y - 5

  self.ond_collision_radius = 16

  self.movement_mode = 1

  --Movement_mode: 1 = in the opening cinematic with the zzz bubbles
  --2 = in space without gravity
  --3 = in space with gravity
  --4 = Ending cutscene on beziercurve

  self.vuff = love.audio.newSource("Resources/vaengir-noiseremoved.ogg", "static")
	self.vuff:setVolume(1.5)
  self.vuff_play = false
end

function duck:setScaleY(number)
  self.ond_y_scale = number
end

function duck:setScaleX(number)
  self.ond_x_scale = number
end

function duck:setRotation(number)
  self.ond_rot = number
end

function duck:setY(number)
  self.ond_collision_y = number
  self.ond_y = number
  self.ond_speed = 0 --Put speed to zero so duck doesnt continu with the momentum when it crashes
end

function duck:getMovemmentMode()
  return self.movement_mode
end

function duck:setMovementMode(number)
  self.movement_mode = number
end

function duck:setWingAudio(boolean)
  self.vuff_play = boolean
end

function duck:update(dt, push)

    if self.vuff_play == true then --The noise from the wings, should only be played once inside of the planet
      love.audio.play(self.vuff)
    else
      love.audio.stop(self.vuff)
    end

    self.mx, self.my = love.mouse.getPosition()
    local sx, sy = push:toGame(self.mx, self.my)

    if self.movement_mode == 2 or self.movement_mode == 3 then  --only update animation if bird is in space with or without gravity, but not in the start and end.
      self.hond:update(dt) --Animation updater
    else if self.movement_mode == 1 then
      self.hond:seek(5) --seek stoppar animationið bara á einu frame-i! hond er 5 frame animation
    else
      self.hond:seek(2)
    end
    end


    --Collision detection on the top and bottom of screen, so the bird doesnt go off screen
    if self.ond_y > 310 then  --svo að öndinn fljúgi ekki af skjánum að neðan, gefur henni örlitið boost uppávið.
  	    self.ond_speed = -2
  	end
  	if self.ond_y < 0 then  --Sama og uppi nema hér er efri hlutinn af skjánum
  	    self.ond_speed = 2
  	end

    if self.movement_mode == 2 then
      --Movement without gravity
      if love.mouse.isDown(1) then  --timer bara vegna opening cutscene!
        if sy > self.ond_y and self.ond_y < 290 then  --movement sytem i engu þyngdarafli
          self.ond_y = self.ond_y + 50*dt
        end
        if sy < self.ond_y and self.ond_y > 20 then
          self.ond_y = self.ond_y - 50*dt
        end
      end
    end

    if self.movement_mode == 3 then
      --Movement with gravity applied
	     while self.ond_upp < 40 do
	        self.ond_upp = self.ond_upp + 2*dt
		   end
		   while self.ond_down < 30 do
		       self.ond_down = self.ond_down + 2*dt
		   end

	     self.ond_y = self.ond_y + self.ond_speed*dt
	     if love.mouse.isDown(1) then   --movement í þyngdarafli
		    self.ond_speed = self.ond_speed - self.ond_upp*dt
		   else
	      self.ond_speed = self.ond_speed + self.ond_down*dt
		   end

       --rotation of da bird
       if love.mouse.isDown(1) then
 		    self.ond_rot = self.ond_rot - 0.15*dt
 		   else if self.ond_rot < 3.15 then
 		    self.ond_rot = self.ond_rot + 0.15*dt
 		   end
 		  end

    end
    --In update since i need to update these variables as well with the movement of the duck
    self.ond_collision_x = self.ond_x + 10  --Because i want the collision circle to be a bit different than the normal xy of the brid
    self.ond_collision_y = self.ond_y - 5


end

function duck:draw()

  self.hond:draw(self.ond_x, self.ond_y, self.ond_rot, self.ond_x_scale, self.ond_y_scale, 60, 44)

  --love.graphics.circle("fill", self.ond_collision_x, self.ond_collision_y, self.ond_collision_radius, 16)

end


return duck
