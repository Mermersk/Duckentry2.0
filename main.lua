--Duckentry 2.0 rewrite to make a clearer, more efficient and cleaner version of Duckentry. OOP based design.

local duck = require("Scripts/duck")
local star = require("Scripts/stars")
local asteroid = require("Scripts/asteroids")
local zzz = require("Scripts/zzz")
local thoughtBubble = require("Scripts/thoughtBubble")
local nebula = require("Scripts/nebula")
local lifeBar =require("Scripts/lifebar")
local menu = require("Scripts/menu")
local reset = require("Scripts/reset")
local planet = require("Scripts/planet")
local cloud = require("Scripts/cloud")
local forest = require("Scripts/forest")
local water = require("Scripts/water")
local ending = require("Scripts/ending")

local push = require("Libraries/push")


function love.load()

  local gameWidth, gameHeight = 480, 320
  local screenWidth, screenHeight = 480, 320 --love.window.getDesktopDimensions()
  local dpi_scale = love.window.getDPIScale()
  screenWidth = screenWidth/dpi_scale
  screenHeight = screenHeight/dpi_scale
    push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, {fullscreen = false, resizable = false, canvas = false, pixelperfect = false, highdpi = true, stretched = true}) --{fullscreen = true, resizable = false, canvas = true, pixelperfect = false, highdpi = false, stretched = true}
    --OBS: Enabling canvas in setupScreen to true completely tanked performance on my phone from 60fps to about 18-21 with it enabled!

  --Fonts
  font = love.graphics.newFont("Resources/Dimbo Regular.ttf", 18) --Venjulegi
  font2 = love.graphics.newFont("Resources/Dimbo Regular.ttf", 30) --Stærri fonturinn

  duck = duck:new() --new() is a static method of every class, if obj:initialize() is in the class than new() will take those arguments,
  star = star:new()
  asteroid_grey = asteroid:new("Resources/ast.png")
  asteroid_yellow = asteroid:new("Resources/ast2.png") --Same as asteroid just with another image, has some yellow colors in it
  thoughtBubble1 = thoughtBubble:new("Resources/hugs2.png", 35) --In middleclass new is a taken keywor to create a new object of x class
  thoughtBubble2 = thoughtBubble:new("Resources/hugs3.png", 60) --f. ex. 30 represents that it will be drawn after 30 seconds, connected to the master_timer
  thoughtBubble3 = thoughtBubble:new("Resources/hugs4.png", 85)
  zzz = zzz:new()
  nebula = nebula:new()
  lifeBar = lifeBar:new()
  menu = menu:new()
  reset = reset:new()
  planet = planet:new(105)
  cloud = cloud:new()
  forest = forest:new()
  water = water:new()
  ending = ending:new()
  --Movement_mode: 1 = in the opening cinematic with the zzz bubbles
  --2 = in space without gravity
  --3 = in space with gravity
  --4 = Ending cutscene on beziercurve
  duck:setMovementMode(2)
  master_timer = 0 --master_timer is the main timer in the game begins at 0 in beginning and counts up in sconds

  menu_paused = true
  reset_paused = false
  master_paused = true
  menu_onoff = 0 --This is for the modulo operator in love.keypressed for the menu

  landing_up_y = 110
  landing_down_y = 75

end

function love.update(dt)

  for i = 1, #asteroid_grey.aster do
    if circlecollision2(duck.ond_collision_x, duck.ond_collision_y, asteroid_grey.aster[i].ast_x, asteroid_grey.aster[i].ast_y, duck.ond_collision_radius, asteroid_grey.asteroid_collision_radius) == true then
      love.system.vibrate(1/3)
      reset_paused = true
    end
  end

  for i = 1, #asteroid_yellow.aster do
    if circlecollision2(duck.ond_collision_x, duck.ond_collision_y, asteroid_yellow.aster[i].ast_x, asteroid_yellow.aster[i].ast_y, duck.ond_collision_radius, asteroid_yellow.asteroid_collision_radius) == true then
      love.system.vibrate(1/3)
      reset_paused = true
    end
  end

  for i = 1, #forest.trees do
    if circlecollision2(duck.ond_collision_x, duck.ond_collision_y, forest.trees[i].tre_x + 85, forest.trees[i].tre_y + 35 + forest.forest_y, duck.ond_collision_radius, forest.tree_collision_radius) == true and forest:getActive() == true then
      love.system.vibrate(1/3)
      reset_paused = true
      duck:setY(15)
    end
  end

  if reset_paused == true then
    reset:setActive(true) --Make the reset button appear
    if forest:getActive() ~= true then
      asteroid_grey:initialize("Resources/ast.png") --Resets the asteroids to their beginning state as it was in asteroid:new()
      asteroid_yellow:initialize("Resources/ast2.png")
    end

  end

  if menu_paused == true or reset_paused == true then
    master_paused = true
  else
    master_paused = false
  end

  if master_paused ~= true then
    duck:update(dt, push)
    star:update(dt)
    asteroid_grey:update(dt, planet:getActive()) --I put in the planet boolean to know when to start the particle-system
    asteroid_yellow:update(dt, planet:getActive())
    thoughtBubble1:update(dt, master_timer)
    thoughtBubble2:update(dt, master_timer)
    thoughtBubble3:update(dt, master_timer)
    zzz:update(dt, master_timer)
    nebula:update(dt)
    lifeBar:update(dt)
    planet:update(dt, master_timer)
    cloud:update(dt)
    forest:update(dt)
    water:update(dt)
    ending:update(dt, duck.ond_x, duck.ond_y, water.points_organized[17], water.points_organized[18] + 40) --[9] i water.points
    master_timer = master_timer + dt
  else
    love.audio.stop() --Stops all audio in the game if game is in paused mode
  end

  menu:update(dt)

  if master_timer < 4 then
    duck:setMovementMode(1)
  else
    duck:setMovementMode(2)
  end

  if lifeBar:getLifes() == 1 then
    reset:setFont(font)
    reset:setText("Game over! \n Restart?")
  end

  if planet:getActive() == true then
    duck:setMovementMode(3)
    duck:setWingAudio(true)
    nebula:setActive(false)
    cloud:setVindAudioActive(true)
  end

  if cloud:getSwitchToForest() == true then
    forest:setActive(true)
    if forest.forest_x < -550 then
      forest:setActive(false)
    end
  end


  if forest:getActive() == true then
    cloud:setVindVolume(0.2)
  else
    cloud:setVindVolume(0.6)
  end

  if planet:getSwitchToClouds() == true then
    asteroid_grey:destroy(true)
    asteroid_yellow:destroy(true)
    cloud:setVindActive(true)
  end

  if forest:getSwitchToWater() == true then
    water:setActive(true)
  end

  if ending:getEndOfGame() == true then
    menu:setCreditActive(true)
  end

  if water:getSwitchToLanding() == true then
    if ending.position == 0 then
      ending:setLandingSign(true)
    else
      ending:setLandingSign(false)
    end

    if duck.ond_y > landing_down_y and duck.ond_y < landing_up_y then
      landing_down_y = 0
      landing_up_y = 400
      duck.ond_x = ending:getCurvePositionX()
  	  duck.ond_y = ending:getCurvePositionY()
      ending:setActive(true)
      duck:setMovementMode(4)

      local curve_position = ending:getCurvePosition()
      if curve_position > 0.29 and curve_position < 0.80 then
        duck:setRotation(0)
        duck.ond_y_scale = -0.7
      else
        duck:setRotation(3.14)
        duck.ond_y_scale = 0.7
      end
  	end
  end


end

function love.draw()
  push:start()
  love.graphics.setFont(font) --Setting the font
  star:draw()
  planet:draw(master_timer)
  zzz:draw(master_timer, duck.ond_y, font2)

  push:finish()
  nebula:draw(push)
  push:start()

  duck:draw()
  asteroid_grey:draw()
  asteroid_yellow:draw()
  lifeBar:draw()
  thoughtBubble1:draw(duck.ond_x, duck.ond_y)
  thoughtBubble2:draw(duck.ond_x, duck.ond_y)
  thoughtBubble3:draw(duck.ond_x, duck.ond_y)
  reset:draw()
  cloud:draw()

  push:finish()
  water:draw(push)
  forest:draw(push)
  push:start()

  ending:draw()
  menu:draw()
  for i = 1, #asteroid_grey.aster do
    --love.graphics.line(duck.ond_x, duck.ond_y, asteroid_grey.aster[i].ast_x, asteroid_grey.aster[i].ast_y)  --Skemmtilegar linur!
  end
  for i = 1, #forest.trees do
    --love.graphics.line(duck.ond_x, duck.ond_y, forest.trees[i].tre_x + 85, forest.trees[i].tre_y + 35 + forest.forest_y)  --Skemmtilegar linur!
  end
  --love.graphics.print(screenWidth)
  --love.graphics.print(screenHeight, 0, 25)
  --love.graphics.print(love.window.getDPIScale(), 0, 50)
  --love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 0, 75)
  --love.graphics.print(tostring(asteroid.asteroid_destroy), 0, 25)

  push:finish()
   --Because of an advanced canvas the drawing itself to the canvas must not be scaled, but the canvas itself should be scaled
end

function love.mousepressed(x, y, button, isTouch)

  local sx, sy = push:toGame(x, y) --scaledX and ScaledY from the push library scales values to the screen size

  if reset:isClicked(sx, sy, button, isTouch) == true then
    if lifeBar:getLifes() == 1 then
      resetGame()
      reset_paused = false
      menu_paused = true
      --reset:setActive(false)
    else
      lifeBar:subtract() --Subtract 1 life of the 3 lifes the player has
      reset_paused = false
    end
  end

  if menu:isMenuClicked(sx, sy, button, isTouch) == true then
    if menu_onoff % 2 == 0 then
      menu:setMenuActive(false)
      menu_paused = false
    else
      menu:setMenuActive(true)
      menu_paused = true
    end
    menu_onoff = menu_onoff + 1
  end

  if menu:isQuitClicked(sx, sy, button, isTouch) == true and menu:getCreditActive() ~= true then --second parameter is so that the user cant accidentaly click reset or quit button while watching the about screen
    love.event.quit()
  end

  if menu:isRestartClicked(sx, sy, button, isTouch) == true and menu:getCreditActive() ~= true then
    resetGame()
  end

  if menu:isCreditClicked(sx, sy, button, isTouch) == true then
    menu:setCreditActive(true)
  else
    menu:setCreditActive(false) --if clicked anywhere else then remove credit screen
  end


end

function resetGame() --Resets whole game

  duck:initialize()
  star:initialize()
  asteroid_grey:initialize("Resources/ast.png")
  asteroid_yellow:initialize("Resources/ast2.png")
  thoughtBubble1:initialize("Resources/hugs2.png", 35)
  thoughtBubble2:initialize("Resources/hugs3.png", 60)
  thoughtBubble3:initialize("Resources/hugs4.png", 85)
  zzz:initialize()
  nebula:initialize()
  lifeBar:initialize()
  menu:initialize()
  reset:initialize()
  planet:initialize(105)
  cloud:initialize()
  forest:initialize()
  water:initialize()
  ending:initialize()
  master_timer = 0
  duck:setMovementMode(2)
  love.audio.stop()


end

--Collision detection
--byr til tvo hringi utan um hlutina og gáir hvort þeir eru að klessa
--ax, bx, ay, by eru x- og y - hnit tveggja hluta á færingu
--iaw = image-a-width svo iay = image.a.height, ibw = image-b-width

function circlecollision(ax, ay, bx, by, iaw, iah, ibw, ibh)
    if math.abs(ax - bx) * 2 < (iaw + ibw) and
	math.abs(ay - by) * 2 < (iah + ibh) then
	    collision = true
	else
	    collision = false
	end

	return collision
end


--Collision detection
--byr til tvo hringi utan um hlutina og gáir hvort þeir eru að klessa
--ax, bx, ay, by eru x- og y - hnit tveggja hluta á færingu
--iaw = image-a-width svo iay = image.a.height, ibw = image-b-width

function circlecollision2(xa, ya, xb, yb, rada, radb)
    if math.sqrt(math.abs(xa-xb)^2 + math.abs(ya-yb)^2) < rada + radb then
	    collision = true
	else
	    collision = false
	end

	return collision
end


--function scale()
  --local love_draw_original = love.draw
  --love.draw = function()
  --local game_width, game_height = 480, 320
  --local screen_width, screen_height = love.window.getDesktopDimensions()
  --local dpi_scale = love.window.getDPIScale()
  --screen_width = screen_width/dpi_scale
  --screen_height = screen_height/dpi_scale
  --screen_width, screen_height = love.window.fromPixels(screen_width, screen_height)

  --[[ fromPixels converts the width and height of screen and approximates the resolution in regards to pixel density.
  For example is the pixel density factor is 3 on my phone but the resolution is 1920x1080, if i scale game to that res it will be all wrong on my phone, the real resolution to scale to is widht/pixeldensity_factor, in this case 640 for the width
  ]]

  --local scale_x = screen_width/game_width
  --local scale_y = screen_height/game_height

  --love.graphics.push()
  --love.graphics.scale(scale_x, scale_y)
  --love_draw_original()
  --love.graphics.pop()
  --end
--end
--scale()

--In löve 0.11 the values for rgba go now from 0 to 1 instead of 0 to 255. But I dont want to rewrite all setColor function in this program so I replace the love.graphics.setColor function with a new one
--which handles the conversion for me
function setColor(r, g, b, a)
	local r_new = r/255 --Divide with 255 to get the same value in 0-1 format
	local g_new = g/255
	local b_new = b/255

	local a_new = 1 --If only rgb values are the input then go full alpha, if given do the calculations beneath
	if a ~= nil then
		a_new = a/255
	end

	love.graphics.setColor(r_new, g_new, b_new, a_new)

end
