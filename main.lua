-- WELCOME TO ONLY CONNECT
-- THE ONLY SHOW ABOUT CONNECTING
-- YEAH

--[[ RIGHT.
I'm going to try and explain everything I've done in this code, in an attempt to understand it better myself. Also, it means other coders can learn what (not) to do!
]]
w, h, f = love.window.getMode()

scale = h/650
xscale = w/800 -- this is purely for large background elements, just to make sure they fit in the event of odd proportions
-- The scale is got from the height and done squarely, OK?
-- This multiplies all the coordinates I measured at 800x650 by some scale factor defined by the dimensions in love.conf
local originalX = w
local originalY = h
local shouldResize = true

require "requirer" -- The requirer requires everything that needs to be required requiringly

teama = 0
teamb = 0 -- Scores!
teamaname = "Team A"
teambname = "Team B" -- Names!
teamakey = "left"
teambkey = "right" -- What's their buzzer?
teamacheats = {false,false}
teambcheats = {false,false} -- infinity lives, glitch
rounds = {show,r1,show,r2,show,r3,show,r4,show,tie,show} -- What order are the rounds in?
roundIndex = 0 -- What round we're currently on. Remember, Lua starts arrays at 1, so 0 is shorthand for "we're not there yet"
whereAreTheRounds = {2,4,6,8,10} -- This is for the showscore KONAMICODE easter egg. This should be the roundIndex that each separate is contained in.
debug = false -- Should debug coordinates appear in the top left corner?
highlightingBg = 0 -- Should the background be highlighted? (aka has a team buzzed in?)
points = {5,3,2,1} -- What is the point value of each question?
currentTeam = 1 -- What team is currently answering?
filename = "example" -- Where are the questions located?
swapped = false -- Has the question been passed over yet (so if after this they still get it wrong, reveal the answer)
local prevTeam = 2 -- This keeps tabs on what team should go and alerts the host accordingly.
xshift = (w-(scale*800))/2 -- This centres the interface when fullscreened.
local calibrating = 0 -- 0: get filename, 1: ask for teama key, 2: got it!, 3: ask for teamb key, 4: got it!
local switchTimer = 1

function love.resize(w,h)
	width, height, flags = love.window.getMode()
	scale = height/650
	xscale = width/800
	xshift = (width-(scale*800))/2
	deffonts()
	if w~=originalX or h~=originalY then shouldResize = true end
end

--[[
OK, KEYBOARD CONTROLS:
Space advances clues in rounds 1,2 and 4.
Set buzzing keys at the menu screen.
Up accepts the answer given
Down rejects the answer given
Round 3 is all tapping
]]

function love.load()
	-- a thing
	love.graphics.setFont(fonts[5])
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
	love.graphics.setFont(fonts[5])
	love.graphics.setColor(255,255,255)
	love.graphics.draw(bg,0,0,0,1.2*xscale,1.2*scale) -- standard background stuff. Set to 1.2 scale (despite the size of the image) because it wasn't working last minute.
	-- some translucent rectangles to draw the highlighting:
	if highlightingBg == 1 then
		love.graphics.setColor(0,0,255,50)
		love.graphics.rectangle("fill",0,0,1000*xscale,1000*scale)
	elseif highlightingBg == 2 then
		love.graphics.setColor(255,0,255,50)
		love.graphics.rectangle("fill",0,0,1000*xscale,1000*scale)
	end
	love.graphics.setColor(255,255,255)
	-- if the round returns true, move on!
	if roundIndex > 0 then
		if rounds[roundIndex].draw() then
			roundIndex = roundIndex + 1
			if roundIndex > #rounds then
				roundIndex = #rounds
			else
				if rounds[roundIndex] then rounds[roundIndex].load() end
			end
		end
	else
		if calibrating == 0 then
			--main menu jazz
			love.graphics.printf("Please type in the name of the folder of the game you'd like to play",10*scale+xshift,10*scale,780*scale,"center")
			love.graphics.setFont(fonts[7])
			love.graphics.printf(filename,10*scale+xshift,250*scale,780*scale,"center")
		elseif calibrating == 1 or calibrating == 2 then
			love.graphics.printf(teamaname..", please buzz in now.",10*scale+xshift,100*scale,780*scale,"center")
			if calibrating == 2 then
				love.graphics.printf("Thanks! \""..teamakey.."\" has been selected.",10*scale+xshift,300*scale,780*scale,"center")
			end
		elseif calibrating == 3 or calibrating == 4 then
			love.graphics.printf(teambname..", please buzz in now.",10*scale+xshift,100*scale,780*scale,"center")
			if calibrating == 4 then
				love.graphics.printf("Thanks! \""..teambkey.."\" has been selected.",10*scale+xshift,300*scale,780*scale,"center")
			end
		end
		love.graphics.setFont(fonts[1])
		love.graphics.printf("Disclaimer: Only Connect is owned by the BBC, and some of the assets have been directly taken and modified from the show (such as some of the sounds and heiroglyphs). These are being used fairly for educational and other purposes limited to non-commercial projects. Also, this project is written by one student without a lot of testing so it could be problematic. Please don't sue me.",10*scale+xshift,590*scale,780*scale,"left")
	end
	if debug then
		love.graphics.setFont(fonts[2])
		love.graphics.print(love.mouse.getX()..","..love.mouse.getY(),0,0)
	end
end

function love.update(dt)
	if roundIndex > 0 then
		if rounds[roundIndex].update(dt) then
			-- the round has ended IT HAS RETURNED TRUE
			roundIndex = roundIndex + 1
			if roundIndex > #rounds then
				roundIndex = #rounds
			else
				if rounds[roundIndex] then rounds[roundIndex].load() end
			end
		end
	else
		--main menu jazz
		if calibrating == 5 then
			roundIndex = 1
			if rounds[roundIndex] then rounds[roundIndex].load() end
			calibrating = 0
		elseif calibrating == 2 or calibrating == 4 then
			switchTimer = switchTimer - dt
			if switchTimer <= 0 then
				switchTimer = 1
				calibrating = calibrating + 1
			end
		end
	end
	whatTeam()
end

function love.keypressed(key)
	if roundIndex > 0 then
		if rounds[roundIndex].keypressed(key) then
			roundIndex = roundIndex + 1
			if roundIndex == 9 then
				if teama ~= teamb then
					roundIndex = 8
				end
			end
			if roundIndex > #rounds then
				roundIndex = #rounds
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
		if calibrating == 0 then
			if key=="return" then
				if importer(filename) then
					calibrating = 1
				else
					filename = ""
					print("Bad game name / game contents!")
				end
			elseif key=="backspace" then
				filename = string.sub(filename,0,-2)
			end
		elseif calibrating == 1 then
			if not (key==" " or key=="up" or key=="down" or key=="q" or key=="w" or key=="o" or key=="p" or key=="escape") then
				teamakey = key
				calibrating = 2
				print(teamaname.."'s key is "..teamakey)
			end
		elseif calibrating == 3 then
			if not (key==" " or key=="up" or key=="down" or key=="q" or key=="w" or key=="o" or key=="p" or key=="escape") then
				teambkey = key
				calibrating = 4
				print(teambname.."'s key is "..teambkey)
			end
		end
	end
	if key=="escape" then
		if shouldResize then
			f = love.window.getFullscreen()
			love.window.setFullscreen(false)
			love.window.setMode(originalX,originalY,{resizable=true})
			if f then
				originalX, originalY, flags = love.window.getMode()
			end
			height, width, flags = love.window.getMode()
			love.resize(width,height)
			shouldResize = false
		else
			love.event.quit()
		end
	end
end

function love.mousepressed(x,y,button)
	if roundIndex > 0 then
		if rounds[roundIndex].mousepressed then
			if rounds[roundIndex].mousepressed(x,y,button) then
				roundIndex = roundIndex + 1
				if roundIndex > #rounds then
					roundIndex = #rounds
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
	if rounds[roundIndex] ~= r3 and rounds[roundIndex] ~= r4 and roundIndex ~= 0 then
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
