-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

class = require("libs/middleclass")
utils = require("libs/utils")
jupiter = require("libs/jupiter")

require("libs/gamestate")
require("libs/graphics")

require("gamemanager")

require("entity")
require("player")
require("bomb")
require("rock")
require("explosion")

require("state_ingame")

function love.load()

	takeScreenshot = false

	keyconfig = jupiter.load("keyconfig.txt")

	gameStateManager = GameStateManager:new()
	gameStateManager:registerState(InGameState)
	gameStateManager:changeState(InGameState, "map1.tmx")
end


function love.draw()
	gameStateManager:draw()

	if takeScreenshot then
		takeScreenshot = false
		local screenshot = love.graphics.newScreenshot()
		screenshot:encode( "rnb_" .. love.timer.getMicroTime() .. ".png" )
	end
end

function love.update(dt)
	gameStateManager:update(dt)
end

function love.keypressed(key)
	if key == "f12" then
		takeScreenshot = true
	end

	gameStateManager:keypressed(key)
end

function love.keyreleased(key)
	gameStateManager:keyreleased(key)
end