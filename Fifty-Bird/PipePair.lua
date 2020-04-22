PipePair = Class{}

local PipeScrollSpeed = -50

function PipePair:init(y, GapHeight)
    self.x = GameWidth
    self.y = y
    self.pipes = {
        ["upper"] = Pipe('top', self.y),
        ["lower"] = Pipe('bottom', self.y + GapHeight)
    }
    self.remove = false
    self.scored = false
    self.gapHeight = GapHeight
end

function PipePair:update(dt)
    if self.x > -PipeWidth then
        self.x = self.x + PipeScrollSpeed*dt
        self.pipes["upper"].x = self.x
        self.pipes["lower"].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    self.pipes["upper"]:render()
    self.pipes["lower"]:render()
end
