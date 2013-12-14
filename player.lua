-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Player = Entity:subclass("Player")

function Player:initialize(map, x, y, number)
	Entity.initialize(self, map, x, y)

	self.graphics = Graphics:new("assets/player.png")
	self.graphics.offset = {8, 8}

	self.number = number

	self.speed = 15*16
end


function Player:keypressed( key )
	if key == keyconfig.player[self.number].up then 
		self.vy = -1
	end
	if key == keyconfig.player[self.number].down then 
		self.vy = 1
	end
	if key == keyconfig.player[self.number].left then 
		self.vx = -1
	end
	if key == keyconfig.player[self.number].right then 
		self.vx = 1
	end

end

function Player:keyreleased( key )
	if key == keyconfig.player[self.number].up then 
		self.vy = 0
	end
	if key == keyconfig.player[self.number].down then 
		self.vy = 0
	end
	if key == keyconfig.player[self.number].left then 
		self.vx = 0
	end
	if key == keyconfig.player[self.number].right then 
		self.vx = 0
	end

end
