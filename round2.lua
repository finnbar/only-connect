r2 = {}

questionMark = love.graphics.newImage("assets/questionMark.png")

selection = 0 -- 0 = selecting..., 1=reeds, 2=lion etc.
selected = {false,false,false,false,false,false}
tweening = 0 -- animations until certainly pressed
numberOfClues = 0 -- 1=5pts, 2=3pts...
timerPos = 0
revealedAnswer = false
locs = {{150*scale,150*scale},{300*scale,150*scale},{500*scale,150*scale},{150*scale,300*scale},{300*scale,300*scale},{500*scale,300*scale}}
timer = 45
alert = false

--[[
THIS IS PRETTY MUCH THE SAME AS ROUND 1, SO I'M GONNA LEAVE IT FOR NOW. As James Robson - my Mechanics teacher - would say: whatevs.
]]

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
		love.graphics.draw(rd,100*scale+xshift,150*scale,0,0.25*scale,0.25*scale)
		highlighting(2)
		love.graphics.draw(rd,300*scale+xshift,150*scale,0,0.25*scale,0.25*scale)
		highlighting(3)
		love.graphics.draw(rd,500*scale+xshift,150*scale,0,0.25*scale,0.25*scale)
		highlighting(4)
		love.graphics.draw(rd,100*scale+xshift,300*scale,0,0.25*scale,0.25*scale)
		highlighting(5)
		love.graphics.draw(rd,300*scale+xshift,300*scale,0,0.25*scale,0.25*scale)
		highlighting(6)
		love.graphics.draw(rd,500*scale+xshift,300*scale,0,0.25*scale,0.25*scale)
		-- then after all of the squares are drawn
		love.graphics.setColor(255,255,255)
		love.graphics.draw(heiroglyphs["reeds"],100*scale+xshift,150*scale,0,scale,scale)
		love.graphics.draw(heiroglyphs["lion"],300*scale+xshift,150*scale,0,scale,scale)
		love.graphics.draw(heiroglyphs["twisted"],500*scale+xshift,150*scale,0,scale,scale)
		love.graphics.draw(heiroglyphs["viper"],100*scale+xshift,300*scale,0,scale,scale)
		love.graphics.draw(heiroglyphs["water"],300*scale+xshift,300*scale,0,scale,scale)
		love.graphics.draw(heiroglyphs["eye"],500*scale+xshift,300*scale,0,scale,scale)
	else
		for i=1,numberOfClues do
			love.graphics.setColor(colours("background"))
			if #(questionsR2[selection][i])<=25 then
				love.graphics.setFont(fonttt)
			elseif #(questionsR2[selection][i])<=45 then
				love.graphics.setFont(fontt)
			else
				love.graphics.setFont(font)
			end
			if i==1 then
				if i == numberOfClues then
					love.graphics.draw(rd,(val(pX)+5)*scale+xshift,val(pY)*scale,0,0.25*scale,val(s)*scale)
				else
					love.graphics.draw(rd,15*scale+xshift,230*scale,0,0.25*scale,0.25*scale)
				end
				if pictureR2 == selection then
					drawTheImage2(i)
					if revealedAnswer then
						love.graphics.setColor(0,0,0)
						love.graphics.printf(questionsR2[selection][i],25*scale+xshift,260*scale,180*scale,"center")
					end
				else
					--normal question
					love.graphics.setColor(0,0,0)
					love.graphics.printf(questionsR2[selection][i],(val(pX)+10)*scale+xshift,(val(pY)+9)*scale,180*scale,"center")
				end
				if i == timerPos then
					love.graphics.setFont(fonttt)
					timerLength = ((45-timer)/45)*190
					love.graphics.setColor(colours("selected"))
					love.graphics.rectangle("fill",(val(pX)+5+(190*(i-1)))*scale+xshift,(val(pY)-50)*scale,timerLength*scale,40*scale)
					love.graphics.setColor(colours("unselected"))
					love.graphics.rectangle("fill",(val(pX)+5+(190*(i-1))+timerLength)*scale+xshift,(val(pY)-50)*scale,(190-timerLength)*scale,40*scale)
					love.graphics.setColor(255,255,255)
					love.graphics.print(points[1].." Points",(val(pX)+35)*scale+xshift,(val(pY)-50)*scale)
				end
			elseif i<4 then
				if i == numberOfClues then
					love.graphics.draw(rd,(15+(190*(i-1)))*scale+xshift,230*scale,0,0.25*scale,val(s)*scale)
				else
					love.graphics.draw(rd,(15+(190*(i-1)))*scale+xshift,230*scale,0,0.25*scale,0.25*scale)
				end
				if i == timerPos then
					love.graphics.setFont(fonttt)
					timerLength = ((45-timer)/45)*190
					love.graphics.setColor(colours("selected"))
					love.graphics.rectangle("fill",(20+(190*(i-1)))*scale+xshift,180*scale,timerLength*scale,40*scale)
					love.graphics.setColor(colours("unselected"))
					love.graphics.rectangle("fill",(20+(190*(i-1))+timerLength)*scale+xshift,180*scale,(190-timerLength)*scale,40*scale)
					love.graphics.setColor(255,255,255)
					if timerPos<4 then
						love.graphics.print(points[timerPos].." Points",(50+(190*(i-1)))*scale+xshift,180*scale)
					else
						love.graphics.print(points[timerPos].." Point",(55+(190*(i-1)))*scale+xshift,180*scale)
					end
				end
				if #(questionsR2[selection][i])<=25 then
					love.graphics.setFont(fonttt)
				elseif #(questionsR2[selection][i])<=45 then
					love.graphics.setFont(fontt)
				else
					love.graphics.setFont(font)
				end
				if pictureR2 == selection then
					drawTheImage2(i)
					if revealedAnswer then
						love.graphics.setColor(0,0,0)
						love.graphics.printf(questionsR2[selection][i],(25+(190*(i-1)))*scale+xshift,260*scale,180*scale,"center")
					end
				else
					-- normal question
					love.graphics.setColor(0,0,0)
					love.graphics.printf(questionsR2[selection][i],(25+(190*(i-1)))*scale+xshift,240*scale,180*scale,"center")
				end
				--if i==3 then show p4
				love.graphics.setColor(colours("background"))
				if i==3 and not revealedAnswer then
					love.graphics.draw(rd,(15+(190*3))*scale+xshift,230*scale,0,0.25*scale,val(s)*scale)
					love.graphics.setColor(255,255,255)
					love.graphics.draw(questionMark,(15+(190*3))*scale+xshift,230*scale,0,1*scale,val(s)*4*scale)
				elseif i==3 then
					love.graphics.draw(rd,(15+(190*3))*scale+xshift,230*scale,0,0.25*scale,val(s)*scale)
					if pictureR2==selection then drawTheImage2(4) end
					love.graphics.setColor(0,0,0)
					if pictureR2==selection then
						love.graphics.printf(questionsR2[selection][4],(20+(190*3))*scale+xshift,260*scale,190*scale,"center")
					else
						love.graphics.printf(questionsR2[selection][4],(20+(190*3))*scale+xshift,240*scale,190*scale,"center")
					end
				end
			end
		end
		love.graphics.setFont(fonttt)
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

function drawTheImage2(n) -- fix for 1st, gliding image
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
			if timer < 3 and (not alert) then
				print("Three seconds left")
				alert = true
			elseif timer < 0 then
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
		if key==teamakey and highlightingBg==0 and currentTeam == 1 and (not revealedAnswer)then
			highlightingBg = 1
			buzzIn(1)
		end
		if key==teambkey and highlightingBg==0 and currentTeam == 2 and (not revealedAnswer)then
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
	timer = 45
	timerPos = 1
	swoosh()
	alert = false
end


function r2.mousepressed(x,y,b)
	-- bounding boxes time! yaaaaaaaay.
	if selection == 0 then
		if x>=150*scale+xshift and x<300*scale+xshift and y>=150*scale and y<300*scale and (not selected[1]) then
			if tweening == 1 then
				commenceRound2(1)
				--go go go!
			else
				tweening = 1 -- tween tween tween!
				slide()
			end
		end
		if x>=300*scale+xshift and x<500*scale+xshift and y>=150*scale and y<300*scale and (not selected[2]) then
			if tweening == 2 then
				commenceRound2(2)
				--go go go!
			else
				tweening = 2 -- tween tween tween!
				slide()
			end
		end
		if x>=500*scale+xshift and x<650*scale+xshift and y>=150*scale and y<300*scale and (not selected[3]) then
			if tweening == 3 then
				commenceRound2(3)
				--go go go!
			else
				tweening = 3 -- tween tween tween!
				slide()
			end
		end
		if x>=150*scale+xshift and x<300*scale+xshift and y>=300*scale and y<450*scale and (not selected[4]) then
			if tweening == 4 then
				commenceRound2(4)
				--go go go!
			else
				tweening = 4 -- tween tween tween!
				slide()
			end
		end
		if x>=300*scale+xshift and x<500*scale+xshift and y>=300*scale and y<450*scale and (not selected[5]) then
			if tweening == 5 then
				commenceRound2(5)
				--go go go!
			else
				tweening = 5 -- tween tween tween!
				slide()
			end
		end
		if x>=500*scale+xshift and x<650*scale+xshift and y>=300*scale and y<450*scale and (not selected[6]) then
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