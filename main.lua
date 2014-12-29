require "TEsound"			local TEsound=TEsound
Moveable=require "moveable"	local Moveable=Moveable
World=require "world"		local World=World
local love=love
local ipairs=ipairs

local world
local keys,debug,paused
local playtime,start
local oxygenmono,dayposterblack
local threshold=64				--threshold for when to begin scrolling the screen.

local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function love.load()
	keys=World.loadFile("resources/worlds/keybindings")
	debug,paused=false,false
	playtime,start=0,love.timer.getTime()
	
	math.randomseed(os.time())
	
	world=World.loadFile("resources/worlds/testworld")
	world:initializeCollisions()
	world:basicSprites(160,160,160)
	if world.music then world:playMusic() end
	
	love.graphics.setBackgroundColor(255,255,255)
	oxygenmono,dayposterblack=love.graphics.newFont("resources/fonts/oxygenmono.otf"),
		love.graphics.newFont("resources/fonts/dayposterblack.ttf",60)
end

function love.update(dt)
	for i,ma in ipairs(world) do
		ma:update(dt)
	end
	
	--[[if world.player.y>=love.window.getHeight()-threshold then
		world.ty=world.ty+.01*threshold
	elseif world.player.y<=threshold then
		world.ty=world.ty-.01*threshold
	end				--this is to try to scroll the screen. isn't working quite yet.]]
	playtime=math.floor(love.timer.getTime()-start)
	TEsound.cleanup()
end

function pausedupdate() end

function love.draw()
	love.graphics.translate(world.tx,world.ty)
	love.graphics.setColor(255,255,255)
	for i,ma in ipairs(world) do
		ma:draw()
	end
	if debug then
		love.graphics.translate(-world.tx,-world.ty)
		love.graphics.setColor(0,0,0)	love.graphics.setFont(oxygenmono)
		love.graphics.print(
			"world name: "..world.name..
			"\nx: "..round(world.player.x)..", y: "..round(world.player.y)..
			"\nfps: "..love.timer.getFPS()..
			"\nplaytime: "..playtime.." seconds",10,10)
	end
end

function pauseddraw()
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(oxygenmono)
	love.graphics.print("playtime: "..playtime.." seconds",10,10)
	love.graphics.setFont(dayposterblack)
	love.graphics.printf("GAME PAUSED",0,200,512,"center")
end

function love.keypressed(key)
	if key==keys.up then
		world.player.ay=world.player.ay-world.a
	elseif key==keys.down then
		world.player.ay=world.player.ay+world.a
	elseif key==keys.left then
		world.player.ax=world.player.ax-world.a
	elseif key==keys.right then
		world.player.ax=world.player.ax+world.a
	elseif key==keys.debug then
		debug=not debug
	elseif key==keys.pause then
		paused=not paused
		love.update,pausedupdate=pausedupdate,love.update
		love.draw,pauseddraw=pauseddraw,love.draw
        		if paused and world.music then
        			world.pauseMusic() else world.resumeMusic()
        		end
	elseif key==keys.quit then
		love.event.push("quit")
	end
end

function love.keyreleased(key)
	if key==keys.up then
		world.player.ay=world.g
	elseif key==keys.down then
		world.player.ay=world.g
	elseif key==keys.left then
		world.player.ax=0
	elseif key==keys.right then
		world.player.ax=0
	end
end
