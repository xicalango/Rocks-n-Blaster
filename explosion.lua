-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Explosion = Entity:subclass("Explosion")

function Explosion:initialize(x, y)
	Entity.initialize(self, x, y)

	self.graphics = Graphics:new("assets/explosion.png")
	self.graphics.offset = {8, 8}

	self.obstacle = false
	self.blastable = false

	self:activate()
end

function Explosion:activate()

	self:timer("decay", .5, function(b)
			b:decay()
		end)

end

function Explosion:decay()
	self.remove = true
end



