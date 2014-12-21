-- WELCOME TO ONLY CONNECT
-- THE ONLY SHOW ABOUT CONNECTING
-- YEAH

--[[ RIGHT.
I'm going to try and explain everything I've done in this code, in an attempt to understand it better myself. Also, it means other coders can learn what (not) to do!
]]

scale = love.window.getHeight()/650
-- The scale is got from the height and done squarely, OK?
-- This multiplies all the coordinates I measured at 800x650 by some scale factor defined by the dimensions in love.conf

require "requirer" -- The requirer requires everything that needs to be required requiringly

teama = 0
teamb = 0 -- Scores!
teamaname = "Team A"
teambname = "Team B" -- Names!
rounds = {r1,show,r2,show,r3,show,r4,show,tie,show} -- What order are the rounds in?
roundIndex = 0 -- What round we're currently on. Remember, Lua starts arrays at 1, so 0 is shorthand for "we're not there yet"
debug = false -- Should debug coordinates appear in the top left corner?
highlightingBg = 0 -- Should the background be highlighted? (aka has a team buzzed in?)
points = {5,3,2,1} -- What is the point value of each question?
currentTeam = 1 -- What team is currently answering?
filename = "example" -- Where are the questions located?
swapped = false -- Has the question been passed over yet (so if after this they still get it wrong, reveal the answer)
local prevTeam = 2 -- This keeps tabs on what team should go and alerts the host accordingly.

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
		else importer(filename) end -- the importer is Important.
	if rounds[roundIndex] then rounds[roundIndex].load() end
	print("Welcome host.")
	print("I am your debug console, here to tell you the score and what team should be answering now!")
	print("I hope I am useful.")
end

function love.textinput(t)
	if roundIndex == 0 then filename = filename..t end -- take the filename input
end

function love.draw()
	love.graphics.setFont(fontttt)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(bg,0,0,0,1.2*scale,1.2*scale) -- standard background stuff. Set to 1.2 scale (despite the size of the image) because it wasn't working last minute.
	-- some translucent rectangles to draw the highlighting:
	if highlightingBg == 1 then
		love.graphics.setColor(0,0,255,50)
		love.graphics.rectangle("fill",0,0,1000*scale,1000*scale)
	elseif highlightingBg == 2 then
		love.graphics.setColor(255,0,255,50)
		love.graphics.rectangle("fill",0,0,1000*scale,1000*scale)
	end
	love.graphics.setColor(255,255,255)
	-- if the round returns true, move on!
	if roundIndex > 0 then
		if rounds[roundIndex].draw() then
			roundIndex = roundIndex + 1
			if roundIndex > #rounds then
				print("bye")
				love.event.quit()
			else
				if rounds[roundIndex] then rounds[roundIndex].load() end
			end
		end
	else
		--main menu jazz
		love.graphics.printf("Please type in the name of the folder of the game you'd like to play",10*scale,10*scale,780*scale,"center")
		love.graphics.setFont(fonttttt)
		love.graphics.printf(filename,10*scale,250*scale,780*scale,"center")
		love.graphics.setFont(fon)
		love.graphics.printf("Disclaimer: Only Connect is owned by the BBC, and some of the assets have been directly taken and modified from the show (such as some of the sounds and heiroglyphs). These are being used fairly for educational and other purposes limited to non-commercial projects. Also, this project is quite new so could therefore act problematically in some cases. Please don't sue me.",10*scale,590*scale,780*scale,"left")
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
				print("bye")
				love.event.quit()
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
				print("bye")
				love.event.quit()
			else
				if rounds[roundIndex] then rounds[roundIndex].load() end
			end
		end
		-- manual score editing, for bonus points!
		if key=="q" then
			teama = teama + 1
			debugScorePrint()
		elseif key=="w" then
			teama = teama - 1
			debugScorePrint()
		elseif key=="o" then
			teamb = teamb + 1
			debugScorePrint()
		elseif key=="p" then
			teamb = teamb - 1
			debugScorePrint()
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
					print("bye")
					love.event.quit()
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
	if roundIndex ~= 7 and roundIndex ~= 9 and roundIndex ~= 0 then
		if prevTeam ~= currentTeam then
			if currentTeam == 1 then
				print("It's "..teamaname.."'s turn!")
			else
				print("It's "..teambname.."'s turn!")
			end
		end
		prevTeam = currentTeam
	end
end

-- these exist purely so that I can mess with their global volume without editing every individual love.audio.play() call

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