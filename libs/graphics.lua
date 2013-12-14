-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

AbstractGraphics = class("AbstractGraphics")

function AbstractGraphics:initialize( )
	self.offset = {0, 0}
	self.scale = {1, 1}
	self.rotation = 0
end

function AbstractGraphics:draw(x, y)
	self:_draw(x, y, self.offset[1], self.offset[2], self.rotation, self.scale[1], self.scale[2])
end

function AbstractGraphics:_draw(x, y, ox, oy, r, sx, sy)
	assert(false)
end

function AbstractGraphics:update(dt)
end

Graphics = AbstractGraphics:subclass("Graphics")

function Graphics:initialize(file)
	AbstractGraphics.initialize(self)

	self.graphics = love.graphics.newImage(file)
end 

function Graphics:_draw(x, y, ox, oy, r, sx, sy)
	love.graphics.draw( self.graphics, x, y, r, sx, sy, ox, oy)

	utils.withColor({255, 0, 0, 255}, function()
		love.graphics.rectangle("fill", x, y, 1, 1)
	end)
end

