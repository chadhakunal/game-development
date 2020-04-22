TitleState = Class{__includes = BaseState}

function TitleState:update(dt)
    if love.keyboard.keyPressed["Enter"] or love.keyboard.keyPressed["return"] then
        gStateMachine:change("countdown")
    end
end

function TitleState:render()
    local birdTitle = Bird()
    love.graphics.setFont(flappyFont)
    love.graphics.printf("Fifty Bird", 0, 25, GameWidth, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf("Press Enter to Play", 0, 60, GameWidth, 'center')
    birdTitle:render()
end


