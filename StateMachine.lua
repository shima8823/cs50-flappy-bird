--
-- StateMachine - a state machine
--
-- Usage:
--
-- -- States are only created as need, to save memory, reduce clean-up bugs and increase speed
-- -- due to garbage collection taking longer with more data in memory.
-- --
-- -- States are added with a string identifier and an intialisation function.
-- -- It is expect the init function, when called, will return a table with
-- -- Render, Update, Enter and Exit methods.
--
-- gStateMachine = StateMachine {
-- 		['MainMenu'] = function()
-- 			return MainMenu()
-- 		end,
-- 		['InnerGame'] = function()
-- 			return InnerGame()
-- 		end,
-- 		['GameOver'] = function()
-- 			return GameOver()
-- 		end,
-- }
-- gStateMachine:change("MainGame")
--
-- Arguments passed into the Change function after the state name
-- will be forwarded to the Enter function of the state being changed too.
--
-- State identifiers should have the same name as the state table, unless there's a good
-- reason not to. i.e. MainMenu creates a state using the MainMenu table. This keeps things
-- straight forward.
--
-- =Doing Transitions=
--
StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		name = "empty",
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
	self.stack = {}
end

function StateMachine:change(stateOrName, enterParams)
    if type(stateOrName) == "string" then
        assert(self.states[stateOrName]) -- state must exist!
        self.current:exit()
        self.current = self.states[stateOrName]()
        self.current.name = stateOrName
    else
        self.current:exit()
        self.current = stateOrName
    end
    self.current:enter(enterParams)
end


function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end

function StateMachine:push(stateName, enterParams)
    table.insert(self.stack, self.current)
    self:change(stateName, enterParams)
end

function StateMachine:pop()
    if #self.stack > 0 then
        local prevState = table.remove(self.stack)
        self:change(prevState)
    end
end
