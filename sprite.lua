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
		local filepaths=love.filesystem.getDirectoryItems(filepath)
		for i,imagepath in ipairs(filepaths) do
			r[i]=love.graphics.newImage(imagepath)
			r[i]:setFilter("nearest","nearest")
		end
		return r[1],r,xl/r:getWidth(),yl/r:getHeight()
	else
		r=love.graphics.newCanvas()
		r:setFilter("nearest","nearest")
		return r,{r},xl/r:getWidth(),yl/r:getHeight()
	end
end

return Sprite