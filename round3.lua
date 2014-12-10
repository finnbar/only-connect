r3 = {}

-- THE BIG BIG ONE
-- IT'S SO BIG THAT IT'S... I DUNNO

-- IDEAS:
-- Actually make it work (maybe important)

chosenWall = 0 -- 1=lion, 2=water, 0=hmmm....
selectionR3 = {false,false}
tweening = 0
wall1 = {}
wall2 = {}
chosen = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
paint = 1
numberOfSelected = 0
lives = 3
life = love.graphics.newImage("assets/life.png")
timer = 150
isItDone = false

function r3.load()
	-- a thing
	r = newTween(119,183,1,0)
	g = newTween(197,214,1,0)
	b = newTween(215,237,1,0)
	s = newTween(0,0.25,0.25)
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

function randSort(t) -- THANKS THE INTERNET!
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
		love.graphics.draw(rd,190,200,0,0.25,0.25)
		if tweening == 2 then
			love.graphics.setColor(val(r),val(g),val(b))
		elseif selectionR3[2] then
			love.graphics.setColor(colours("selected"))
		else
			love.graphics.setColor(colours("unselected"))
		end
		love.graphics.draw(rd,390,200,0,0.25,0.25)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(heiroglyphs["lion"],190,200)
		love.graphics.draw(heiroglyphs["water"],390,200)
	else
		for i=1,4 do
			for j=1,4 do
				current = i + (j-1)*4
				if chosen[current] == 0 then
					love.graphics.setColor(colours("background"))
				elseif chosen[current] == 1 then
					love.graphics.setColor(colours("blue"))
				elseif chosen[current] == 2 then
					love.graphics.setColor(colours("green"))
				elseif chosen[current] == 3 then
					love.graphics.setColor(colours("purple"))
				elseif chosen[current] == 4 then
					love.graphics.setColor(colours("greenblue"))
					--fancy bgs
				end
				if movementTweens[current]~=0 then
					love.graphics.draw(rd,15+(190*(i-1))+val(movementTweens[current][1]),10+(145*(j-1))+val(movementTweens[current][2]),0,0.25,val(s))
				else
					love.graphics.draw(rd,15+(190*(i-1)),10+(145*(j-1)),0,0.25,val(s))
				end
				love.graphics.setColor(0,0,0)
				if chosenWall==1 then
					love.graphics.printf(wall1[current],65+(190*(i-1)),20+(145*(j-1)),100,"center")
				else
					love.graphics.printf(wall2[current],65+(190*(i-1)),20+(145*(j-1)),100,"center")
				end
			end
		end
		love.graphics.setColor(255,255,255)
		if paint==3 then
			for i=1,lives do
				love.graphics.draw(life,540+(i*60),590,0,0.75,0.75)
			end
		end
		love.graphics.setColor(colours("unselected"))
		love.graphics.rectangle("fill",20,600,(150-timer)*(500/150),30)
		love.graphics.setColor(colours("selected"))
		love.graphics.rectangle("fill",20+(150-timer)*(500/150),600,20+500-((150-timer)*(400/150)),30)
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
		end
		if not isItDone then
			timer = timer - dt
		end
	end
end

function r3.keypressed(key)

end

function r3.mousepressed(x,y,button)
	if chosenWall == 0 then
		if x>=190 and x<=390 and y>=200 and y<=350 then
			if tweening == 1 then
				--ACTIVATE!
				selectionR3[1] = true
				chosenWall = 1
				s = newTween(0,0.25,0.25)
				lives = 3
				isItDone = false
			else
				tweening = 1
			end
		elseif x>=390 and x<=590 and y>=200 and y<=350 then
			if tweening == 2 then
				--ACTIVATE
				selectionR3[2] = true
				chosenWall = 2
				s = newTween(0,0.25,0.25)
				lives = 3
				isItDone = false
			else
				tweening = 2
			end
		end
	else
		if not isItDone then
		--ok, clicking the things....
			for i=1,4 do
				for j=1,4 do
					current = i + (4*(j-1))
					if x>=15+(190*(i-1)) and x<=15+(190*(i)) and y>=10+(145*(j-1)) and y<=10+(145*(j)) then
						if chosen[current]==paint then
							chosen[current] = 0
							numberOfSelected = numberOfSelected - 1
						elseif chosen[current]==0 then
							chosen[current] = paint
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
										doTheMovement()
										paint = paint + 1
										--love.graphics.draw(rd,15+(190*(i-1)),10+(145*(j-1)),0,0.25,val(s))
									else
										doTheMovement()
										paint = 4
										for z=1,16 do
											if chosen[z]==0 then chosen[z]=4 end
										end
										isItDone = true
									end
								else
									--oh no it's wrong
									for i=1,16 do
										if chosen[i] == paint then
											chosen[i]=0
										end
									end
									if paint == 3 then
										lives = lives - 1
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

function doTheMovement()
	currentLocs = {}
	otherLocs = {}
	otherIndexes = {}
	for k=1,4 do
		table.insert(otherIndexes,((paint-1)*4)+k)
	end
	for k=1,4 do
		local z = selectedIndexes[k]
		table.insert(currentLocs,{z%4,math.ceil(z/4)})
		if currentLocs[k][1]==0 then currentLocs[k][1]=4 end
		local y = otherIndexes[k]
		table.insert(otherLocs,{y%4,math.ceil(y/4)})
		if otherLocs[k][1]==0 then otherLocs[k][1]=4 end
	end
	-- THERE IS A BUG. THAT IS ALL.
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
	end
end