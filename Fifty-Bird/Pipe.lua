Pipe = Class{}

local PipeImage = love.graphics.newImage("Images/pipe.png")
PipeWidth = PipeImage:getWidth()

function Pipe:init(orientation, y)
    self.x = GameWidth + 8
    self.y = y
    self.orientation = orientation
end

function Pipe:render()
    love.graphics.draw(PipeImage, self.x, self.y, 0, 1, (self.orientation=='top' and -1 or 1))
end
