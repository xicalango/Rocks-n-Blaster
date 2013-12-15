-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

class = require("libs/middleclass")
utils = require("libs/utils")

require("libs/slam")

require("libs/gamestate")
require("libs/graphics")

require("gamemanager")

require("entity")
require("player")
require("bomb")
require("rock")
require("explosion")
require("message")
require("mob")

require("state_ingame")
require("state_mapchange")
require("state_mainmenu")
require("state_gameover")

keyconfig = require("keyconfig")

function love.load()

	takeScreenshot = false

	gameStateManager = GameStateManager:new()
	gameStateManager:registerState(InGameState)
	gameStateManager:registerState(MapChangeState)
	gameStateManager:registerState(MainMenuState)
	gameStateManager:registerState(GameOverState)

	mainFont = love.graphics.newFont("assets/Munro.ttf", 10)
	headlineFont = love.graphics.newFont("assets/Munro.ttf", 20)
	love.graphics.setFont(mainFont)


	nextLevelSound = love.audio.newSource("assets/complete.wav", 'static')
	explosionSound = love.audio.newSource("assets/explode.wav", 'static')


	local resumeMap = nil

	if love.filesystem.isFile("resumeMap.txt") then
		resumeMap, readBytes = love.filesystem.read("resumeMap.txt")
	end


	gameStateManager:changeState(MainMenuState, resumeMap)

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
  	elseif key == "f5" then
    	love.graphics.toggleFullscreen()
	end

	gameStateManager:keypressed(key)
end

function love.keyreleased(key)
	gameStateManager:keyreleased(key)
end
