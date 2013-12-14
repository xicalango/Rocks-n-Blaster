-- Rocks-n-Blaster -- #LD48 -- by <weldale@gmail.com>

local utils = {}

function utils.withColor(rgba, fn)

	local currentColor = {love.graphics.getColor()}

	love.graphics.setColor(rgba)
	fn()
	love.graphics.setColor(currentColor)

end


return utils