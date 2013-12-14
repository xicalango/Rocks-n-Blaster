-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

GameManager = class("GameManager")


function GameManager:initialize(map, addEntityCallback)
	self.map = map
	self.addEntityCallback = addEntityCallback

	self.tiles = {}

	for id, tile in pairs(self.map.tiles) do
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

	for k, e2 in pairs(self.map("Objects").objects) do

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

	for k, e in pairs(self.map("Objects").objects) do

		local emx, emy = self:toMapXY(e.x, e.y)

		if emx == mapX and emy == mapY then
			table.insert(result, e)
		end

	end

	return result

end

function GameManager:isObstacle(mapX, mapY)
	return self.map("Ground")(mapX,mapY).properties.obstacle == 1 
end

function GameManager:isBlastable(mapX, mapY)
	return self.map("Ground")(mapX,mapY).properties.blastable == 1 
end


function GameManager:toMapXY(x, y)
	return math.floor(x / self.map.tileWidth) , math.floor(y / self.map.tileHeight)
end

function GameManager:toEntityXY(mapX, mapY, ox, oy)
	ox = ox or 0
	oy = oy or ox

	return (mapX * self.map.tileWidth) + ox, (mapY * self.map.tileHeight) + oy
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
	return self.map.properties.gravity
end

function GameManager:blastTile(mapX, mapY)

	local tile = self.map("Ground")(mapX,mapY)

	if tile.properties.blastable == 0 then
		return
	end

	self.map("Ground"):set(mapX, mapY, self.tiles[tile.properties.blastTo])

	self.map:forceRedraw()

end

function GameManager:explode(x, y, size)

	local mX, mY = self:toMapXY(x,y)

	local positions = { {mX, mY} }

	for i = 0, size do

		if self:isBlastable( mX + i, mY) or not self:isObstacle( mX + i, mY ) then
			table.insert(positions, {mX + i , mY})
		end

		if self:isBlastable( mX - i, mY) or not self:isObstacle( mX - i, mY ) then
			table.insert(positions, {mX - i, mY})
		end

		if self:isBlastable( mX, mY + i) or not self:isObstacle( mX , mY + i) then
			table.insert(positions, {mX  , mY + i})
		end

		if self:isBlastable( mX, mY - i) or not self:isObstacle( mX, mY - i) then
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

		self.addEntityCallback( Explosion:new(self:toEntityXY(pos[1],pos[2], 8, 8)) )

	end



end

function GameManager:placeBomb(x, y)

	local mX, mY = self:toMapXY(x, y)
	local eX, eY = self:toEntityXY(mX, mY, 8, 8)

	local bomb = Bomb:new(eX, eY)

	bomb:activate()

	self.addEntityCallback(bomb)

end
