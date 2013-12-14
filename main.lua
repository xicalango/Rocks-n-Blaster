-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

require("libs/middleclass")
local ATL = require("libs/AdvTiledLoader")

function love.load()

	ATL.Loader.path = "maps/"

	map = ATL.Loader.load("map1.tmx")

end


function love.draw()

	map:draw()

end

