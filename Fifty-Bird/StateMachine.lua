StateMachine = Class{}

function StateMachine:init(states)
    local empty = {
        enter = function() end,
        exit = function() end,
        render = function() end,
        update = function() end,
    }
    self.states = states or {}
    self.current = empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end


