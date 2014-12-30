require "TEsound"			local TEsound=TEsound
Moveable=require "moveable"	local Moveable=Moveable
World=require "world"		local World=World
local love=love
local ipairs=ipairs

local world,keys
local pausedtime,start
local debug,paused
local oxygenmono,dayposterblack

local function round(num) return math.floor(num+0.5) end

local function playtime() return math.floor(love.timer.getTime()-pausedtime-start) end

function love.load()
	keys=World.loadFile("resources/worlds/keybindings")
	debug,paused=false,false
	pausedtime,start=0,love.timer.getTime()
	
	math.randomseed(os.time())
	
	world=World.loadFile("resources/worlds/testworld")
	world:initializeCollisions()
	world.player:setWorldFollowing(true)
	world.threshold=world.threshold+0
	
	love.graphics.setBackgroundColor(255,255,255)
	oxygenmono,dayposterblack=love.graphics.newFont("resources/fonts/oxygenmono.otf"),
		love.graphics.newFont("resources/fonts/dayposterblack.ttf",60)
end

function love.update(dt)
	world:update(dt)
	TEsound.cleanup()
end

local function pausedupdate(dt) pausedtime=pausedtime+dt end

function love.draw()
	world:draw()
	
	if debug then
		love.graphics.setColor(0,0,0)	love.graphics.setFont(oxygenmono)
		love.graphics.print(
			"world name: "..world.name..
			"\nx: "..round(world.player.x)..", y: "..round(world.player.y)..", ia: "..world.player.ia..
			"\ntx: "..round(world.tx)..", ty: "..round(world.ty)..
			"\nfps: "..love.timer.getFPS()..", debug: "..tostring(debug)..", paused: "..tostring(paused)..
			"\nplaytime: "..playtime().." seconds",10,10)
	end
end

local function pauseddraw()
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(oxygenmono)
	love.graphics.print("playtime: "..playtime().." seconds",10,10)
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
        		world.pauseMusic()
        	else world.resumeMusic() end
	elseif key==keys.quit then
		love.event.push("quit")
	end
end

function love.keyreleased(key)
	if key==keys.up then
		world.player.ay=0
	elseif key==keys.down then
		world.player.ay=0
	elseif key==keys.left then
		world.player.ax=0
	elseif key==keys.right then
		world.player.ax=0
	end
end