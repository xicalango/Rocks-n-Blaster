-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Player = Entity:subclass("Player")

function Player:initialize(x, y, number)
	Entity.initialize(self, x, y)

	self.graphics = Graphics:new("assets/player.png")
	self.graphics.offset = {8, 8}

	self.number = number or 0

	self.hitbox.left = 4
	self.hitbox.top = 4
	self.hitbox.bottom = 4
	self.hitbox.right = 4

	self.speedX = 15*16
	self.speedY = 15*16

	self.hasBomb = true

end


function Player:keypressed( key )
	if key == keyconfig.player[self.number].up then 
		self.vy = -1
		return true
	end
	if key == keyconfig.player[self.number].down then 
		self.vy = 1
		return true
	end
	if key == keyconfig.player[self.number].left then 
		self.vx = -1
		return true
	end
	if key == keyconfig.player[self.number].right then 
		self.vx = 1
		return true
	end

	if key == keyconfig.player[self.number].bomb and self.hasBomb then
		self.hasBomb = false
		gameManager:placeBomb(self.x ,self.y)
	end

	return false
end

function Player:keyreleased( key )
	if key == keyconfig.player[self.number].up then 
		self.vy = 0
		return true
	end
	if key == keyconfig.player[self.number].down then 
		self.vy = 0
		return true
	end
	if key == keyconfig.player[self.number].left then 
		self.vx = 0
		return true
	end
	if key == keyconfig.player[self.number].right then 
		self.vx = 0
		return true
	end


	return false
end

function Player:onCollide(e)
	if e ~= nil and e.pushable then
		e.dX = self.vx * 16
	end
end

function Player:update(dt)

	Entity.update(self,dt)

	if gameManager:isEntityOnExit(self) then
		nextLevelSound:play()
		gameManager:nextMap()
	end

end

function Player:onExplode()
	hurtSound:play()
	gameManager:resetMap()
end

function Player:onMobCollide(mob)
	hurtSound:play()
	gameManager:resetMap()
end
