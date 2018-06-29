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


function love.load()
  --Fonts
  font = love.graphics.newFont("Resources/Dimbo Regular.ttf", 18) --Venjulegi
  font2 = love.graphics.newFont("Resources/Dimbo Regular.ttf", 30) --Stærri fonturinn

  --duck:initialize()
  duck = duck:new() --new() is a static method of every class, if obj:initialize() is in the class than new() will take those arguments,
  star = star:new()
  asteroid_grey = asteroid:new("Resources/ast.png")
  asteroid_yellow = asteroid:new("Resources/ast2.png") --Same as asteroid just with another image, has some yellow colors in it
  thoughtBubble1 = thoughtBubble:new("Resources/hugs2.png", 20) --In middleclass new is a taken keywor to create a new object of x class
  thoughtBubble2 = thoughtBubble:new("Resources/hugs3.png", 30) --f. ex. 30 represents that it will be drawn after 30 seconds, connected to the master_timer
  thoughtBubble3 = thoughtBubble:new("Resources/hugs4.png", 40)
  zzz = zzz:new()
  nebula = nebula:new()
  lifeBar = lifeBar:new()
  menu = menu:new()
  reset = reset:new()
  planet = planet:new(5)
  cloud = cloud:new()
  forest = forest:new()
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


end

function love.update(dt)

  for i = 1, #asteroid_grey.aster do
    if circlecollision2(duck.ond_collision_x, duck.ond_collision_y, asteroid_grey.aster[i].ast_x, asteroid_grey.aster[i].ast_y, duck.ond_collision_radius, asteroid_grey.asteroid_collision_radius) == true then
      --reset_paused = true
    end
  end

  for i = 1, #asteroid_yellow.aster do
    if circlecollision2(duck.ond_collision_x, duck.ond_collision_y, asteroid_yellow.aster[i].ast_x, asteroid_yellow.aster[i].ast_y, duck.ond_collision_radius, asteroid_yellow.asteroid_collision_radius) == true then
      --reset_paused = true
    end
  end

  for i = 1, #forest.trees do
    if circlecollision2(duck.ond_collision_x, duck.ond_collision_y, forest.trees[i].tre_x + 85, forest.trees[i].tre_y + 35 + forest.forest_y, duck.ond_collision_radius, forest.tree_collision_radius) == true and forest:getActive() == true then
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
    duck:update(dt)
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
    --forest:update(dt)
    master_timer = master_timer + dt
  else
    love.audio.stop() --Stops all audio in the game if game is in paused mode
  end

  menu:update(dt)

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

end

function love.draw()

  love.graphics.setFont(font) --Setting the font
  star:draw()
  planet:draw(master_timer)
  duck:draw()
  asteroid_grey:draw()
  asteroid_yellow:draw()
  zzz:draw(master_timer, duck.ond_y, font2)
  nebula:draw()
  lifeBar:draw()
  thoughtBubble1:draw(duck.ond_x, duck.ond_y)
  thoughtBubble2:draw(duck.ond_x, duck.ond_y)
  thoughtBubble3:draw(duck.ond_x, duck.ond_y)
  menu:draw()
  reset:draw()
  cloud:draw()
  forest:draw()
  for i = 1, #asteroid_grey.aster do
    love.graphics.line(duck.ond_x, duck.ond_y, asteroid_grey.aster[i].ast_x, asteroid_grey.aster[i].ast_y)  --Skemmtilegar linur!
  end
  for i = 1, #forest.trees do
    love.graphics.line(duck.ond_x, duck.ond_y, forest.trees[i].tre_x + 85, forest.trees[i].tre_y + 35 + forest.forest_y)  --Skemmtilegar linur!
  end
  love.graphics.print(tostring(cloud.clouds_cycles))
  love.graphics.print(tostring(asteroid.asteroid_destroy), 0, 25)



end

function love.mousepressed(x, y, button, isTouch)

  if reset:isClicked(x, y, button, isTouch) == true then
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

  if menu:isMenuClicked(x, y, button, isTouch) == true then
    if menu_onoff % 2 == 0 then
      menu:setMenuActive(false)
      menu_paused = false
    else
      menu:setMenuActive(true)
      menu_paused = true
    end
    menu_onoff = menu_onoff + 1
  end

  if menu:isQuitClicked(x, y, button, isTouch) == true and menu:getCreditActive() ~= true then --second parameter is so that the user cant accidentaly click reset or quit button while watching the about screen
    love.event.quit()
  end

  if menu:isRestartClicked(x, y, button, isTouch) == true and menu:getCreditActive() ~= true then
    resetGame()
  end

  if menu:isCreditClicked(x, y, button, isTouch) == true then
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
  thoughtBubble1:initialize("Resources/hugs2.png", 20)
  thoughtBubble2:initialize("Resources/hugs3.png", 30)
  thoughtBubble3:initialize("Resources/hugs4.png", 40)
  zzz:initialize()
  nebula:initialize()
  lifeBar:initialize()
  menu:initialize()
  reset:initialize()
  planet:initialize(5)
  cloud:initialize()
  forest:initialize()
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
