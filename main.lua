-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

class = require("libs/middleclass")
utils = require("libs/utils")
jupiter = require("libs/jupiter")

require("libs/gamestate")
require("libs/graphics")


require("entity")
require("player")

require("state_ingame")

function love.load()

	keyconfig = jupiter.load("keyconfig.txt")
	gameStateManager = GameStateManager:new()
	gameStateManager:registerState(InGameState)
	gameStateManager:changeState(InGameState, "map1.tmx")
end


function love.draw()
	gameStateManager:draw()
end

function love.update(dt)
	gameStateManager:update(dt)
end

function love.keypressed(key)
	gameStateManager:keypressed(key)
end

function love.keyreleased(key)
	gameStateManager:keyreleased(key)
end