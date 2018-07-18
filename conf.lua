function love.conf(t)

	kerfi = love._os  --Kikir hvaða stýrikerfi er áður en allt löve vélin og kóðin keyrist
    --kerfi = "Android"

	--if kerfi == "Android" then
    --  t.window.width = 0
      --t.window.height = 0
	    --t.title = "Duckentry"
      --t.author = "Isak Steingrimsson"
	--end

	--if kerfi == "Windows" or "OS X" or "Linux" then
	  --t.window.width = 0 --Putting width and height to zero will make löve open the game in the resolution of the screen
		--t.window.height = 0 --The same resolution you get with love.window.getDesktopDimensions
		t.title = "Duckentry"
    t.author = "Isak Steingrimsson"
		
	--end

end
