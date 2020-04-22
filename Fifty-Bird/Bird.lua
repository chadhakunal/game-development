Bird = Class{}

local JumpVelocity = 5

function Bird:init()
    self.image = love.graphics.newImage("Images/bird.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = GameWidth/2 - self.width/2
    self.y = GameHeight/2 - self.height/2

    self.dy = 0
end

function Bird:collides(pipe) 
    local leeway = 3
    if self.x+self.width-leeway >= pipe.x and self.x+leeway <= pipe.x+PipeWidth then
        if self.y+self.height-leeway >= pipe.y and self.y+leeway <= pipe.y then
            return true 
        end
    end
    return false
end

function Bird:update(dt)
    self.dy = self.dy + Gravity*dt
    if love.keyboard.keyPressed['space'] then
        self.dy = -JumpVelocity
        sounds["jump"]:play()
    end
    self.y = self.y + self.dy
end

function Bird:render()
    -- rot = self.dy==0 and 0 or self.dy/math.abs(self.dy)*0.05
    rot = 0
    love.graphics.draw(self.image, self.x, self.y, rot)
end


