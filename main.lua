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

  --Movement_mode: 1 = in the opening cinematic with the zzz bubbles
  --2 = in space without gravity
  --3 = in space with gravity
  --4 = Ending cutscene on beziercurve
  duck:setMovementMode(2)
  master_timer = 0 --master_timer is the main timer in the game begins at 0 in beginning and counts up in sconds

  paused = false

end

function love.update(dt)

  for i = 1, #asteroid_grey.aster do
    if circlecollision2(duck.ond_collision_x, duck.ond_collision_y, asteroid_grey.aster[i].ast_x, asteroid_grey.aster[i].ast_y, duck.ond_collision_radius, asteroid_grey.asteroid_collision_radius) == true then
      paused = true
    end
  end

  for i = 1, #asteroid_yellow.aster do
    if circlecollision2(duck.ond_collision_x, duck.ond_collision_y, asteroid_yellow.aster[i].ast_x, asteroid_yellow.aster[i].ast_y, duck.ond_collision_radius, asteroid_yellow.asteroid_collision_radius) == true then
      paused = true
    end
  end

  if paused == true then
    reset:setActive(true) --Make the reset button appear
    asteroid_grey:initialize("Resources/ast.png") --Resets the asteroids to their beginning state as it was in asteroid:new()
    asteroid_yellow:initialize("Resources/ast2.png")

  end

  if paused ~= true then
    duck:update(dt)
    star:update(dt)
    asteroid_grey:update(dt)
    asteroid_yellow:update(dt)
    thoughtBubble1:update(dt, master_timer)
    thoughtBubble2:update(dt, master_timer)
    thoughtBubble3:update(dt, master_timer)
    zzz:update(dt, master_timer)
    nebula:update(dt)
    lifeBar:update(dt)

    master_timer = master_timer + dt
  end


end

function love.draw()

  love.graphics.setFont(font) --Setting the font
  star:draw()
  duck:draw()
  asteroid_grey:draw()
  asteroid_yellow:draw()
  zzz:draw(master_timer, duck.ond_y, font2)
  nebula:draw()
  lifeBar:draw()
  menu:draw()
  reset:draw()

  for i = 1, #asteroid_grey.aster do
    love.graphics.line(duck.ond_x, duck.ond_y, asteroid_grey.aster[i].ast_x, asteroid_grey.aster[i].ast_y)  --Skemmtilegar linur!
  end
  for i = 1, #asteroid_yellow.aster do
    love.graphics.line(duck.ond_x, duck.ond_y, asteroid_yellow.aster[i].ast_x, asteroid_yellow.aster[i].ast_y)  --Skemmtilegar linur!
  end
  love.graphics.print(tostring(reset:getActive()))

  thoughtBubble1:draw(duck.ond_x, duck.ond_y)
  thoughtBubble2:draw(duck.ond_x, duck.ond_y)
  thoughtBubble3:draw(duck.ond_x, duck.ond_y)

end

function love.mousepressed(x, y, button, isTouch)

  if reset:isClicked(x, y, button, isTouch) == true then
    lifeBar:subtract() --Subtract 1 life of the 3 lives the player has
    paused = false
  end

  menu:isMenuClicked(x, y, button, isTouch)

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
