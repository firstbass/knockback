--trigger.lua

local Trigger={}
local mt={__index=Trigger}
local Moveable=Moveable
setmetatable(Trigger,{__index=Moveable})
