CountdownState = Class{__includes = BaseState}

function CountdownState:init()
    self.count = 3
    self.time = 0 
end

function CountdownState:update(dt)
    self.time = self.time + dt
    if self.time >= 0.75 then
        self.count = self.count - 1
        if self.count==0 then
            gStateMachine:change("play")
        end

        self.time = self.time % 0.75
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, GameHeight/2 - 28, GameWidth, 'center')
end