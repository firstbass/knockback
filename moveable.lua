--moveable.lua

local Moveable={}
local mt={__index=Moveable}
local love=love

function Moveable:new(world,spritepath,mc,mm,mx,my,mxl,myl,mvx,mvy,max,may)
	--[[loadstring(spritepath)()
	loadsprites()
	local spritefield=getsprites()]]
	mc,mm,mx,my,mxl,myl,mvx,mvy,max,may
		=mc or false,mm or false,mx or 0,my or 0,mxl or 1,myl or 1,mvx or 0,mvy or 0,max or 0,may or 0
	local m={collidable=mc,moveable=mm,x=mx,y=my,cx=mcx,cy=mcy,xl=mxl,yl=myl,vx=mvx,vy=mvy,ax=max,ay=may,
		world=world,worldxcount={},worldycount={},sprite=love.graphics.newCanvas()}
	setmetatable(m,mt)
	world[#world+1]=m
	return m
end

function Moveable:update(dt)
	if self.moveable then
		self.vx=(self.vx+self.ax)*self.world.f
		self.vy=(self.vy+self.ay)*self.world.f
		self.x=self.x+self.vx
		self.y=self.y+self.vy

		for i,ma in ipairs(self.world) do
			if self~=ma and self.vx and self.vy then
				local xcollision,ycollision=self:collidesWith(ma)
				if self.worldxcount[ma]<2 and xcollision then self.worldxcount[ma]=self.worldxcount[ma]+1
					elseif not xcollision then self.worldxcount[ma]=0 end
				if self.worldycount[ma]<2 and ycollision then self.worldycount[ma]=self.worldycount[ma]+1
					elseif not ycollision then self.worldycount[ma]=0 end
				if xcollision and ycollision then self:correctCollision(ma)
end	end	end	end	end

function Moveable:collidesWith(ma)
	local xcollision,ycollision=self:collidesXWith(ma),self:collidesYWith(ma)
	return xcollision,ycollision,xcollision and ycollision
end

function Moveable:collidesXWith(ma)
	return self.collidable and ma.collidable and self.y<ma.y+ma.yl and self.y+self.yl>ma.y
end

function Moveable:collidesYWith(ma)
	return self.collidable and ma.collidable and self.x<ma.x+ma.xl and self.x+self.xl>ma.x
end

function Moveable:overlapXWith(ma) return self.y+self.yl-ma.y end

function Moveable:overlapYWith(ma) return self.x+self.xl-ma.x end

function Moveable:correctCollision(ma)
	if self.worldxcount[ma]<=self.worldycount[ma] then self:correctXCollision(ma)
	elseif self.worldycount[ma]<self.worldxcount[ma] then self:correctYCollision(ma)
end	end

function Moveable:correctXCollision(ma)
	local overlap=self:overlapXWith(ma)
	if overlap>ma.yl then overlap=overlap-ma.yl-self.yl end
	self.y=self.y-overlap
	self.vy=0
	self.worldxcount[ma]=0
end

function Moveable:correctYCollision(ma)
	local overlap=self:overlapYWith(ma)
	if overlap>ma.xl then overlap=overlap-ma.xl-self.xl end
	self.x=self.x-overlap
	self.vx=0
	self.worldycount[ma]=0
end

return Moveable
