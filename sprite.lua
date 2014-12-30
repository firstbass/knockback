local Sprite={}
local love=love
local ipairs=ipairs

function Sprite.newSpriteField(filepath,xl,yl)
	local r
	if filepath and love.filesystem.isFile(filepath) then
		r=love.graphics.newImage(filepath)
		r:setFilter("nearest","nearest")
		return r,{[1]=r},xl/r:getWidth(),yl/r:getHeight()
	elseif filepath and love.filesystem.isDirectory(filepath) then
		r={}
		love.filesystem.getDirectoryItems(filepath,
			function(filename)
				local i=love.graphics.newImage("resources/sprites/robots/"..filename)
				i:setFilter("nearest","nearest")
				table.insert(r,i) end)
		return r[1],r,xl/r:getWidth(),yl/r:getHeight()
	else
		r=love.graphics.newCanvas()
		r:setFilter("nearest","nearest")
		return r,{r},xl/r:getWidth(),yl/r:getHeight()
	end
end

return Sprite