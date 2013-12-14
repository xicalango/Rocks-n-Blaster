-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Entity = class("Entity")

function Entity:initialize(map, x, y)
	x = x or 0
	y = y or 0

	self.map = map

	self.x = x
	self.y = y

	self.vx = 0
	self.vy = 0

	self.speed = 1

	self.graphics = nil

	self.hitbox = { left = 0, top = 0, bottom = 0, right = 0}

end

function Entity:keypressed(key)
end

function Entity:keyreleased(key)
end

function Entity:draw()
	if self.graphics then
		self.graphics:draw(self.x, self.y)
	end

	utils.withColor({255,0,0,255}, function()
		love.graphics.rectangle( "line", self.x - self.hitbox.left, self.y - self.hitbox.top, self.hitbox.left + self.hitbox.right, self.hitbox.top + self.hitbox.bottom )
		end)
end


function Entity:update(dt)

	local newX = self.x + (self.vx * self.speed * dt)
	local newY = self.y + (self.vy * self.speed * dt)


	local newXMap = math.floor(newX / self.map.tileWidth)
	local newYMap = math.floor(newY / self.map.tileHeight)

	if self.map("Ground")(newXMap,newYMap).properties["obstacle"] == 0 then
		self.x = newX
		self.y = newY
	end


end