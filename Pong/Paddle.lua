--[[
    GD50 Assignment 0
    Pong Remake

    Author: Kunal Chadha
    kunalchadhaks2412@gmail.com

    -- Paddle Class -- 
    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy=0
    -- self.dx=0
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:update(dt)
    if self.dy<0 then
        self.y = math.max(boardTop, self.y + self.dy * dt)
    elseif self.dy>0 then
        self.y = math.min(boardBottom - self.height, self.y + self.dy * dt)
    end

    -- if self.dx<0 then
    --     self.x = math.max(boardLeft, self.x + self.dx * dt)
    -- elseif self.dx>0 then
    --     self.x = math.min(boardRight - self.width, self.x + self.dx * dt)
    -- end
end

-- Bots
function Paddle:Bot(ball, difficulty)
    center = self.y + self.width/2
    if ball.y>center then
        self.dy = PaddleSpeed/difficulty
    elseif ball.y<center then
        self.dy = -PaddleSpeed/difficulty
    else
        self.dy = 0
    end
end