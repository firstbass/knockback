--moveable.lua

local Moveable={}
local mt={__index=Moveable}
local love=love

function Moveable:new(world,spritepath,mc,mm,mx,my,mxl,myl,mvx,mvy,max,may)
	local sprite=assert(love.graphics.newImage(spritepath),spritepath.." is not a valid image")	--tries to load the image; this is the problem line
	local mc,mm,mx,my,mxl,myl,mvx,mvy,max,may
		=mc or false,mm or false,mx or 0,my or 0,mxl or 1,myl or 1,mvx or 0,mvy or 0,max or 0,may or 0
	local m={collidable=mc,moveable=mm,x=mx,y=my,cx=mcx,cy=mcy,xl=mxl,yl=myl,vx=mvx,vy=mvy,ax=max,ay=may,
		world=world,xcollisioncount={},ycollisioncount={},sprite=love.graphics.newCanvas()}
	setmetatable(m,mt)
	world[#world+1]=m	--inserts the moveable into a new index in the world
	return m
end

function Moveable:update(dt)
	if self.moveable then
		self.vx=(self.vx+self.ax)*self.world.f
		self.vy=(self.vy+self.ay)*self.world.f	--(velocity+acceleration)*friction
		self.x=self.x+self.vx
		self.y=self.y+self.vy					--position+velocity

		for i,ma in ipairs(self.world) do		--check object with all other objects in its world
			if self~=ma and self.vx and self.vy then	--only if it's moving
				local xcollision,ycollision=self:collidesWith(ma)	--checks basic axis collisions
				if self.xcollisioncount[ma]<2 and xcollision then self.xcollisioncount[ma]=self.xcollisioncount[ma]+1
					elseif not xcollision then self.xcollisioncount[ma]=0 end
				if self.ycollisioncount[ma]<2 and ycollision then self.ycollisioncount[ma]=self.ycollisioncount[ma]+1
					elseif not ycollision then self.ycollisioncount[ma]=0 end	--determines which axis has been colliding for longer
				if xcollision and ycollision
					then self:correctCollision(ma)	--corrects them if the objects have collided
				end
			end
		end
	end
end

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

function Moveable:overlapYWith(ma) return self.x+self.xl-ma.x end	--returns the overlap with other moveables

function Moveable:correctCollision(ma)
	if self.xcollisioncount[ma]<=self.ycollisioncount[ma] then self:correctXCollision(ma)
	elseif self.ycollisioncount[ma]<self.xcollisioncount[ma] then self:correctYCollision(ma)
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