-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

local ATL = require("libs/AdvTiledLoader")


InGameState = GameState:subclass("InGameState")

function InGameState:initialize()
	ATL.Loader.path = "maps/"
end

function InGameState:onActivation(map)

	self:_loadMap(map)	

end

function InGameState:_loadMap(map)
	self.map = ATL.Loader.load(map)


	self.objectsLayer = self.map("Objects")

	local function convertObjects(objectDef)
		return Player:new(self.map, objectDef.x + 8, objectDef.y + 8, objectDef.properties.number)
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
		end
	end

	function self.objectsLayer:keypressed(key)
		for k,obj in pairs(self.objects) do
			obj:keypressed(key)
		end
	end		

	function self.objectsLayer:keyreleased(key)
		for k,obj in pairs(self.objects) do
			obj:keyreleased(key)
		end
	end

end


function InGameState:draw()
	self.map:draw()
end

function InGameState:update(dt)
	self.map:callback("update", dt)
end

function InGameState:keypressed(...)
	self.map:callback("keypressed", ...)
end

function InGameState:keyreleased(key)
	self.map:callback("keyreleased",key)
end


