-- WELCOME TO ONLY CONNECT
-- THE ONLY SHOW ABOUT CONNECTING
-- YEAH

require "requirer" -- the requirer requires everything that needs to be required requiringly

teama = 0
teamb = 0
teamaname = "Team A" --default
teambname = "Team B"
rounds = {r1,show,r2,show,r3,show,r4,show,tie,show}
roundIndex = 7 -- TEMP SHOULD BE ZERO
debug = true -- TEMP SHOULD BE FALSE
highlightingBg = 0 -- SHOULD THE BACKGROUND BE HIGHLIGHTED??
points = {5,3,2,1}
currentTeam = 1 -- SHOULD BE CONTROLLED AT MENU LATER ON

--[[
OK, KEYBOARD CONTROLS:
Space advances clues in rounds 1,2 and 4.
Left/Right are buzzers for blue/purple teams, also sets starting team at menu (TODO)
Up accepts the answer given
Down rejects the answer given
Round 3 is all tapping
]]

function love.load()
	-- a thing
	love.graphics.setFont(fontttt)
	importer("exampleQuestions.txt")
	if rounds[roundIndex] then rounds[roundIndex].load() end
end

function love.draw()
	love.graphics.setFont(fontttt)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(bg,0,0,0,1.2,1.2)
	if highlightingBg == 1 then
		love.graphics.setColor(0,0,255,50)
		love.graphics.rectangle("fill",0,0,love.window.getWidth(),love.window.getHeight())
	elseif highlightingBg == 2 then
		love.graphics.setColor(255,0,255,50)
		love.graphics.rectangle("fill",0,0,love.window.getWidth(),love.window.getHeight())
	end
	love.graphics.setColor(255,255,255)
	if roundIndex > 0 then
		if rounds[roundIndex].draw() then
			roundIndex = roundIndex + 1
			if roundIndex > #rounds then
				roundIndex = 0
			else
				if rounds[roundIndex] then rounds[roundIndex].load() end
			end
		end
	else
		--main menu jazz
	end
	if debug then
		love.graphics.setFont(font)
		love.graphics.print(love.mouse.getX()..","..love.mouse.getY(),0,0)
	end
end

function love.update(dt)
	if roundIndex > 0 then
		if rounds[roundIndex].update(dt) then
			-- the round has ended IT HAS RETURNED TRUE
			roundIndex = roundIndex + 1
			if roundIndex > #rounds then
				roundIndex = 0
			else
				if rounds[roundIndex] then rounds[roundIndex].load() end
			end
		end
	else
		--main menu jazz
	end
end

function love.keypressed(key)
	if roundIndex > 0 then
		if rounds[roundIndex].keypressed(key) then
			roundIndex = roundIndex + 1
			if roundIndex > #rounds then
				roundIndex = 0
			else
				if rounds[roundIndex] then rounds[roundIndex].load() end
			end
		end
	else
		--main menu jazz
	end
end

function love.mousepressed(x,y,button)
	if rounds[roundIndex].mousepressed then
		if rounds[roundIndex].mousepressed(x,y,button) then
			roundIndex = roundIndex + 1
			if roundIndex > #rounds then
				roundIndex = 0
			else
				if rounds[roundIndex] then rounds[roundIndex].load() end
			end
		end
	end
end