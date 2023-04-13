--[[
    PauseState Class
]]

PauseState = Class{__includes = BaseState}

function PauseState:init()
    -- nothing
end

function PauseState:enter(params)
    self.playState = params.playState
end

function PauseState:render()
    self.playState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Pause', 0, 64, VIRTUAL_WIDTH, 'center')
end