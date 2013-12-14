-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Player = Entity:subclass("Player")

function Player:initialize(x, y, number)
	Entity.initialize(self, x, y)

	self.graphics = Graphics:new("assets/player.png")
	self.graphics.offset = {8, 8}

	self.number = number

	self.hitbox.left = 6
	self.hitbox.top = 6
	self.hitbox.bottom = 6
	self.hitbox.right = 6

	self.speedX = 15*16
	self.speedY = 15*16
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

	if key == keyconfig.player[self.number].bomb then
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