--[[conf.lua
Copyright 2014 Ian DeWalt]]

function love.conf(t)
	t.identity="./"
	t.version="0.9.1"
	
	t.window.title="côbalt"
	t.window.width=512
	t.window.height=512
	
	t.modules.joystick=false
	t.modules.physics=false
end
