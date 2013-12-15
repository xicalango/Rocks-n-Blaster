-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>


MainMenuState = GameState:subclass("MainMenuState")

local ATL = require("libs/AdvTiledLoader")

function MainMenuState:initialize()

	ATL.Loader.path = "maps/"

	self.headlineFont = love.graphics.newFont("assets/Munro.ttf", 20)

end

function MainMenuState:onActivation(resumeMap)
	self.map = self:_loadMap("menu.tmx")
	gameManager = GameManager:new(self)

	self.resumeMap = resumeMap 
end


function MainMenuState:_loadMap(map)
	local genMap = ATL.Loader.load(map)

	local objectsLayer = genMap("Objects")

	local function convertObjects(objectDef)

		if objectDef.type == "Mob" then

			return Mob:new(objectDef.x + 8, objectDef.y + 8, objectDef.properties.dir, objectDef.properties.speed)

		end
	end

	objectsLayer:toCustomLayer(convertObjects)

	function objectsLayer:draw()
		for k,obj in pairs(self.objects) do
			obj:draw()
		end
	end

	function objectsLayer:update(dt)
		for k,obj in pairs(self.objects) do
			obj:update(dt)
		end

	end

	return genMap

end

function MainMenuState:draw()

	self.map:draw()

	local font = love.graphics.getFont()
	love.graphics.setFont(self.headlineFont)

	love.graphics.print("Rocks-n-Blaster", 48, 100)

	love.graphics.setFont(font)

	love.graphics.print( "1 - Start Game", 48, 128)

	if not self.resumeMap then
		love.graphics.setColor(255,255,255,127)
	end
	love.graphics.print( "2 - Resume Game", 48, 144)
	love.graphics.setColor(255,255,255,255)

	love.graphics.print( "3 - Quit", 48, 160)

end


function MainMenuState:keypressed(key)
	if key == "1" then
		gameStateManager:changeState(MapChangeState, "tutorial1.tmx", self.map)
	elseif key == "2" and self.resumeMap then
		gameStateManager:changeState(MapChangeState, self.resumeMap, self.map)
	elseif key == "3" then
		love.event.push('quit')
	end
end


function MainMenuState:update(dt)
	self.map:callback("update",dt)
end
