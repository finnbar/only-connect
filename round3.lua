r3 = {}

-- THE BIG BIG ONE
-- IT'S SO BIG THAT IT'S... I DUNNO

chosenWall = 0 -- 1=lion, 2=water, 0=hmmm....
selectionR3 = {false,false} -- already done?
tweening = 0 -- animating selection?
wall1 = {}
wall2 = {}
chosen = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
paint = 1
numberOfSelected = 0
lives = 3
life = love.graphics.newImage("assets/life.png")
timer = 150
isItDone = false
currentlyBeingShown = 0
local revealedAnswer = true
answersR3 = {}
R3Score = 0
resolveTheWall = false
resolutionTimer = 1
colourTweens = {}
colourList = {"blue","green","purple","greenblue"}
local colourSpeed = 0.15

function returnSeparateColours(name)
	return {colours(name)[1],colours(name)[2],colours(name)[3]}
end

function r3.load()
	-- a thing
	r = newTween(119,183,1,0)
	g = newTween(197,214,1,0)
	b = newTween(215,237,1,0)
	s = newTween(0,0.25,0.25)
	local cb = returnSeparateColours("background")
	for i=1,16 do table.insert(colourTweens,{newTween(cb[1],cb[1],1),newTween(cb[2],cb[2],1),newTween(cb[3],cb[3],1)}) end
	movementTweens = {}
	for i=1,16 do table.insert(movementTweens,0) end
	-- now mix up the groups into tables of their own...
	for i=1,4 do
		for j=1,4 do
			table.insert(wall1,questionsR31[i][j])
			table.insert(wall2,questionsR32[i][j])
		end
	end
	wall1 = randSort(wall1)
	wall2 = randSort(wall2)
	if currentTeam == 1 then
		currentTeam = 2
	else
		currentTeam = 1
	end
end

function randSort(t) -- THANKS THE INTERNET! ("no problem" - The Internet)
	for i = #t, 2, -1 do -- backwards
	    local r = love.math.random(i) -- select a random number between 1 and i
	    t[i], t[r] = t[r], t[i] -- swap the randomly selected item to position i
	end
	return t
end

function r3.draw()
	love.graphics.setFont(fonttt)
	highlightingBg = currentTeam
	if chosenWall == 0 then
		if tweening == 1 then
			love.graphics.setColor(val(r),val(g),val(b))
		elseif selectionR3[1] then
			love.graphics.setColor(colours("selected"))
		else
			love.graphics.setColor(colours("unselected"))
		end
		love.graphics.draw(rd,190*scale,200*scale,0,0.25*scale,0.25*scale)
		if tweening == 2 then
			love.graphics.setColor(val(r),val(g),val(b))
		elseif selectionR3[2] then
			love.graphics.setColor(colours("selected"))
		else
			love.graphics.setColor(colours("unselected"))
		end
		love.graphics.draw(rd,390*scale,200*scale,0,0.25*scale,0.25*scale)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(heiroglyphs["lion"],190*scale,200*scale,0,scale,scale)
		love.graphics.draw(heiroglyphs["water"],390*scale,200*scale,0,scale,scale)
	else
		for i=1,4 do
			for j=1,4 do
				current = i + (j-1)*4
				if (not isItDone) or chosen[current]==currentlyBeingShown or currentlyBeingShown==0 or resolveTheWall then
					local cb = colourTweens[current]
					love.graphics.setColor(val(cb[1]),val(cb[2]),val(cb[3]))
					if movementTweens[current]~=0 then
						love.graphics.draw(rd,(15+(190*(i-1))+val(movementTweens[current][1]))*scale,(10+(145*(j-1))+val(movementTweens[current][2]))*scale,0,0.25*scale,val(s)*scale)
					else
						love.graphics.draw(rd,(15+(190*(i-1)))*scale,(10+(145*(j-1)))*scale,0,0.25*scale,val(s)*scale)
					end
					love.graphics.setColor(0,0,0)
					if chosenWall==1 then
						if #(wall1[current])<=25 then
							love.graphics.setFont(fonttt)
						elseif #(wall1[current])<=45 then
							love.graphics.setFont(fontt)
						else
							love.graphics.setFont(font)
						end
						if movementTweens[current]~=0 then
							love.graphics.printf(wall1[current],((65+(190*(i-1)))+val(movementTweens[current][1]))*scale,((20+(145*(j-1)))+val(movementTweens[current][2]))*scale,100*scale,"center")
						else
							love.graphics.printf(wall1[current],(65+(190*(i-1)))*scale,(20+(145*(j-1)))*scale,100*scale,"center")
						end
					else
						if #(wall2[current])<=25 then
							love.graphics.setFont(fonttt)
						elseif #(wall2[current])<=45 then
							love.graphics.setFont(fontt)
						else
							love.graphics.setFont(font)
						end
						if movementTweens[current]~=0 then
							love.graphics.printf(wall2[current],((65+(190*(i-1)))+val(movementTweens[current][1]))*scale,((20+(145*(j-1)))+val(movementTweens[current][2]))*scale,100*scale,"center")
						else
							love.graphics.printf(wall2[current],(65+(190*(i-1)))*scale,(20+(145*(j-1)))*scale,100*scale,"center")
						end
					end
				end
				if currentlyBeingShown > 0 and (not resolveTheWall) then
					love.graphics.setColor(colours("unselected"))
					if currentlyBeingShown<4 then
						love.graphics.draw(rd,0,(10+(145*currentlyBeingShown))*scale,0,scale,0.1*scale)
						love.graphics.setColor(255,255,255)
						if revealedAnswer then
							love.graphics.printf(answersR3[currentlyBeingShown],0,(10+(145*currentlyBeingShown))*scale,800*scale,"center")
						end
					else
						love.graphics.draw(rd,0,(10+(145*2.5))*scale,0,scale,0.1*scale)
						love.graphics.setColor(255,255,255)
						if revealedAnswer then
							love.graphics.printf(answersR3[4],0,(10+(145*2.5))*scale,800*scale,"center")
						end
					end
				end
			end
		end
		love.graphics.setColor(255,255,255)
		if paint==3 then
			for i=1,lives do
				love.graphics.draw(life,(540+(i*60))*scale,590*scale,0,0.75*scale,0.75*scale)
			end
		end
		love.graphics.setColor(colours("unselected"))
		love.graphics.rectangle("fill",20*scale,600*scale,((150-timer)*(500/150))*scale,30*scale)
		love.graphics.setColor(colours("selected"))
		love.graphics.rectangle("fill",(20+(150-timer)*(500/150))*scale,600*scale,(500-((150-timer)*(500/150)))*scale,30*scale)
	end
end

function r3.update(dt)
	if tweening~=0 then
		updateTween(r,dt)
		updateTween(g,dt)
		updateTween(b,dt)
	end
	if chosenWall~=0 then
		updateTween(s,dt)
		for i=1,16 do
			if movementTweens[i]~=0 then
				updateTween(movementTweens[i][1],dt)
				updateTween(movementTweens[i][2],dt)
			end
			if colourTweens[i]~=0 then
				updateTween(colourTweens[i][1],dt)
				updateTween(colourTweens[i][2],dt)
				updateTween(colourTweens[i][3],dt)
			end
		end
		if not isItDone then
			if timer > 0 then
				timer = timer - dt
			else
				timer = 0
				isItDone = true
				dealWithTheAnswers()
				love.audio.play(worse)
				for i=1,16 do
					if chosen[i] == paint then
						chosen[i] = 0
					end
				end
			end
		end
	end
	if resolveTheWall then
		resolutionTimer = resolutionTimer + dt
		if resolutionTimer > 1 then
			completeItself()
			resolutionTimer = 1
		end
	end
end

function r3.keypressed(key)
	if isItDone then
		if key==" " then
			--print(toRes)
			if revealedAnswer then
				--print(resolveTheWall)
				local comp = paint
				if paint<4 then comp = comp - 1 end
				if currentlyBeingShown < comp then
					if resolveTheWall and toRes == 4 then
						resolveTheWall = false
					end
					currentlyBeingShown = currentlyBeingShown + 1
				else
					if resolveTheWall and toRes == 4 then
						resolveTheWall = false
					end
					if currentlyBeingShown == 4 then
						chosenWall = 0
						--print(R3Score)
						if R3Score == 8 then
							R3Score = 0
							if highlightingBg == 1 then
								teama = teama + 2
							else
								teamb = teamb + 2
							end
							debugScorePrint()
						end
						if (selectionR3[1]) and (selectionR3[2]) then
							highlightingBg = 0
							return true
						end
						if highlightingBg == 1 then currentTeam = 2 else currentTeam = 1 end
					else
						-- resolve the wall!
						toRes = paint
						resolveTheWall = true
						paint = 4
					end
				end
				revealedAnswer = false
			elseif (not revealedAnswer) and (currentlyBeingShown == 0 or resolveTheWall) then
				revealedAnswer = true
			end
		elseif key=="up" then
			slide()
			if highlightingBg == 1 then
				teama = teama + 1
			else
				teamb = teamb + 1
			end
			debugScorePrint()
			revealedAnswer = true
			R3Score = R3Score + 1
		elseif key=="down" then
			slide()
			revealedAnswer = true
		end
	end
end

function completeItself()
	-- how am I going to do this?
	-- OK, so we start with paint
	if toRes<4 then
		local sample = ""
		--now let's find the group for toRes' set
		if chosenWall == 1 then
			sample = wall1[((toRes-1)*4)+1]
		else
			sample = wall2[((toRes-1)*4)+1]
		end
		-- now find its group
		local location = 0
		for i=1,4 do
			for j=1,4 do
				if chosenWall == 1 then
					if questionsR31[i][j] == sample then location = i end
				else
					if questionsR32[i][j] == sample then location = i end
				end
			end
		end
		local thingsToSort = {}
		for i=1,4 do
			if chosenWall == 1 then
				table.insert(thingsToSort,questionsR31[location][i])
			else
				table.insert(thingsToSort,questionsR32[location][i])
			end
		end
		selectedIndexes = {}
		for q=1,4 do
			table.insert(selectedIndexes,0)
		end
		for q=1,16 do
			for k=1,4 do
				if chosenWall == 1 then
					if wall1[q] == thingsToSort[k] then
						selectedIndexes[k] = q
					end
				else
					if wall2[q] == thingsToSort[k] then
						selectedIndexes[k] = q
					end
				end
			end
		end
		for i=1,4 do
			chosen[selectedIndexes[i]] = toRes
			local cb = colours(colourList[toRes])
			local ca = colours("background")
			colourTweens[selectedIndexes[i]] = {newTween(ca[1],cb[1],colourSpeed),newTween(ca[2],cb[2],colourSpeed),newTween(ca[3],cb[3],colourSpeed)}
		end
		doTheMovement(toRes)
		swoosh()
		toRes = toRes + 1
	else
		for i=1,16 do
			if chosen[i] == 0 then
				chosen[i] = 4
				local cb = colours("greenblue")
				local ca = colours("background")
				colourTweens[i] = {newTween(ca[1],cb[1],colourSpeed),newTween(ca[2],cb[2],colourSpeed),newTween(ca[3],cb[3],colourSpeed)}
			end
		end
	end
	dealWithTheAnswers()
end

function clearAll()
	s = newTween(0,0.25,0.25)
	lives = 3
	isItDone = false
	answersR3 = {}
	revealedAnswer = false
	currentlyBeingShown = 0
	paint = 1
	tweening = 0
	R3Score = 0
	timer =  150
	for i=1,16 do chosen[i]=0 end
	local cb = returnSeparateColours("background")
	for i=1,16 do colourTweens[i] = {newTween(cb[1],cb[1],1),newTween(cb[2],cb[2],1),newTween(cb[3],cb[3],1)} end
end

function r3.mousepressed(x,y,button)
	if chosenWall == 0 then
		if x>=190*scale and x<=390*scale and y>=200*scale and y<=350*scale then
			if tweening == 1 then
				--ACTIVATE!
				selectionR3[1] = true
				chosenWall = 1
				s = newTween(0,0.25,0.25)
				clearAll()
				swoosh()
			else
				tweening = 1
				slide()
			end
		elseif x>=390*scale and x<=590*scale and y>=200*scale and y<=350*scale then
			if tweening == 2 then
				--ACTIVATE
				selectionR3[2] = true
				chosenWall = 2
				s = newTween(0,0.25,0.25)
				clearAll()
				swoosh()
			else
				tweening = 2
				slide()
			end
		end
	else
		if not isItDone then
		--ok, clicking the things....
			tap()
			for i=1,4 do
				for j=1,4 do
					current = i + (4*(j-1))
					if x>=(15+(190*(i-1)))*scale and x<=(15+(190*(i)))*scale and y>=(10+(145*(j-1)))*scale and y<=(10+(145*(j)))*scale then
						if chosen[current]==paint then
							chosen[current] = 0
							local ca = colours(colourList[paint])
							local cb = colours("background")
							colourTweens[current] = {newTween(ca[1],cb[1],colourSpeed),newTween(ca[2],cb[2],colourSpeed),newTween(ca[3],cb[3],colourSpeed)}
							numberOfSelected = numberOfSelected - 1
						elseif chosen[current]==0 then
							chosen[current] = paint
							local cb = colours(colourList[paint])
							local ca = colours("background")
							colourTweens[current] = {newTween(ca[1],cb[1],colourSpeed),newTween(ca[2],cb[2],colourSpeed),newTween(ca[3],cb[3],colourSpeed)}
							numberOfSelected = numberOfSelected + 1
							if numberOfSelected == 4 then
								local selectedItems = {}
								for l=1,16 do
									if chosen[l]==paint then
										if chosenWall == 1 then
											table.insert(selectedItems,wall1[l])
										else
											table.insert(selectedItems,wall2[l])
										end
									end
								end
								table.sort(selectedItems)
								selectedIndexes = {}
								for q=1,4 do
									table.insert(selectedIndexes,0)
								end
								for q=1,16 do
									for k=1,4 do
										if chosenWall == 1 then
											if wall1[q] == selectedItems[k] then
												selectedIndexes[k] = q
											end
										else
											if wall2[q] == selectedItems[k] then
												selectedIndexes[k] = q
											end
										end
									end
								end
								-- for k=1,4 do
								-- 	print(selectedItems[k],selectedIndexes[k])
								-- end
								--for l=1,4 do print(selectedItems[l]) end
								--CHECK!
								yesThatsCorrect = false
								for l=1,4 do
									local q = {}
									if chosenWall == 1 then
										q = questionsR31[l]
									else
										q = questionsR32[l]
									end
									table.sort(q)
									allGood = true
									for k=1,4 do
										if q[k]~=selectedItems[k] then
											allGood = false
										end
									end
									if allGood then yesThatsCorrect = true end
								end
								if yesThatsCorrect then
									if paint < 3 then
										-- ok, now the exciting movement! yaaaay
										local ca = colours(colourList[paint])
										colourTweens[current] = {newTween(ca[1],ca[1],1),newTween(ca[2],ca[2],1),newTween(ca[3],ca[3],1)}
										doTheMovement(paint)
										swoosh()
										R3Score = R3Score + 1
										if highlightingBg==1 then
											teama = teama + 1
										else
											teamb = teamb + 1
										end
										debugScorePrint()
										paint = paint + 1
										--love.graphics.draw(rd,15+(190*(i-1)),10+(145*(j-1)),0,0.25,val(s))
									else
										R3Score = R3Score + 2
										if highlightingBg==1 then
											teama = teama + 2
										else
											teamb = teamb + 2
										end
										local ca = colours(colourList[paint])
										colourTweens[current] = {newTween(ca[1],ca[1],1),newTween(ca[2],ca[2],1),newTween(ca[3],ca[3],1)}
										debugScorePrint()
										doTheMovement(paint)
										swoosh()
										paint = 4
										for z=1,16 do
											local ca = colours(colourList[4])
											if chosen[z]==0 then
												chosen[z]=4
												colourTweens[z] = {newTween(ca[1],ca[1],1),newTween(ca[2],ca[2],1),newTween(ca[3],ca[3],1)}
											end
										end
										isItDone = true
										dealWithTheAnswers()
									end
								else
									--oh no it's wrong
									for i=1,16 do
										if chosen[i] == paint then
											chosen[i]=0
											local ca = colours(colourList[paint])
											local cb = colours("background")
											colourTweens[i] = {newTween(ca[1],cb[1],colourSpeed),newTween(ca[2],cb[2],colourSpeed),newTween(ca[3],cb[3],colourSpeed)}
										end
									end
									if paint == 3 then
										lives = lives - 1
										if lives == 0 then
											timer = 0
											isItDone = true
											dealWithTheAnswers()
											love.audio.play(worse)
											for i=1,16 do
												if chosen[i] == paint then
													chosen[i] = 0
												end
											end
										else
											love.audio.play(bad)
										end
									end
								end
								numberOfSelected = 0
							end
						end
					end
				end
			end
		end
	end
end

function dealWithTheAnswers()
	answersR3 = {}
	local answ = {}
	for i=1,4 do
		local sample = wall1[(4*(i-1))+1]
		if chosenWall == 2 then
			sample = wall2[(4*(i-1))+1]
		end
		--we have questionsR3X and groupsR3X
		for j=1,4 do
			for k=1,4 do
				if chosenWall == 1 then
					--print(sample,questionsR31[j][k])
					if sample == questionsR31[j][k] then
						--print(i,groupsR31[i])
						table.insert(answ,groupsR31[j])
					end
				else
					if sample == questionsR32[j][k] then
						table.insert(answ,groupsR32[j])
					end
				end
			end
		end
	end
	if #answ > 4 then
		for i=1,16,4 do
			table.insert(answersR3,answ[i])
		end
	else
		for i=1,4 do
			table.insert(answersR3,answ[i])
		end
	end
end

function doTheMovement(row)
	currentLocs = {}
	otherLocs = {}
	otherIndexes = {}
	for k=1,4 do
		table.insert(otherIndexes,((row-1)*4)+k)
	end
	for k=1,4 do
		local z = selectedIndexes[k]
		table.insert(currentLocs,{z%4,math.ceil(z/4)})
		if currentLocs[k][1]==0 then currentLocs[k][1]=4 end
		local y = otherIndexes[k]
		table.insert(otherLocs,{y%4,math.ceil(y/4)})
		if otherLocs[k][1]==0 then otherLocs[k][1]=4 end
	end
	table.sort(selectedIndexes)
	for k=1,4 do
		local x1 = currentLocs[k][1]
		x1 = 15+(190*(x1-1))
		local x2 = otherLocs[k][1]
		x2 = 15+(190*(x2-1))
		local y1 = currentLocs[k][2]
		y1 = 10+(145*(y1-1))
		local y2 = otherLocs[k][2]
		y2 = 10+(145*(y2-1))
		movementTweens[selectedIndexes[k]] = {newTween(x2-x1,0,0.25),newTween(y2-y1,0,0.25)}
		movementTweens[otherIndexes[k]] = {newTween(x1-x2,0,0.25),newTween(y1-y2,0,0.25)}
		if chosenWall == 1 then
			wall1[selectedIndexes[k]],wall1[otherIndexes[k]] = wall1[otherIndexes[k]],wall1[selectedIndexes[k]]
		else
			wall2[selectedIndexes[k]],wall2[otherIndexes[k]] = wall2[otherIndexes[k]],wall2[selectedIndexes[k]]
		end
		chosen[selectedIndexes[k]],chosen[otherIndexes[k]] = chosen[otherIndexes[k]],chosen[selectedIndexes[k]]
		colourTweens[selectedIndexes[k]][1],colourTweens[selectedIndexes[k]][2],colourTweens[selectedIndexes[k]][3],colourTweens[otherIndexes[k]][1],colourTweens[otherIndexes[k]][2],colourTweens[otherIndexes[k]][3] = colourTweens[otherIndexes[k]][1],colourTweens[otherIndexes[k]][2],colourTweens[otherIndexes[k]][3],colourTweens[selectedIndexes[k]][1],colourTweens[selectedIndexes[k]][2],colourTweens[selectedIndexes[k]][3] -- wow that's a whole lotta swapping
	end
end