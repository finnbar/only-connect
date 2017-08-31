r2 = {}

local questionMark = love.graphics.newImage("assets/questionMark.png")

local selection = 0 -- 0 = selecting..., 1=reeds, 2=lion etc.
local selected = {false,false,false,false,false,false}
local tweening = 0 -- animations until certainly pressed
local numberOfClues = 0 -- 1=5pts, 2=3pts...
local timerPos = 0
local revealedAnswer = false
local gridLocations = {{100*scale,150*scale},{300*scale,150*scale},{500*scale,150*scale},{100*scale,300*scale},{300*scale,300*scale},{500*scale,300*scale}}
local timer = 45
local alert = false

local function drawTheImage2(n) -- fix for 1st, gliding image
	if revealedAnswer then
		love.graphics.setColor(255,255,255,100)
	else
		love.graphics.setColor(255,255,255,255)
	end
	if n ~= 1 then
		if n == numberOfClues then
			love.graphics.draw(picturesR2[n],(42+(190*(n-1)))*scale+xshift,250*scale,0,0.8*scale,val(s)*3.2*scale)
		else
			love.graphics.draw(picturesR2[n],(42+(190*(n-1)))*scale+xshift,250*scale,0,0.8*scale,0.8*scale)
		end
	else
		love.graphics.draw(picturesR2[n],(val(pX)+32+(190*(n-1)))*scale+xshift,(val(pY)+20)*scale,0,0.8*scale,0.8*scale)
	end
end

local function highlighting(p)
	colour = colours("unselected")
	if selected[p] then
		colour = colours("selected")
	end
	if tweening == p then
		colour = {val(r),val(g),val(b),255}
	end
	return colour
end

local function commenceRound2(n)
	selected[n]=true
	selection=n
	numberOfClues=1
	s = newTween(0,0.25,0.1)
	pX = newTween(gridLocations[n][1],15,0.2)
	pY = newTween(gridLocations[n][2],230,0.2)
	timer = 45
	timerPos = 1
	swoosh()
	alert = false
end

local function triggerAnswer()
	numberOfClues = 3
	revealedAnswer = true
	answerTween = newTween(0,0.1,0.1)
	highlightingBg = 0
	swapped = false
	slide()
end

function r2.load()
	-- a thing
	selected = {false,false,false,false,false,false}
	r = newTween(119,183,1,0)
	g = newTween(197,214,1,0)
	b = newTween(215,237,1,0)
	s = newTween(0,0.25,0.1) -- this opens it up from the top
	pX = newTween(gridLocations[1][1],15,1)
	pY = newTween(gridLocations[1][2],230,1) --just so updateTween() doesn't panic
end

function r2.draw()
	love.graphics.setFont(fonts[4])
	love.graphics.setColor(255,255,255)
	if selection == 0 then
		glyph = {hieroglyphs["reeds"], hieroglyphs["lion"], hieroglyphs["twisted"], hieroglyphs["viper"], hieroglyphs["water"], hieroglyphs["eye"]}
		for i=1,6 do
			love.graphics.setColor(highlighting(i))
			love.graphics.draw(rd, gridLocations[i][1]*scale+xshift, gridLocations[i][2]*scale, 0, 0.25*scale, 0.25*scale)
			love.graphics.setColor(255,255,255)
			love.graphics.draw(glyph[i], gridLocations[i][1]*scale+xshift, gridLocations[i][2]*scale, 0, scale, scale)
		end
	else
		local question = questionsR2[selection]
		for i=1,numberOfClues do
			love.graphics.setColor(colours("background"))
			if #(question[i])<=25 then
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
			if i<4 then
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
				if #(question[i])<=25 then
					love.graphics.setFont(fonts[4])
				elseif #(question[i])<=45 then
					love.graphics.setFont(fonts[3])
				else
					love.graphics.setFont(fonts[2])
				end
				if pictureR2 == selection then
					drawTheImage2(i)
					if revealedAnswer then
						love.graphics.setColor(0,0,0)
						love.graphics.printf(question[i],xpos+(10*scale),ypos+(30*scale),180*scale,"center")
					end
				else
					-- normal question
					love.graphics.setColor(0,0,0)
					love.graphics.printf(question[i],xpos+(10*scale),ypos+(10*scale),180*scale,"center")
				end
				--if i==3 then show p4
				love.graphics.setColor(colours("background"))
				if i==3 and not revealedAnswer then
					love.graphics.draw(rd,xpos+(190*scale),ypos,0,0.25*scale,hscale)
					love.graphics.setColor(255,255,255)
					love.graphics.draw(questionMark,xpos+(190*scale),ypos,0,1*scale,hscale*4)
				elseif i==3 then
					love.graphics.draw(rd,xpos+(190*scale),ypos,0,0.25*scale,hscale)
					if pictureR2 == selection then drawTheImage2(4) end
					love.graphics.setColor(0,0,0)
					local pictureOffset = 0
					if pictureR2 == selection then
						pictureOffset = 20*scale
					end
					love.graphics.printf(question[4],xpos+(195*scale),ypos+(10*scale)+pictureOffset,190*scale,"center")
				end
			end
		end
		love.graphics.setFont(fonts[4])
		if 4 == timerPos then
			timerLength = ((45-timer)/45)*190
			love.graphics.setColor(colours("selected"))
			love.graphics.rectangle("fill",(20+(190*(3)))*scale+xshift,180*scale,timerLength*scale,40*scale)
			love.graphics.setColor(colours("unselected"))
			love.graphics.rectangle("fill",(20+(190*(3))+timerLength)*scale+xshift,180*scale,(190-timerLength)*scale,40*scale)
			love.graphics.setColor(255,255,255)
			if timerPos<4 then
				love.graphics.print(points[timerPos].." Points",(50+(190*(3)))*scale+xshift,180*scale)
			else
				love.graphics.print(points[timerPos].." Point",(55+(190*(3)))*scale+xshift,180*scale)
			end
		end
		if revealedAnswer then
			love.graphics.setColor(colours("blue"))
			love.graphics.draw(rd,5*scale+xshift,380*scale,0,0.98*scale,val(answerTween)*scale)
			love.graphics.setColor(255,255,255)
			love.graphics.printf(groupsR2[selection],30*scale+xshift,385*scale,730*scale,"center")
		end
	end
end

function r2.update(dt)
	if tweening ~= 0 then
		updateTween(r,dt)
		updateTween(g,dt)
		updateTween(b,dt)
	end
	if selection ~= 0 then
		updateTween(pX,dt)
		updateTween(pY,dt)
		if highlightingBg==0 and not revealedAnswer then
			timer = timer - dt
			if timer < 3 and (not alert) then
				print("Three seconds left")
				alert = true
			elseif timer < 0 then
				if currentTeam == 1 then highlightingBg=2 else highlightingBg=1 end
				love.audio.play(worse)
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

function r2.keypressed(key)
	if selection~=0 then
		if key=="space" then
			if numberOfClues<3 and highlightingBg == 0 then
				numberOfClues = numberOfClues + 1
				timerPos = numberOfClues
				s = newTween(0,0.25,0.1)
				slide()
			else
				if revealedAnswer then
					-- something here
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
					if allSel then return allSel end
				end
			end
		end
		local currentTeamKey = teamakey
		if currentTeam == 2 then currentTeamKey = teambkey end
		if key==currentTeamKey and highlightingBg==0 and (not revealedAnswer) then
			highlightingBg = currentTeam
			buzzIn(currentTeam)
		end
		if key=="up" and highlightingBg~=0 then
			if highlightingBg == 1 then
				-- team 1 gets points!
				teama = teama + points[timerPos]
			else
				-- team 2 gets points!
				teamb = teamb + points[timerPos]
			end
			debugScorePrint()
			triggerAnswer()
		end
	end
	if key=="down" and highlightingBg~=0 then
		if not swapped then
			if highlightingBg==2 then highlightingBg=1 else highlightingBg=2 end
			numberOfClues = 3
			timerPos = 4
			swapped = true
		else
			triggerAnswer()
		end
	end
end

function r2.mousepressed(x,y,b)
	if selection == 0 then
		for i=1,6 do
			if withinBox(x,y,gridLocations[i][1]*scale+xshift,gridLocations[i][2]*scale,200*scale,150*scale) and (not selected[i]) then
				if tweening == i then
					commenceRound2(i)
				else
					tweening = i
					slide()
				end
			end
		end
	end
end
