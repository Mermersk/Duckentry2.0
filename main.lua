--Duckentry 2.0 rewrite to make a clearer, more efficient and cleaner version of Duckentry. OOP based design.

local duck = require("Scripts/duck")
local star = require("Scripts/stars")
local asteroid = require("Scripts/asteroids")
local asteroid_yellow = require("Scripts/asteroids")

function love.load()
  --Fonts
  font = love.graphics.newFont("Resources/Dimbo Regular.ttf", 18) --Venjulegi
  font2 = love.graphics.newFont("Resources/Dimbo Regular.ttf", 30) --Stærri fonturinn

  duck:initialize()
  star:initialize()
  asteroid:initialize("Resources/ast.png")
  asteroid_yellow:initialize("Resources/ast2.png") --Same as asteroid just with another image, has some yellow colors in it

  --Movement_mode: 1 = in the opening cinematic with the zzz bubbles
  --2 = in space without gravity
  --3 = in space with gravity
  --4 = Ending cutscene on beziercurve
  duck:setMovementMode(1)

end

function love.update(dt)

  duck:update(dt)
  star:update(dt)
  asteroid:update(dt)
  asteroid_yellow:update(dt)

  --if circlecollision(duck.ond_x, duck.ond_y, asteroid.)

end

function love.draw()

  love.graphics.setFont(font) --Setting the font
  star:draw()
  duck:draw()
  asteroid:draw()
  asteroid_yellow:draw()
  love.graphics.print(asteroid.aster[1].ast_x)

end



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
