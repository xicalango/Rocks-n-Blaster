-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>




InGameState = GameState:subclass("InGameState")

function InGameState:initialize()
	self.addEntities = {}
end

function InGameState:onActivation(map, mapFile)

	self.mapFile = mapFile

	self.map = map
	gameManager = GameManager:new(self)
end

function InGameState:addEntity(e)
	table.insert(self.addEntities, e)
end



function InGameState:draw()

	local tx = 160 - (self.map.width * self.map.tileWidth)/2
	local ty = 120 - (self.map.height * self.map.tileHeight)/2

	love.graphics.translate(tx, ty)

	self.map:autoDrawRange(tx, ty)

	self.map:draw()
end

function InGameState:update(dt)
	self.map:callback("update", dt)

	for _,e in ipairs(self.addEntities) do
		table.insert(self.map("Objects").objects, e)
	end

	self.addEntities = {}
end

function InGameState:keypressed(key)

	if key == keyconfig.reset then
		gameManager:resetMap()
	elseif key == "f11" then
		gameManager:nextMap()
	elseif key == "escape" then
		gameStateManager:changeState(MainMenuState, self.mapFile)
	end

	self.map:callback("keypressed", key)
end

function InGameState:keyreleased(key)
	self.map:callback("keyreleased",key)
end



