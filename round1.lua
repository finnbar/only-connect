r1 = {}

--[[ NOTE TO SELF: order of hieroglyphs is
Reeds, Lion, Twisted,
Viper, Water, Eye.
]]

local musicImage = love.graphics.newImage("assets/musicRound.png")

local selection = 0 -- 0 = selecting..., 1=reeds, 2=lion etc.
local selected = {false,false,false,false,false,false} -- which questions are done?
local tweening = 0 -- animations until certainly pressed
local numberOfClues = 0 -- 1=5pts, 2=3pts...
local timerPos = 0 -- what clue is the timer hovering over?
local revealedAnswer = false -- as the name suggests, is the answer revealed?
local gridLocations = {{100*scale,150*scale},{300*scale,150*scale},{500*scale,150*scale},{100*scale,300*scale},{300*scale,300*scale},{500*scale,300*scale}} -- where clues glide from
local timer = 45 -- TIMER, duh.
local alert = false -- tells the host that there's only THREE SECONDS LEFT WHAT

local function drawTheImage1(n) -- guess what this does!
	if revealedAnswer then
		love.graphics.setColor(255,255,255,100)
	else
		love.graphics.setColor(255,255,255,255)
	end
	if n ~= 1 then
		if n == numberOfClues then
			love.graphics.draw(picturesR1[n],(42+(190*(n-1)))*scale+xshift,250*scale,0,0.8*scale,val(s)*3.2*scale)
		else
			love.graphics.draw(picturesR1[n],(42+(190*(n-1)))*scale+xshift,250*scale,0,0.8*scale,0.8*scale)
		end
	else
		love.graphics.draw(picturesR1[n],(val(pX)+32+(190*(n-1)))*scale+xshift,(val(pY)+20)*scale,0,0.8*scale,0.8*scale)
	end
end

local function highlighting(p) -- fill it in (the hieroglyphs at the main screen)
	colour = colours("unselected")
	if selected[p] then
		colour = colours("selected")
	end
	if tweening == p then
		colour = {val(r),val(g),val(b),255}
	end
	return colour
end

--reset for the next round
local function commenceRound1(n)
	selected[n]=true
	selection=n
	numberOfClues=1
	s = newTween(0,0.25,0.1)
	pX = newTween(gridLocations[n][1],15,0.2)
	pY = newTween(gridLocations[n][2],230,0.2)
	timer = 45
	swoosh()
	alert = false
	if musicR1 == n then
		audioR1[1]:play()
	end
end

local function playTheChosenSound(r)
	-- when selected, chime or slide (sfx)
	if r == musicR1 then
		jingle()
	else
		slide()
	end
end

local function triggerAnswer()
	numberOfClues = 4
	revealedAnswer = true
	answerTween = newTween(0,0.1,0.1)
	highlightingBg = 0
	swapped = false
	if musicR1 == selection then
		audioR1[numberOfClues]:stop()
	end
	slide()
end

function r1.load()
	selected = {false,false,false,false,false,false}
	r = newTween(119,183,1,0)
	g = newTween(197,214,1,0)
	b = newTween(215,237,1,0)
	s = newTween(0,0.25,0.1) -- this opens it up from the top
	pX = newTween(gridLocations[1][1],15,1)
	pY = newTween(gridLocations[1][2],230,1) --just so updateTween() doesn't panic
	answerTween = newTween(0,0,1)
	whatTeam()
end

function r1.draw()
	if selection == 0 then
		-- draw the boxes, hieroglyphs etc.
		glyph = {hieroglyphs["reeds"], hieroglyphs["lion"], hieroglyphs["twisted"], hieroglyphs["viper"], hieroglyphs["water"], hieroglyphs["eye"]}
		for i=1,6 do
			love.graphics.setColor(highlighting(i))
			love.graphics.draw(rd, gridLocations[i][1]*scale+xshift, gridLocations[i][2]*scale, 0, 0.25*scale, 0.25*scale)
			love.graphics.setColor(255,255,255)
			love.graphics.draw(glyph[i], gridLocations[i][1]*scale+xshift, gridLocations[i][2]*scale, 0, scale, scale)
		end
	else
		-- a question has been selected!
		local question = questionsR1[selection]
		for i=1,numberOfClues do
			love.graphics.setColor(colours("background"))
			if #(question[i])<=25 then -- word wrap, shrink the clue if it's too long.
				love.graphics.setFont(fonts[4])
			elseif #(question[i])<=45 then
				love.graphics.setFont(fonts[3])
			else
				love.graphics.setFont(fonts[2])
			end
			local xpos = 15+(190*(i-1))*scale+xshift
			local hscale = 0.25*scale
			local ypos = 230*scale
			if i == 1 then
				xpos = val(pX)*scale+xshift
				ypos = val(pY)*scale
			end
			if i == numberOfClues then
				hscale = val(s)*scale
			end
			love.graphics.draw(rd,xpos,ypos,0,0.25*scale,hscale)
			if i == timerPos then
				love.graphics.setFont(fonts[4])
				timerLength = ((45-timer)/45)*190
				love.graphics.setColor(colours("selected"))
				love.graphics.rectangle("fill",xpos+(5*scale),ypos-(50*scale),timerLength*scale,40*scale)
				love.graphics.setColor(colours("unselected"))
				love.graphics.rectangle("fill",xpos+(5+timerLength)*scale,ypos-(50*scale),(190-timerLength)*scale,40*scale)
				love.graphics.setColor(255,255,255)
				local pointstring = points[timerPos].." Points"
				if timerPos==4 then
					pointstring = "1 Point"
				end
				love.graphics.print(pointstring,xpos+(35*scale),ypos-(50*scale))
			end
			if #(question[i])<=25 then -- WORD WRAP
				love.graphics.setFont(fonts[4])
			elseif #(question[i])<=45 then
				love.graphics.setFont(fonts[3])
			else
				love.graphics.setFont(fonts[2])
			end
			if pictureR1 == selection then
				drawTheImage1(i)
				if revealedAnswer then
					love.graphics.setColor(0,0,0)
					love.graphics.printf(question[i],xpos+(10*scale),ypos+(30*scale),180*scale,"center")
				end
			elseif musicR1 == selection then
				if revealedAnswer then
					love.graphics.setColor(255,255,255,100)
				else
					love.graphics.setColor(255,255,255)
				end
				love.graphics.draw(musicImage,xpos,ypos,0,1*scale,hscale*4)
				if revealedAnswer then
					love.graphics.setColor(0,0,0)
					love.graphics.printf(question[i],xpos+(10*scale),ypos+(10*scale),180*scale,"center")
				end
			else
				love.graphics.setColor(0,0,0)
				love.graphics.printf(question[i],xpos+(10*scale),ypos+(10*scale),180*scale,"center")
			end
		end
		love.graphics.setFont(fonts[4])
		if revealedAnswer then
			love.graphics.setColor(colours("blue"))
			love.graphics.draw(rd,5*scale+xshift,380*scale,0,0.98*scale,val(answerTween)*scale)
			love.graphics.setColor(255,255,255)
			love.graphics.printf(groupsR1[selection],30*scale+xshift,385*scale,730*scale,"center")
		end
	end
end

function r1.update(dt)
	if not revealedAnswer then timerPos = numberOfClues end
	-- update ALL THE TWEENS
	if tweening ~= 0 then
		updateTween(r,dt)
		updateTween(g,dt)
		updateTween(b,dt)
	end
	if selection ~= 0 then
		updateTween(pX,dt)
		updateTween(pY,dt)
		-- deal with the timer
		if highlightingBg==0 and not revealedAnswer then
			timer = timer - dt
			if timer < 3 and (not alert) then
				print("Three seconds left")
				alert = true
			elseif timer < 0 then
				love.audio.play(worse)
				if currentTeam == 1 then highlightingBg=2 else highlightingBg=1 end
				numberOfClues = 4
				swapped = true
			end
		end
	end
	if revealedAnswer then
		updateTween(answerTween,dt)
	end
	updateTween(s,dt)
end

function r1.keypressed(key)
	-- Accept standard keypresses, space to move on etc.
	if selection ~= 0 then
		if key=="space" then
			if numberOfClues<4 and highlightingBg == 0 then
				numberOfClues=numberOfClues+1
				s = newTween(0,0.25,0.1)
				if selection == musicR1 then
					audioR1[numberOfClues-1]:stop()
					audioR1[numberOfClues]:play()
				end
				slide()
			elseif revealedAnswer then
				selection = 0
				tweening = 0
				numberOfClues = 0
				revealedAnswer = false
				allSel = true
				highlightingBg = 0
				if currentTeam == 1 then currentTeam=2 else currentTeam=1 end
				for i=1,6 do
					if not selected[i] then allSel = false end
				end
				if allSel then return true end
			end -- if the answer's not revealed then do nothing space. We want a buzz in.
		end
		-- buzz!
		local currentTeamKey = teamakey
		if currentTeam == 2 then currentTeamKey = teambkey end
		if key==currentTeamKey and highlightingBg==0 and (not revealedAnswer) then
			highlightingBg = currentTeam
			if musicR1 == selection then audioR1[numberOfClues]:stop() end
			buzzIn(currentTeam)
		end
		-- they got it right!
		if key=="up" and highlightingBg~=0 then
			if highlightingBg == 1 then
				teama = teama + points[numberOfClues]
			else
				teamb = teamb + points[numberOfClues]
			end
			debugScorePrint()
			triggerAnswer()
		end
		-- they got it wrong...
		if key=="down" and highlightingBg~=0 then
			if not swapped then
				if highlightingBg==2 then highlightingBg=1 else highlightingBg=2 end
				if musicR1 == selection and numberOfClues < 4 then audioR1[4]:play() end
				numberOfClues = 4
				swapped = true
			else
				triggerAnswer()
			end
		end
	end
end

function r1.mousepressed(x,y,b)
	if selection == 0 then
		for i=1,6 do
			if withinBox(x,y,gridLocations[i][1]*scale+xshift,gridLocations[i][2]*scale,200*scale,150*scale) and (not selected[i]) then
				if tweening == i then
					commenceRound1(i)
				else
					tweening = i
					playTheChosenSound(i)
				end
			end
		end
	end
end
