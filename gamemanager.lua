-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

GameManager = class("GameManager")


function GameManager:initialize(state)
	self.state = state

	self.tiles = {}

	for id, tile in pairs(self.state.map.tiles) do
		if tile.properties.name then
			self.tiles[tile.properties.name] = tile
		end
	end
end

function GameManager:isObstacleForEntity(entity)

	local r1x, r1y, r2x, r2y = entity:getHitRectangle()

	if 	gameManager:isObstacle( gameManager:toMapXY(r1x, r1y) )
		or gameManager:isObstacle( gameManager:toMapXY(r1x, r2y) )
		or gameManager:isObstacle( gameManager:toMapXY(r2x, r2y) )
		or gameManager:isObstacle( gameManager:toMapXY(r2x, r1y) ) then
		return true, nil
	end

	for k, e2 in pairs(self.state.map("Objects").objects) do

		if not entity.remove and entity ~= e2 and e2.obstacle then

			if entity:collidesWith(e2) then
				return true, e2
			end

		end

	end

	return false, nil

end

function GameManager:getObjectsOnMap(mapX, mapY)

	local result = {}

	for k, e in pairs(self.state.map("Objects").objects) do

		local emx, emy = self:toMapXY(e.x, e.y)

		if emx == mapX and emy == mapY then
			table.insert(result, e)
		end

	end

	return result

end

function GameManager:isOutOfMap(mapX, mapY)
	return mapX < 0 or mapY < 0 or mapX >= self.state.map.width or mapY >= self.state.map.height
end

function GameManager:isObstacle(mapX, mapY)
	if self:isOutOfMap(mapX, mapY) then return true end
	return self.state.map("Ground")(mapX,mapY).properties.obstacle == 1 
end

function GameManager:isBlastable(mapX, mapY, fromX, fromY)
	if self:isOutOfMap(mapX, mapY) then return false end

	local tile = self.state.map("Ground")(mapX,mapY)

	if tile.properties.blastable ~= 1 then
		return false
	end

	if tile.properties.blastFromDir ~= nil then

		if tile.properties.blastFromDir == "up" and fromY < mapY then return true end
		if tile.properties.blastFromDir == "down" and fromY > mapY then return true end
		if tile.properties.blastFromDir == "left" and fromX < mapX then return true end
		if tile.properties.blastFromDir == "right" and fromX > mapX then return true end

		return false

	else
		return true
	end

end


function GameManager:toMapXY(x, y)
	return math.floor(x / self.state.map.tileWidth) , math.floor(y / self.state.map.tileHeight)
end

function GameManager:toEntityXY(mapX, mapY, ox, oy)
	ox = ox or 0
	oy = oy or ox

	return (mapX * self.state.map.tileWidth) + ox, (mapY * self.state.map.tileHeight) + oy
end

function GameManager:isObstacleInDir(entity, dx, dy)
	dx = dx or 0
	dy = dy or 0

	local mapX, mapY = self:toMapXY(entity.x, entity.y)

	if self:isObstacle(mapX + dx, mapY + dy) then
		return true
	end

	for k, e2 in pairs(self:getObjectsOnMap(mapX + dx, mapY + dy)) do

		if not entity.remove and entity ~= e2 and e2.obstacle then
			return true
		end

	end

	return false
end

function GameManager:getGravity()
	return self.state.map.properties.gravity
end

function GameManager:blastTile(mapX, mapY)

	oldX = oldX or mapX
	oldY = oldY or mapY

	local tile = self.state.map("Ground")(mapX,mapY)

	if tile.properties.blastable == nil or tile.properties.blastable == 0 then
		return
	end

	self.state.map("Ground"):set(mapX, mapY, self.tiles[tile.properties.blastTo])

	if tile.properties.chainBlast == 1 then
		if self:isBlastable(mapX - 1, mapY, mapX, mapY) then self:blastTile(mapX - 1, mapY) end
		if self:isBlastable(mapX + 1, mapY, mapX, mapY) then self:blastTile(mapX + 1, mapY) end
		if self:isBlastable(mapX, mapY + 1, mapX, mapY) then self:blastTile(mapX, mapY + 1) end
		if self:isBlastable(mapX, mapY - 1, mapX, mapY) then self:blastTile(mapX, mapY - 1) end
	end

	self.state:addEntity( Explosion:new(self:toEntityXY(mapX, mapY, 8, 8)) )
	self.state.map:forceRedraw()


end

function GameManager:explode(x, y, size)

	local mX, mY = self:toMapXY(x,y)

	local positions = { {mX, mY} }

	for i = 1, size do

		if self:isBlastable( mX + i, mY, mX, mY) or not self:isObstacle( mX + i, mY ) then
			table.insert(positions, {mX + i , mY})
		end

		if self:isBlastable( mX - i, mY, mX, mY) or not self:isObstacle( mX - i, mY ) then
			table.insert(positions, {mX - i, mY})
		end

		if self:isBlastable( mX, mY + i, mX, mY) or not self:isObstacle( mX , mY + i) then
			table.insert(positions, {mX  , mY + i})
		end

		if self:isBlastable( mX, mY - i, mX, mY) or not self:isObstacle( mX, mY - i) then
			table.insert(positions, {mX, mY - i})
		end

	end


	for _,pos in ipairs(positions) do
		self:blastTile(pos[1], pos[2])

		local entities = self:getObjectsOnMap(pos[1], pos[2])

		for _,e in ipairs(entities) do
			if not e.remove and e.blastable then
				e:onExplode()
			end
		end

		self.state:addEntity( Explosion:new(self:toEntityXY(pos[1], pos[2], 8, 8)) )

	end



end

function GameManager:placeBomb(x, y)

	local mX, mY = self:toMapXY(x, y)
	local eX, eY = self:toEntityXY(mX, mY, 8, 8)

	local bomb = Bomb:new(eX, eY)

	bomb:activate()

	self.state:addEntity(bomb)

end

function GameManager:isEntityOnExit(entity)

	local mX, mY = self:toMapXY(entity.x, entity.y)

	return self.state.map("Ground")(mX,mY).properties.name == "Door"

end

function GameManager:nextMap()

	local nextMap = self.state.map.properties.nextMap

	if nextMap == nil or #nextMap == 0 then
		love.event.push('quit')
	else
		gameStateManager:changeState(MapChangeState, nextMap, self.state.map)
	end


end

function GameManager:resetMap()
	gameStateManager:changeState(MapChangeState, self.state.mapFile, self.state.map)
end