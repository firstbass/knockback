local World={}
local Moveable=Moveable
local TEsound=TEsound
local love=love
local ipairs=ipairs

function World.loadFile(filepath)
	w,t,f={},true,false
	w.tx,w.ty=0,0
	local file=love.filesystem.newFile(filepath)
	if assert(file:open("r"),filepath.." could not be opened.") then
		for line in file:lines() do
			local index=string.gsub(line,"=.+","")		--text before =
			local arguments=string.gsub(line,".+=","")	--text after =
			if string.sub(line,1,2)=="--" then
				--do nothing
			elseif string.sub(line,1,1)=="~" then		-- a ~ means to load a Moveable object
				index=string.gsub(index,"~","",1)		--index without ~
				w[index]=assert(loadstring("return Moveable.new(w,"..arguments..")")(),"could not load line: "..line.." in file "..filepath)
			else
				w[index]=arguments	--w[text before =] = everything after =
			end
		end
	end
	local rw=w;w,t,f=nil,nil,nil
	setmetatable(rw,{__index=World})
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
	love.graphics.setColor(r or 0,g or 0,b or 0)	--default values if r,g,b values aren't provided
	for i,ma in ipairs(self) do
		if ma.sprite and ma.sprite:typeOf("Canvas") then
			love.graphics.setCanvas(ma.sprite)
			love.graphics.rectangle("fill",0,0,ma.xl,ma.yl)
		end
	end
	love.graphics.setCanvas()
end

function World:update(dt)
	for i,ma in ipairs(self) do
		ma:update(dt)
	end
end

function World:playMusic() TEsound.playLooping(self.music,"world") end
function World:pauseMusic() TEsound.pause("world") end
function World:resumeMusic() TEsound.resume("world") end

return World