-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Rock = Entity:subclass("Rock")

function Rock:initialize(x, y)
	Entity.initialize(self,  x, y)

	self.graphics = Graphics:new("assets/rock.png")
	self.graphics.offset = {8, 8}

	self.gravityAffected = true

	self.hitbox.left = 6
	self.hitbox.top = 6
	self.hitbox.bottom = 6
	self.hitbox.right = 6

	self.dX = 0

	self.speedX = 16

	self.pushable = true

end

function Rock:push(dX)

	local oldX = self.x

	self.x = self.x + dX

	if not gameManager:isObstacleForEntity(self) then
		self.dX = dX
	end

	self.x = oldX


end

function Rock:update(dt)

	if self.dX < 0 then
		self.vx = -1
	elseif self.dX > 0 then
		self.vx = 1
	else
		self.vx = 0
	end

	local oldX = self.x

	Entity.update(self, dt)

	local dX = self.x - oldX

	self.dX = self.dX - dX

	if self.dX <= 0.001 then
		self.dX = 0
	end

end
