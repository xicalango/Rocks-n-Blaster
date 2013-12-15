-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

local ATL = require("libs/AdvTiledLoader")

MapChangeState = GameState:subclass("MapChangeState")

function MapChangeState:initialize()
	ATL.Loader.path = "maps/"

	self.speed = 100
end

function MapChangeState:onActivation(nextMapFile, oldMap)
	self.oldMap = oldMap

	self.nextMap = self:_loadMap(nextMapFile)
	self.nextMapFile = nextMapFile

	self.completion = 0

	if self.oldMap ~= nil then
		self.state = 0
		self.drawMap = self.oldMap
	else
		self.state = 1
		self.drawMap = self.nextMap
	end

	love.filesystem.write("resumeMap.txt", nextMapFile)

end

function MapChangeState:draw()

	local tx = 160 - (self.drawMap.width * self.drawMap.tileWidth)/2
	local ty = 120 - (self.drawMap.height * self.drawMap.tileHeight)/2

	love.graphics.translate(tx, ty)

	self.drawMap:autoDrawRange(tx, ty, s )
	self.drawMap:draw()

	love.graphics.translate(-tx, -ty)

	utils.withColor({0,0,0,255}, function()


		if self.state == 0 then
			love.graphics.rectangle("fill", 0, 0, self.completion  * (320/100), 240)
		elseif self.state == 1 then
			love.graphics.rectangle("fill", self.completion  * (320/100), 0, 320, 240)
		end


	end)

	if self.state == 1 then


	utils.withColor({255,255,255,255}, function()

		local font = love.graphics.getFont()

		love.graphics.setFont(headlineFont)

		love.graphics.print( string.sub(self.nextMapFile, 1, -4), self.completion  * (320/100) + 5, 120 )

		love.graphics.setFont(font)

		love.graphics.setScissor()

		end)

	end


end

function MapChangeState:update(dt)

	self.completion = self.completion + (self.speed * dt)

	if self.completion >= 100 then
		if self.state == 0 then 
			self.state = 1 
			self.drawMap = self.nextMap
			self.completion = 0
		else
			gameStateManager:changeState(InGameState, self.nextMap, self.nextMapFile)
		end
	end
end


function MapChangeState:_loadMap(map)
	local genMap = ATL.Loader.load(map)

	local objectsLayer = genMap("Objects")

	local function convertObjects(objectDef)

		if objectDef.type == "PlayerStartingPosition" then

			return Player:new(objectDef.x + 8, objectDef.y + 8, objectDef.properties.number)

		elseif objectDef.type == "Rock" then

			return Rock:new(objectDef.x + 8, objectDef.y + 8)

		elseif objectDef.type == "Message" then

			return Message:new(objectDef.x, objectDef.y, objectDef.properties.message)

		elseif objectDef.type == "Mob" then

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

			if obj.remove then
				self.objects[k] = nil
			end

		end

	end

	function objectsLayer:keypressed(key)
		for k,obj in pairs(self.objects) do
			if obj:keypressed(key) then break end
		end
	end		

	function objectsLayer:keyreleased(key)
		for k,obj in pairs(self.objects) do
			if obj:keyreleased(key) then break end
		end
	end

	return genMap

end

function MapChangeState:keypressed(key)
	gameStateManager:changeState(InGameState, self.nextMap, self.nextMapFile)
end