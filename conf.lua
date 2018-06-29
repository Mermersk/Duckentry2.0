function love.conf(t)

	kerfi = love._os  --Kikir hvaða stýrikerfi er áður en allt löve vélin og kóðin keyrist
    --kerfi = "Android"

	if kerfi == "Android" then
      t.window.width = 0
      t.window.height = 0
	    t.title = "Duckentry"
      t.author = "Isak Steingrimsson"
	end

	if kerfi == "Windows" or "OS X" or "Linux" then
	  t.window.width = 480
		t.window.height = 320
		t.title = "Duckentry"
    t.author = "Isak Steingrimsson"

	end

end
