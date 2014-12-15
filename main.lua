-- WELCOME TO ONLY CONNECT
-- THE ONLY SHOW ABOUT CONNECTING
-- YEAH

scale = love.window.getHeight()/650
-- The scale is got from the height and done squarely, OK?

require "requirer" -- the requirer requires everything that needs to be required requiringly

teama = 0
teamb = 0
teamaname = "Team A" --default
teambname = "Team B"
rounds = {r1,show,r2,show,r3,show,r4,show,tie,show}
roundIndex = 0 -- TEMP SHOULD BE ZERO
debug = false -- TEMP SHOULD BE FALSE
highlightingBg = 0 -- SHOULD THE BACKGROUND BE HIGHLIGHTED??
points = {5,3,2,1}
currentTeam = 1 -- SHOULD BE CONTROLLED AT MENU LATER ON
filename = "example"
swapped = false
local prevTeam = 2

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
	if roundIndex == 0 then filename="" 
		else importer(filename) end
	if rounds[roundIndex] then rounds[roundIndex].load() end
end

function love.textinput(t)
	if roundIndex == 0 then filename = filename..t end
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
		love.graphics.printf("Please type in the name of the folder of the game you'd like to play",10*scale,10*scale,780*scale,"center")
		love.graphics.printf(filename,10*scale,300*scale,780*scale,"center")
		love.graphics.setFont(font)
		love.graphics.printf("Disclaimer: Only Connect is owned by the BBC, and some of the assets have been directly taken and modified from the show (such as some of the sounds and heiroglyphs). These are being used fairly for educational and other purposes limited to non-commercial projects. Also, this project has only been in development for less than three weeks so could therefore act problematically in some cases. Please don't sue me.",10*scale,590*scale,780*scale,"left")
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
	whatTeam()
end

function love.keypressed(key)
	if roundIndex > 0 then
		if rounds[roundIndex].keypressed(key) then
			roundIndex = roundIndex + 1
			if roundIndex == 9 then
				if teama ~= teamb then
					roundIndex = 0
				end
			end
			if roundIndex > #rounds then
				roundIndex = 0
			else
				if rounds[roundIndex] then rounds[roundIndex].load() end
			end
		end
	else
		--main menu jazz
		if key=="return" then
			importer(filename)
			roundIndex = 1
			if rounds[roundIndex] then rounds[roundIndex].load() end
		elseif key=="backspace" then
			filename = string.sub(filename,0,-2)
		end
	end
end

function love.mousepressed(x,y,button)
	if roundIndex > 0 then
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
end

function debugScorePrint()
	print(teamaname..": "..teama,teambname..": "..teamb)
end

function whatTeam()
	if roundIndex ~= 7 and roundIndex ~= 9 then
		if prevTeam ~= currentTeam then
			if currentTeam == 1 then
				print("It's "..teamaname.."'s turn!")
			else
				print("It's "..teambname.."'s turn!")
			end
		end
	end
	prevTeam = currentTeam
end

function buzzIn(a)
	if a==1 then
		love.audio.play(buzzer1)
	else
		love.audio.play(buzzer2)
	end
end

function slide()
	love.audio.play(slideSound)
end

function tap()
	love.audio.play(pressSound)
end

function swoosh()
	love.audio.play(slideLong)
end