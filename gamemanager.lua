-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

GameManager = class("GameManager")


function GameManager:initialize(map)
	self.map = map
end

function GameManager:isObstacleForEntity(entity)

	local r1x, r1y, r2x, r2y = entity:getHitRectangle()

	if 	gameManager:isObstacle( gameManager:toMapXY(r1x, r1y) )
		or gameManager:isObstacle( gameManager:toMapXY(r1x, r2y) )
		or gameManager:isObstacle( gameManager:toMapXY(r2x, r2y) )
		or gameManager:isObstacle( gameManager:toMapXY(r2x, r1y) ) then
		return true
	end

	for k, e2 in pairs(self.map("Objects").objects) do

		if not entity.remove and entity ~= e2 and e2.obstacle then

			if entity:collidesWith(e2) then
				return true
			end

		end

	end

	return false

end

function GameManager:isObstacle(mapX, mapY, excludeEntity)
	return self.map("Ground")(mapX,mapY).properties.obstacle == 1 
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

	return self:isObstacle(mapX + dx, mapY + dy)
end

function GameManager:getGravity()
	return self.map.properties.gravity
end

function GameManager:explode(x, y, size)

end
