-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Message = Entity:subclass("Message")

function Message:initialize(x, y, message)
	Entity.initialize(self,  x, y)

	self.graphics = TextGraphics:new(message)
	self.graphics.offset = {0, 0}

	self.gravityAffected = false
	self.obstacle = false
	self.blastable = false


end
