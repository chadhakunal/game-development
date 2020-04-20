--[[
    GD50 Assignment 0
    Pong Remake

    Author: Kunal Chadha
    kunalchadhaks2412@gmail.com

    -- Ball Class -- 
    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

Ball = Class{}

function Ball:init(x, y, radius)
    self.startX = x
    self.startY = y

    self.x = self.startX
    self.y = self.startY
    self.radius = radius
    self.dx =  math.random(2) == 1 and 100 or -100
    self.dy = 0
end

function Ball:reset()
    self.x = self.startX
    self.y = self.startY
    self.dx =  math.random(2) == 1 and 100 or -100
    self.dy = 0
end

function Ball:collides(paddle)
    if self.x>paddle.x+paddle.width or paddle.x>self.x+self.radius then
        return false
    end

    if self.y>paddle.y+paddle.height or paddle.y>self.y+self.radius then
        return false
    end

    return true
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.radius, self.radius)
end