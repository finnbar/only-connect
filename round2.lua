r2 = {}

questionMark = love.graphics.newImage("assets/questionMark.png")

selection = 0 -- 0 = selecting..., 1=reeds, 2=lion etc.
selected = {false,false,false,false,false,false}
tweening = 0 -- animations until certainly pressed
numberOfClues = 0 -- 1=5pts, 2=3pts...
timerPos = 0
revealedAnswer = false
locs = {{150,150},{300,150},{500,150},{150,300},{300,300},{500,300}}
timer = 45

function r2.load()
	-- a thing
	selected = {false,false,false,false,false,false}
	r = newTween(119,183,1,0)
	g = newTween(197,214,1,0)
	b = newTween(215,237,1,0)
	s = newTween(0,0.25,0.1) -- this opens it up from the top
	pX = newTween(locs[1][1],15,1)
	pY = newTween(locs[1][2],230,1) --just so updateTween() doesn't panic
end

function r2.draw()
	love.graphics.setFont(fonttt)
	love.graphics.setColor(255,255,255)
	if selection == 0 then
		highlighting(1)
		love.graphics.draw(rd,100,150,0,0.25,0.25)
		highlighting(2)
		love.graphics.draw(rd,300,150,0,0.25,0.25)
		highlighting(3)
		love.graphics.draw(rd,500,150,0,0.25,0.25)
		highlighting(4)
		love.graphics.draw(rd,100,300,0,0.25,0.25)
		highlighting(5)
		love.graphics.draw(rd,300,300,0,0.25,0.25)
		highlighting(6)
		love.graphics.draw(rd,500,300,0,0.25,0.25)
		-- then after all of the squares are drawn
		love.graphics.setColor(255,255,255)
		love.graphics.draw(heiroglyphs["reeds"],100,150)
		love.graphics.draw(heiroglyphs["lion"],300,150)
		love.graphics.draw(heiroglyphs["twisted"],500,150)
		love.graphics.draw(heiroglyphs["viper"],100,300)
		love.graphics.draw(heiroglyphs["water"],300,300)
		love.graphics.draw(heiroglyphs["eye"],500,300)
	else
		for i=1,numberOfClues do
			love.graphics.setColor(colours("background"))
			if i==1 then
				if i == numberOfClues then
					love.graphics.draw(rd,val(pX)+5,val(pY),0,0.25,val(s))
				else
					love.graphics.draw(rd,15,230,0,0.25,0.25)
				end
				if pictureR2 == selection then
					drawTheImage2(i)
					if revealedAnswer then
						love.graphics.setColor(0,0,0)
						love.graphics.printf(questionsR2[selection][i],20,260,190,"center")
					end
				else
					--normal question
					love.graphics.setColor(0,0,0)
					love.graphics.printf(questionsR2[selection][i],val(pX)+5,val(pY)+9,190,"center")
				end
				if i == timerPos then
					timerLength = ((60-timer)/60)*190
					love.graphics.setColor(colours("selected"))
					love.graphics.rectangle("fill",val(pX)+5+(190*(i-1)),val(pY)-50,timerLength,40)
					love.graphics.setColor(colours("unselected"))
					love.graphics.rectangle("fill",val(pX)+5+(190*(i-1))+timerLength,val(pY)-50,190-timerLength,40)
					love.graphics.setColor(255,255,255)
					love.graphics.print("5 Points",val(pX)+35,val(pY)-50)
				end
			elseif i<4 then
				if i == numberOfClues then
					love.graphics.draw(rd,15+(190*(i-1)),230,0,0.25,val(s))
				else
					love.graphics.draw(rd,15+(190*(i-1)),230,0,0.25,0.25)
				end
				if i == timerPos then
					timerLength = ((60-timer)/60)*190
					love.graphics.setColor(colours("selected"))
					love.graphics.rectangle("fill",20+(190*(i-1)),180,timerLength,40)
					love.graphics.setColor(colours("unselected"))
					love.graphics.rectangle("fill",20+(190*(i-1))+timerLength,180,190-timerLength,40)
					love.graphics.setColor(255,255,255)
					if timerPos<4 then
						love.graphics.print(points[timerPos].." Points",50+(190*(i-1)),180)
					else
						love.graphics.print(points[timerPos].." Point",55+(190*(i-1)),180)
					end
				end
				if pictureR2 == selection then
					drawTheImage2(i)
					if revealedAnswer then
						love.graphics.setColor(0,0,0)
						love.graphics.printf(questionsR2[selection][i],20+(190*(i-1)),260,190,"center")
					end
				else
					-- normal question
					love.graphics.setColor(0,0,0)
					love.graphics.printf(questionsR2[selection][i],20+(190*(i-1)),240,190,"center")
				end
				--if i==3 then show p4
				love.graphics.setColor(colours("background"))
				if i==3 and not revealedAnswer then
					love.graphics.draw(rd,15+(190*3),230,0,0.25,val(s))
					love.graphics.setColor(255,255,255)
					love.graphics.draw(questionMark,15+(190*3),230,0,1,val(s)*4)
				elseif i==3 then
					love.graphics.draw(rd,15+(190*3),230,0,0.25,val(s))
					if pictureR2==selection then drawTheImage2(4) end
					love.graphics.setColor(0,0,0)
					if pictureR2==selection then
						love.graphics.printf(questionsR2[selection][4],20+(190*3),260,190,"center")
					else
						love.graphics.printf(questionsR2[selection][4],20+(190*3),240,190,"center")
					end
				end
			end
		end
		if 4 == timerPos then
			timerLength = ((60-timer)/60)*190
			love.graphics.setColor(colours("selected"))
			love.graphics.rectangle("fill",20+(190*(3)),180,timerLength,40)
			love.graphics.setColor(colours("unselected"))
			love.graphics.rectangle("fill",20+(190*(3))+timerLength,180,190-timerLength,40)
			love.graphics.setColor(255,255,255)
			if timerPos<4 then
				love.graphics.print(points[timerPos].." Points",50+(190*(3)),180)
			else
				love.graphics.print(points[timerPos].." Point",55+(190*(3)),180)
			end
		end
		if revealedAnswer then
			love.graphics.setColor(colours("blue"))
			love.graphics.draw(rd,5,380,0,0.98,val(answerTween))
			love.graphics.setColor(255,255,255)
			love.graphics.printf(groupsR2[selection],30,385,730,"center")
		end
	end
end

function drawTheImage2(n) -- fix for 1st, gliding image
	if revealedAnswer then
		love.graphics.setColor(255,255,255,100)
	else
		love.graphics.setColor(255,255,255,255)
	end
	if n ~= 1 then
		if n == numberOfClues then
			love.graphics.draw(picturesR2[n],42+(190*(n-1)),250,0,0.8,val(s)*3.2)
		else
			love.graphics.draw(picturesR2[n],42+(190*(n-1)),250,0,0.8,0.8)
		end
	else
		love.graphics.draw(picturesR2[n],val(pX)+32+(190*(n-1)),val(pY)+20,0,0.8,0.8)
	end
end

function highlighting(p)
	if selected[p] then
		love.graphics.setColor(colours("selected"))
	else
		love.graphics.setColor(colours("unselected"))
	end
	if tweening == p then
		love.graphics.setColor(val(r),val(g),val(b))
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
			if timer < 0 then
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

function r2.keypressed(key)
	--temp
	if selection~=0 then
		if key==" " then
			if numberOfClues<3 then
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
		if key=="left" and highlightingBg==0 and currentTeam == 1 then
			highlightingBg = 1
			buzzIn(1)
		end
		if key=="right" and highlightingBg==0 and currentTeam == 2 then
			highlightingBg = 2
			buzzIn(2)
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
			numberOfClues = 3
			revealedAnswer = true
			answerTween = newTween(0,0.1,0.1)
			highlightingBg = 0
			swapped = false
			slide()
		end
	end
	if key=="down" and highlightingBg~=0 then
		if not swapped then
			if highlightingBg==2 then highlightingBg=1 else highlightingBg=2 end
			numberOfClues = 3
			timerPos = 4
			swapped = true
		else
			swapped = false
			numberOfClues = 3
			revealedAnswer = true
			answerTween = newTween(0,0.1,0.1)
			highlightingBg = 0
			slide()
		end
	end
end

function commenceRound2(n)
	selected[n]=true
	selection=n
	numberOfClues=1
	s = newTween(0,0.25,0.1)
	pX = newTween(locs[n][1],15,0.2)
	pY = newTween(locs[n][2],230,0.2)
	timer = 60
	timerPos = 1
	swoosh()
end


function r2.mousepressed(x,y,b)
	-- bounding boxes time! yaaaaaaaay.
	if selection == 0 then
		if x>=150 and x<300 and y>=150 and y<300 and (not selected[1]) then
			if tweening == 1 then
				commenceRound2(1)
				--go go go!
			else
				tweening = 1 -- tween tween tween!
				slide()
			end
		end
		if x>=300 and x<500 and y>=150 and y<300 and (not selected[2]) then
			if tweening == 2 then
				commenceRound2(2)
				--go go go!
			else
				tweening = 2 -- tween tween tween!
				slide()
			end
		end
		if x>=500 and x<650 and y>=150 and y<300 and (not selected[3]) then
			if tweening == 3 then
				commenceRound2(3)
				--go go go!
			else
				tweening = 3 -- tween tween tween!
				slide()
			end
		end
		if x>=150 and x<300 and y>=300 and y<450 and (not selected[4]) then
			if tweening == 4 then
				commenceRound2(4)
				--go go go!
			else
				tweening = 4 -- tween tween tween!
				slide()
			end
		end
		if x>=300 and x<500 and y>=300 and y<450 and (not selected[5]) then
			if tweening == 5 then
				commenceRound2(5)
				--go go go!
			else
				tweening = 5 -- tween tween tween!
				slide()
			end
		end
		if x>=500 and x<650 and y>=300 and y<450 and (not selected[6]) then
			if tweening == 6 then
				commenceRound2(6)
				--go go go!
			else
				tweening = 6 -- tween tween tween!
				slide()
			end
		end
	end
end