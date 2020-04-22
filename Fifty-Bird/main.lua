--[[
    GD50 Assignment 2
    Fifty Bird

    Author: Kunal Chadha
    kunalchadhasks2412@gmail.com

    Description: 
    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple 
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping 
    the screen, making the player's bird avatar flap its wings and move upwards slightly. 
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.

    ToDo: 
    pipe collision y logic
    Mouse Click
    Comments
    Pause and its sound effect
    Medals
    Race Bird (Bot)
    Menu for Single, Race
    Change background, bird image, music
    High Score
]]

push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/TitleState'
require 'states/PlayState'
require 'states/CountdownState'
require 'states/ScoreState'

WindowWidth = 1280
WindowHeight = 720

GameWidth = 512
GameHeight = 288

local background = love.graphics.newImage("Images/background.png")
local ground = love.graphics.newImage("Images/ground.png")

local backgroundStartingPoint = 0
local groundStartingPoint = 0

local backgroundSpeed = 30
local groundSpeed = 50

local backgroundLoopingPoint = 413
local groundLoopingPoint = GameWidth


function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter("nearest", "nearest")
    push:setupScreen(GameWidth, GameHeight, WindowWidth, WindowHeight, {
        fullscree=false,
        vsync=true,
        resizable=true
    })
    love.window.setTitle("Fifty Bird")

    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)

    love.graphics.setFont(flappyFont)

    sounds = {
        ["jump"]=love.audio.newSource("sounds/jump.wav", 'static'),
        ["explosion"]=love.audio.newSource("sounds/explosion.wav", 'static'),
        ["hurt"]=love.audio.newSource("sounds/hurt.wav", 'static'),
        ["score"]=love.audio.newSource("sounds/score.wav", 'static'),
        ["music"]=love.audio.newSource("sounds/marios_way.mp3", 'static'),
    }

    sounds["music"]:setLooping(true)
    sounds["music"]:play()

    gStateMachine = StateMachine({
        ["title"] = function() return TitleState() end,
        ["play"] = function() return PlayState() end,
        ["countdown"] = function() return CountdownState() end,
        ["score"] = function() return ScoreState() end
    })

    gStateMachine:change("title")

    love.keyboard.keyPressed = {}
end


function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)
    love.keyboard.keyPressed[key] = true

    if key=="escape" then
        love.event.quit()
    end
end


function love.update(dt)
    backgroundStartingPoint = (backgroundStartingPoint + backgroundSpeed*dt) % backgroundLoopingPoint
    groundStartingPoint = (groundStartingPoint + groundSpeed) % groundLoopingPoint

    gStateMachine:update(dt)

    love.keyboard.keyPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundStartingPoint, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundStartingPoint, GameHeight-16)

    -- Display FPS
    love.graphics.setFont(smallFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf("FPS: "..tostring(love.timer.getFPS()), 5, 1, GameWidth-20, 'right')

    push:finish()
end