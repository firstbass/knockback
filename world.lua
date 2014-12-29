--world.lua

local World={}
local mt={__index=World}
local Moveable=Moveable
local TEsound=TEsound
local love=love
local ipairs=ipairs

function World.loadFile(filepath)
	w,t,f={},true,false
	local file=love.filesystem.newFile(filepath)
	if assert(file:open("r"),filepath.." could not be opened.") then
		for line in file:lines() do
			if string.sub(line,1,1)=="~" then	-- a ~ means to load a Moveable object
				w[string.gsub(string.gsub(line,"=.+",""),"~","",1)]	--w[text before =]
					=assert(loadstring("return Moveable:new(w,"..	--=Moveable:new(w and everything after =)
					string.gsub(line,".+=","")..")")(),"could not load line: "..line.." in file "..filepath)	--return error if this fails
			else
				w[string.gsub(line,"=.+","")]=string.gsub(line,".+=","",1)	--w[text before =]=everything after =
			end
		end
	end
	local rw=w;w,t,f=nil,nil,nil
	setmetatable(rw,mt)
	return rw
end

function World:initializeCollisions()	--initializes the collision count tables, which determine which axis to correct in the event of a collision
	for i,ma in ipairs(self) do			
		for imi,imma in ipairs(self) do
			if type(imma)=="table" then
				ma.xcollisioncount[imma]=0
				ma.ycollisioncount[imma]=0
			end
		end
	end
end

function World:basicSprites(r,g,b)	--gives all the objects in the world basic rectangle sprites of a r,g,b color
	local fill="fill"
	love.graphics.setColor(r or 0,g or 0,b or 0)
	for i,ma in ipairs(self) do
		if ma.sprite:typeOf("Canvas") then
			love.graphics.setCanvas(ma.sprite)
			love.graphics.rectangle(fill,0,0,ma.xl,ma.yl)
	end	end
	love.graphics.setCanvas()
end

function World:playMusic() TEsound.playLooping(self.music,"world") end
function World:pauseMusic() TEsound.pause("world") end
function World:resumeMusic() TEsound.resume("world") end

return World