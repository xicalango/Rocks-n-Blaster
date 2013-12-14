-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Rock = Entity:subclass("Rock")

function Rock:initialize( x, y)
	Entity.initialize(self,  x, y)

	self.graphics = Graphics:new("assets/rock.png")
	self.graphics.offset = {8, 8}

	self.gravityAffected = true

	self.hitbox.left = 7
	self.hitbox.top = 7
	self.hitbox.bottom = 7
	self.hitbox.right = 7

end
