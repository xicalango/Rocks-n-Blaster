-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Entity = class("Entity")

function Entity:initialize( x, y)
	x = x or 0
	y = y or 0

	self.x = x
	self.y = y

	self.gravityAffected = false

	self.vx = 0
	self.vy = 0

	self.speed = 1

	self.graphics = nil

	self.hitbox = { left = 0, top = 0, bottom = 0, right = 0}

	self.timers = {}

	self.remove = false

	self.obstacle = true

end

function Entity:keypressed(key)
	return false
end

function Entity:keyreleased(key)
	return false
end

function Entity:timer(name, waitSecs, callback)

	self.timers[name] = {
		name = name,
		t = waitSecs,
		callback = callback
	}

end

function Entity:collides( x, y )
	return x >= self.x - self.hitbox.left and x <= self.x + self.hitbox.right and y >= self.y - self.hitbox.top and y <= self.y + self.hitbox.bottom
end

function Entity:collidesWith(entity)

	local or1x, or1y, or2x, or2y = self:getHitRectangle()
	local er1x, er1y, er2x, er2y = entity:getHitRectangle()

	function intersectRect( r1x1, r1y1, r1x2, r1y2, r2x1, r2y1, r2x2, r2y2 )
 	 	return not ( 
			r1x2 < r2x1 or 
			r2x2 < r1x1 or
			r2y1 > r1y2 or
			r1y1 > r2y2)
	end

	return intersectRect( or1x, or1y, or2x, or2y, er1x, er1y, er2x, er2y )

end


function Entity:removeTimer(name)
	self.timers[name] = nil
end

function Entity:draw()
	if self.graphics then
		self.graphics:draw(self.x, self.y)
	end

	utils.withColor({255,0,0,255}, function()
		love.graphics.rectangle( "line", self.x - self.hitbox.left, self.y - self.hitbox.top, self.hitbox.left + self.hitbox.right, self.hitbox.top + self.hitbox.bottom )
		end)
end

function Entity:stop()
	self.vy = 0
	self.vx = 0
end

function Entity:getHitRectangle()
	return 
		self.x - self.hitbox.left, 
		self.y - self.hitbox.top, 
		self.x + self.hitbox.right, 
		self.y + self.hitbox.bottom
end


function Entity:update(dt)

	for k,timer in pairs(self.timers) do
		timer.t = timer.t - dt

		if timer.t <= 0 then
			timer.t = timer.callback(self)
		end

		if timer.t == nil or timer.t < 0 then
			self.timers[k] = nil
		end
	end

	if self.gravityAffected then
		if not gameManager:isObstacleInDir(self, 0, 1) then
			self.vy = self.vy + gameManager:getGravity()
		end
	end

	local oldX = self.x
	local oldY = self.y

	local newX = self.x + (self.vx * self.speed * dt)
	local newY = self.y + (self.vy * self.speed * dt)

	self.x = newX
	self.y = newY


	if gameManager:isObstacleForEntity(self) then
		self.x = oldX
		
		if gameManager:isObstacleForEntity(self) then
			self.x = newX
			self.y = oldY

			if gameManager:isObstacleForEntity(self) then
				self.x = oldX
				self:stop()
			end

		end
		


	end


end
