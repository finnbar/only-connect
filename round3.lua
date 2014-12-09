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

function r3.load()
	-- a thing
	r = newTween(119,183,1,0)
	g = newTween(197,214,1,0)
	b = newTween(215,237,1,0)
	s = newTween(0,0.25,0.25)
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
				love.graphics.draw(rd,15+(190*(i-1)),10+(145*(j-1)),0,0.25,val(s))
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
			else
				tweening = 2
			end
		end
	else
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
									paint = paint + 1
								else
									paint = 4
									for z=1,16 do
										if chosen[z]==0 then chosen[z]=4 end
									end
								end
							else
								--oh no it's wrong
								for i=1,16 do
									if chosen[i] == paint then
										chosen[i]=0
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