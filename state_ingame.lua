-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

local ATL = require("libs/AdvTiledLoader")


InGameState = GameState:subclass("InGameState")

function InGameState:initialize()
	ATL.Loader.path = "maps/"

	self.addEntities = {}
end

function InGameState:onActivation(mapFile)

	self.mapFile = mapFile

	self:_loadMap(mapFile)	

end

function InGameState:addEntity(e)
	table.insert(self.addEntities, e)
end

function InGameState:_loadMap(map)
	self.map = ATL.Loader.load(map)

	gameManager = GameManager:new(self.map, self)

	self.objectsLayer = self.map("Objects")


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

	self.objectsLayer:toCustomLayer(convertObjects)

	function self.objectsLayer:draw()
		for k,obj in pairs(self.objects) do
			obj:draw()
		end
	end

	function self.objectsLayer:update(dt)
		for k,obj in pairs(self.objects) do
			obj:update(dt)

			if obj.remove then
				self.objects[k] = nil
			end

		end

	end

	function self.objectsLayer:keypressed(key)
		for k,obj in pairs(self.objects) do
			if obj:keypressed(key) then break end
		end
	end		

	function self.objectsLayer:keyreleased(key)
		for k,obj in pairs(self.objects) do
			if obj:keyreleased(key) then break end
		end
	end

end


function InGameState:draw()
	self.map:draw()
end

function InGameState:update(dt)
	self.map:callback("update", dt)

	for _,e in ipairs(self.addEntities) do
		table.insert(self.objectsLayer.objects, e)
	end

	self.addEntities = {}
end

function InGameState:keypressed(key)

	if key == keyconfig.reset then
		self:resetMap()
	end

	if key == "f11" then
		gameManager:nextMap()
	end

	self.map:callback("keypressed", key)
end

function InGameState:keyreleased(key)
	self.map:callback("keyreleased",key)
end


function InGameState:resetMap()
	gameStateManager:changeState(InGameState, self.mapFile)
end
