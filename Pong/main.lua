--[[
    GD50 Assignment 0
    Pong Remake

    Author: Kunal Chadha
    kunalchadhaks2412@gmail.com

    Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
    the ball past your opponent's edge. 
    First to 10 points wins.
    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on 
    modern systems.
]]

push = require("push") -- https://github.com/Ulydev/push
Class = require("class") -- https://github.com/vrld/hump/blob/master/class.lua

require 'Ball'
require 'Paddle'

WindowWidth = 1280
WindowHeight = 720

GameWidth = 432
GameHeight = 243

boardTop = 50
boardBottom = GameHeight - 5
boardLeft = 5
boardRight = GameWidth - 5
boardHeight = boardBottom - boardTop

targetPoints = 10
gameType = 0

function love.load()
    -- Original - 
    -- love.window.setMode(WindowWidth, WindowHeight, {
    --     fullscreen = false,
    --     resizable = false,
    --     vsync = false
    -- })
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    push:setupScreen(GameWidth, GameHeight, WindowWidth, WindowHeight, {
        fullscreen = false, 
        resizable = true,
        vsync = true
    })

    love.window.setTitle("Retro Pong 2D")

    smallFont = love.graphics.newFont("font.ttf", 8)
    mediumFont = love.graphics.newFont("font.ttf", 16)
    largeFont = love.graphics.newFont("font.ttf", 40)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource("sounds/score.wav", 'static'),
        ["wall_hit"] = love.audio.newSource("sounds/wall_hit.wav", 'static')
    }

    player1Points = 0
    player2Points = 0

    paddleWidth = 2
    paddleHeight = 20
    PaddleSpeed = 200
    player1 = Paddle(boardLeft + 30, boardTop+10, paddleWidth, paddleHeight)
    player2 = Paddle(boardRight - paddleWidth - 30, boardBottom - paddleHeight - 10, paddleWidth, paddleHeight)

    ballRadius = 5
    ball = Ball(GameWidth/2 - ballRadius/2, boardTop + boardHeight/2 - ballRadius/2, ballRadius)

    servingPlayer = 1

    gameState = 'start'
    status = 'Press Enter to Start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)

    if gameState == "serve" then 
        ball.dy = math.random(-50,50)
        ball.dx = servingPlayer==1 and -math.random(140,200) or math.random(140,200)
    end

    -- Ball Movement
    if gameState=="play" then
        -- Collision with Paddle
        if ball:collides(player1) then 
            ball.dx = -ball.dx*1.03
            ball.x = player1.x+player1.width+2

            -- Randomize Y velocity
            if ball.dy<0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds["paddle_hit"]:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx*1.03
            ball.x = player2.x-ball.radius-2

            -- Randomize Y velocity
            if ball.dy<0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds["paddle_hit"]:play()
        end

        -- Collision with Upper Boundaries
        if ball.y<=boardTop then
            ball.y = boardTop
            ball.dy = -ball.dy
            sounds["wall_hit"]:play()
        end

        if ball.y>=boardBottom-ball.radius then
            ball.y = boardBottom - ball.radius
            ball.dy = -ball.dy
            sounds["wall_hit"]:play()
        end

        -- Collision with Side Boundaries
        if ball.x<=boardLeft then
            servingPlayer = 2
            player2Points = player2Points + 1
            ball:reset()
            gameState = 'serve'
            status = "Player 2 Scores! Press Space to Serve, Enter to Restart"
            sounds["score"]:play()

            if player2Points==targetPoints then
                gameState = "start"
                status = "P2 Wins! Press Enter to Restart"
                player1Points = 0
                player2Points = 0 
            end
        end

        if ball.x>=boardRight - ball.radius then
            servingPlayer = 1
            player1Points = player1Points + 1
            ball:reset()
            gameState = 'serve'
            status = "Player 1 Scores! Press Space to Serve, Enter to Restart"
            sounds["score"]:play()

            if player1Points==targetPoints then
                gameState = "start"
                status = "P1 Wins! Press Enter to Restart"
                player1Points = 0
                player2Points = 0
            end
        end

    end

    -- Player 1 Movement

    if gameType>0 then
        if gameState=="play" then
            player1:Bot(ball, 4-gameType)
        end
    else
        if love.keyboard.isDown("w") then
            player1.dy = -PaddleSpeed
        elseif love.keyboard.isDown("s") then
            player1.dy = PaddleSpeed
        -- elseif love.keyboard.isDown("a") then
        --     player1.dx = -PaddleSpeed
        -- elseif love.keyboard.isDown("d") then
        --     player1.dx = PaddleSpeed
        else
            player1.dy = 0
            -- player1.dx = 0
        end
    end

    -- Player 2 Movement
    if love.keyboard.isDown("up") then
        player2.dy = -PaddleSpeed
    elseif love.keyboard.isDown("down") then
        player2.dy = PaddleSpeed
    else
        player2.dy = 0
    end

    -- Update
    if gameState=="play" then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.draw()
    push:start()

    -- Reset Color of Background
    love.graphics.clear(40/255, 45/255, 52/255, 255)

    -- Display Heading
    love.graphics.setLineStyle("rough")
    love.graphics.setFont(mediumFont)
    love.graphics.setColor(255,255,255,255)
    love.graphics.printf('Retro Pong 2D', 0, 4, GameWidth, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf(status, 0, 40 , GameWidth, 'center')

    -- Display Options
    love.graphics.setFont(smallFont)
    love.graphics.printf("Play Against: ", boardLeft, 23, boardRight, 'left')
    love.graphics.printf("Friend", (boardRight-boardLeft)/5, 23, boardRight, 'left')
    love.graphics.printf("Level 1 Bot", 2*(boardRight-boardLeft)/5, 23, boardRight, 'left')
    love.graphics.printf("Level 2 Bot", 3*(boardRight-boardLeft)/5, 23, boardRight, 'left')
    love.graphics.printf("Level 3 Bot", 4*(boardRight-boardLeft)/5, 23, boardRight, 'left')
    love.graphics.line(boardLeft, 34, boardRight, 34)
    love.graphics.rectangle('fill', (gameType+1)*(boardRight-boardLeft)/5-8, 24, 5, 5)
    
    -- Draw Board
    -- Draw Lines
    love.graphics.line(GameWidth/2, boardTop, GameWidth/2, boardBottom)
    love.graphics.line(boardLeft, boardTop, boardRight, boardTop)
    love.graphics.line(boardLeft+1, boardTop-1, boardLeft, boardTop+5)
    love.graphics.line(boardRight, boardTop-1, boardRight, boardTop+5)
    love.graphics.line(boardLeft, boardBottom, boardRight, boardBottom)
    love.graphics.line(boardLeft, boardBottom, boardLeft, boardBottom-5)
    love.graphics.line(boardRight, boardBottom, boardRight, boardBottom-5)
    
    -- Display Points
    love.graphics.setFont(largeFont)
    love.graphics.printf(tostring(player1Points), 0, boardTop + 5,GameWidth - 75, 'center')
    love.graphics.printf(tostring(player2Points), 0, boardTop + 5, GameWidth + 75, 'center')  

    -- Display Player Names
    love.graphics.setFont(smallFont)
    love.graphics.printf("P1", boardLeft + 4, boardTop-8, boardRight, 'left')
    love.graphics.printf("P2", boardLeft, boardTop-8, boardRight-8, 'right')

    -- Draw Paddle 1
    player1:render()

    -- Draw Paddle 2
    player2:render()

    -- Draw Ball
    ball:render()

    -- Display FPS
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0,255,0,255)
    love.graphics.printf("FPS: "..tostring(love.timer.getFPS()), 5, 1, GameWidth, 'left')

    push:finish()
end


function love.keypressed(key)
    if key=="escape" then
        love.event.quit()

    elseif key=="enter" or key=="return" then
        if gameState=="start" then
            gameState = "serve"
            status = "Lets Play Pong! Press Space to Serve, Enter to Restart. Target Points="..tostring(targetPoints)
        else
            gameState="start"
            ball:reset()
            if player2Points>player1Points then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
            player1Points = 0
            player2Points = 0
            status = servingPlayer==1 and "Player 1 Serves! Press Enter to Start" or "Player 2 Serves! Press Enter to Start"
        end
    elseif key == "space" then
        if gameState == "serve" then
            gameState = "play"
            status = "Play"
        end
    elseif key=="left" and gameState=="start" then
        gameType = math.max(0, gameType-1)
    elseif key=="right" and gameState=="start" then
        gameType = math.min(3, gameType+1)
    end
end
