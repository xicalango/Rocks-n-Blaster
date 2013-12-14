-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Bomb = Entity:subclass("Bomb")

function Bomb:initialize(x, y, player)
	Entity.initialize(self, x, y)

	self.graphics = Graphics:new("assets/bomb.png")
	self.graphics.offset = {8, 8}

	self.hitbox.left = 7
	self.hitbox.top = 7
	self.hitbox.bottom = 7
	self.hitbox.right = 7

	self.byPlayer = player

	self.obstacle = false
end

function Bomb:activate()

	self:timer("explode", 2, function(b)
			b:explode()
		end)

end

function Bomb:explode()
	gameManager:explode(self.x, self.y, 1)
	self.remove = true
end



