--robots.lua
local robots={}
local love=love
function loadsprites()
local d="resources/sprites/robots/"
robots["left"]={}
robots["left"][1]=love.graphics.newImage(d.."left1.png")
robots["left"][2]=love.graphics.newImage(d.."left2.png")
robots["left"][3]=love.graphics.newImage(d.."left3.png")
robots["left"][4]=love.graphics.newImage(d.."left4.png")
robots["right"]={}
robots["right"][1]=love.graphics.newImage(d.."right1.png")
robots["right"][2]=love.graphics.newImage(d.."right2.png")
robots["right"][3]=love.graphics.newImage(d.."right3.png")
robots["right"][4]=love.graphics.newImage(d.."right4.png")
robots["up"]={}
robots["up"][1]=love.graphics.newImage(d.."up1.png")
robots["up"][2]=love.graphics.newImage(d.."up2.png")
robots["up"][3]=love.graphics.newImage(d.."up3.png")
robots["up"][4]=love.graphics.newImage(d.."up4.png")
robots["down"]={}
robots["down"][1]=love.graphics.newImage(d.."down1.png")
robots["down"][2]=love.graphics.newImage(d.."down2.png")
robots["down"][3]=love.graphics.newImage(d.."down3.png")
robots["down"][4]=love.graphics.newImage(d.."down4.png")
end

function getsprites()
	return robots
end