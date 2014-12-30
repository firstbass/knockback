local Moveable={}
local Sprite=require "sprite"
local love=love
local ipairs=ipairs

function Moveable.new(world,spritepath,mc,mm,mx,my,mxl,myl,mvx,mvy,max,may)
	local sprite,sprites,mxscl,myscl=Sprite.newSpriteField(spritepath,mxl,myl)
	
	local mc,mm,mx,my,mxl,myl,mxscl,myscl,mvx,mvy,max,may
		=mc or false,mm or false,mx or 0,my or 0,mxl or 1,myl or 1,mxscl or 1,myscl or 1,mvx or 0,mvy or 0,max or 0,may or 0	--default values
	local m={collidable=mc,moveable=mm,x=mx,y=my,cx=mcx,cy=mcy,xl=mxl,yl=myl,xscl=mxscl,yscl=myscl,vx=mvx,vy=mvy,ax=max,ay=may,
		world=world,following=false,xcollisioncount={},ycollisioncount={},sprite=sprite,sprites=sprites}
	setmetatable(m,{__index=Moveable})
		--[[If something doesn't exist in the created Moveable object, it refers back to the Moveable table, due to this metatable.
		This is essentially how all class inheritance in Lua works/is implemented. Metatables are weird but handy.]]
	world[#world+1]=m	--inserts the moveable into a new index in the world
	return m
end

function Moveable:setWorldFollowing(following)
	self.following=following
end

function Moveable:update(dt)
	if self.moveable then
		self.vx=(self.vx+self.ax)*self.world.f
		self.vy=(self.vy+self.ay)*self.world.f	--(velocity+acceleration)*friction
		self.x=self.x+self.vx
		self.y=self.y+self.vy					--position+velocity
		if self.following then
			if self.y+self.yl+self.world.ty>=love.window.getHeight()-self.world.threshold and self.vy>0 then
				self.world.ty=-(self.y+self.yl+self.world.threshold-love.window.getHeight())
			elseif self.y+self.world.ty<=self.world.threshold and self.vy<0 then
				self.world.ty=-(self.y-self.world.threshold)
			end
	
			if self.x+self.xl+self.world.tx>=love.window.getWidth()-self.world.threshold and self.vx>0 then
				self.world.tx=-(self.x+self.xl+self.world.threshold-love.window.getWidth())
			elseif self.x+self.world.tx<=self.world.threshold and self.vx<0 then
				self.world.tx=-(self.x-self.world.threshold)
			end
		end
		
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

function Moveable:draw()
	love.graphics.draw(self.sprite,self.x,self.y,0,self.xscl,self.yscl)
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
	self.xcollisioncount[ma]=0
end

function Moveable:correctYCollision(ma)
	local overlap=self:overlapYWith(ma)
	if overlap>ma.xl then overlap=overlap-ma.xl-self.xl end
	self.x=self.x-overlap
	self.vx=0
	self.ycollisioncount[ma]=0
end

return Moveable