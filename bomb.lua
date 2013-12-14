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

	self.explodeTime = 1.5

end

function Bomb:activate()

	self:timer("explode", self.explodeTime, function(b)
			b:explode()
		end)

end

function Bomb:explode()
	if self.remove then return end

	gameManager:explode(self.x, self.y, 1)
	self.remove = true
end


function Bomb:onExplode()
	self.remove = true
	self:explode()
end

function Bomb:draw()

	local color = 255

	if self.timers["explode"].t then
		color = ( ( self.timers["explode"].t / self.explodeTime ) * 255 )
	end


	utils.withColor({color,color,color,255}, function() 
			Entity.draw(self)
		end)
end