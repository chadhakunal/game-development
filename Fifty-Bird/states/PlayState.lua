PlayState = Class{__includes = BaseState}

Gravity = 20


function PlayState:init()
    self.bird = Bird()
    self.pipesTable = {}

    self.spawnTimer = 0
    self.pipeSpawnGap = 0.1
    self.lastY = math.random(20, 100)
    self.score = 0
end

function PlayState:update(dt)
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > self.pipeSpawnGap then
        local y = math.max(10, math.min(self.lastY + math.random(-20,20), GameHeight - 90))
        self.lastY = y

        table.insert(self.pipesTable, PipePair(y, math.random(80,120)))
        self.spawnTimer = 0
        self.pipeSpawnGap = math.random(20, 30)/10
    end

    for k, pipePair in pairs(self.pipesTable) do
        if not pipePair.scored and self.bird.x  > pipePair.x + PipeWidth then
            self.score = self.score+1
            pipePair.scored = true
            sounds["score"]:play()
        end

        pipePair:update(dt) 
    end
    
    for k, pipePair in pairs(self.pipesTable) do
        if pipePair.remove then
            table.remove(self.pipesTable, k)
        end
    end

    self.bird:update(dt)

    for k, pipePair in pairs(self.pipesTable) do
        for l, pipe in pairs(pipePair.pipes) do
            if self.bird:collides(pipe) then
                sounds["explosion"]:play()
                sounds["hurt"]:play()
                gStateMachine:change("score", { score = self.score })
            end
        end
    end

    if self.bird.y>GameHeight-16 then 
        sounds["explosion"]:play()
        sounds["hurt"]:play()
        gStateMachine:change("score", { score = self.score })
    end

end

function PlayState:render(dt)
    for k, pipePair in pairs(self.pipesTable) do
        pipePair:render()
    end

    self.bird:render()

    love.graphics.setFont(flappyFont)
    love.graphics.printf("Score: "..tostring(self.score), 5, 5, GameWidth, 'left')
end