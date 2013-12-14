-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

Mob = Entity:subclass("Mob")

function Mob:initialize(x, y, dir, speed)
	Entity.initialize(self, x, y)

	dir = dir or 0
	speed = speed or 7*16

	self.graphics = Graphics:new("assets/mob.png")
	self.graphics.offset = {8, 8}

	self.number = number

	self.hitbox.left = 7
	self.hitbox.top = 7
	self.hitbox.bottom = 7
	self.hitbox.right = 7

	self.speedX = speed
	self.speedY = speed

	self.dir = dir
end

function Mob:update(dt)

	if self.dir == 0 then
		self.vx = 1
		self.vy = 0
	elseif self.dir == 1 then
		self.vx = 0
		self.vy = 1
	elseif self.dir == 2 then
		self.vx = -1
		self.vy = 0
	elseif self.dir == 3 then
		self.vx = 0
		self.vy = -1
	end

	Entity.update(self,dt)

end

function Mob:onCollide(e)

	if e~= nil then
		e:onMobCollide(self)
		return
	end

	self:rasterize()

	self.dir = (self.dir + 1) % 4
end

function Mob:onExplode()
	self.remove = true
end
