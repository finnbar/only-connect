show = {}
local konamiii = {"up","up","down","down","left","right","left","right","b","a","space"}
local infinity = {"i","n","f","i","n","i","t","y","space"} --infinity
local glitch = {"g","l","t","h","r","space"} --glthr
local currentCode = konamiii
local position = 1
local codeString = ""

function show.load()
	-- a thing
	position = 1
end

function show.draw()
	-- draw the names etc in
	love.graphics.setColor(colours("background"))
	love.graphics.draw(rd,550*scale+xshift,115*scale,0,0.25*scale,0.25*scale)
	love.graphics.draw(rd,550*scale+xshift,315*scale,0,0.25*scale,0.25*scale)
	love.graphics.setColor(colours("blue",150))
	love.graphics.draw(rd,10*scale+xshift,115*scale,0,0.65*scale,0.25*scale)
	love.graphics.setColor(colours("purple",150))
	love.graphics.draw(rd,10*scale+xshift,315*scale,0,0.65*scale,0.25*scale)
	love.graphics.setColor(255,255,255)
	-- scaling
	if #teamaname<=8 then
		love.graphics.setFont(fonts[7])
		love.graphics.print(teamaname,50*scale+xshift,130*scale)
	else
		love.graphics.setFont(fonts[6])
		love.graphics.print(teamaname,50*scale+xshift,150*scale)
	end
	love.graphics.setFont(fonts[7])
	love.graphics.print(teama,600*scale+xshift,130*scale)
	-- MORE scaling
	if #teambname<=8 then
		love.graphics.setFont(fonts[7])
		love.graphics.print(teambname,50*scale+xshift,330*scale)
	else
		love.graphics.setFont(fonts[6])
		love.graphics.print(teambname,50*scale+xshift,350*scale)
	end
	love.graphics.setFont(fonts[7])
	love.graphics.print(teamb,600*scale+xshift,330*scale)
	love.graphics.setFont(fonts[5])
	-- KONAMICODE! see below
	love.graphics.printf(codeString,200*scale+xshift,500*scale,400*scale,"center")
end

function show.update(dt)
	if currentCode == konamiii then
		codeString = string.sub("KONAMICODE!",0,position-1)
	elseif currentCode == infinity then
		codeString = string.sub("INFINITY!",0,position-1)
	elseif currentCode == glitch then
		codeString = string.sub("WALLS!",0,position-1)
	end
end

function show.keypressed(key)
	-- if the full KONAMI CODE is entered, skip to the tiebreaker
	if key=="up" then
		if currentCode ~= konamiii then
			position = 1
		end
		currentCode = konamiii
	elseif key=="i" then
		if currentCode ~= infinity then
			position = 1
		end
		currentCode = infinity
	elseif key=="g" then
		if currentCode ~= glitch then
			position = 1
		end
		currentCode = glitch
	end
	if currentCode == konamiii then
		if key==konamiii[position] and position<11 then
			position = position + 1
		elseif position==11 then
			if key=="space" then
				print("KONAMICODE ACTIVATED")
				roundIndex=whereAreTheRounds[5]
				tie.load()
				position = 1
			elseif key=="1" and roundIndex<whereAreTheRounds[1] then
				print("KONAMICODE ACTIVATED")
				roundIndex=whereAreTheRounds[1]
				r1.load()
				position = 1
			elseif key=="2" and roundIndex<whereAreTheRounds[2] then
				print("KONAMICODE ACTIVATED")
				roundIndex=whereAreTheRounds[2]
				r2.load()
				position = 1
			elseif key=="3" and roundIndex<whereAreTheRounds[3] then
				print("KONAMICODE ACTIVATED")
				roundIndex=whereAreTheRounds[3]
				r3.load()
				position = 1
			elseif key=="4" and roundIndex<whereAreTheRounds[4] then
				print("KONAMICODE ACTIVATED")
				roundIndex=whereAreTheRounds[4]
				r4.load()
				position = 1
			end
		else
			position = 1
			if key=="space" then return true end
		end
	elseif currentCode == infinity then
		if key==infinity[position] and position < 9 then
			position = position + 1
		elseif position == 9 then
			if key=="1" then
				print("Infinity lives for "..teamaname)
				teamacheats[1] = true
			elseif key=="2" then
				print("Infinity lives for "..teambname)
				teambcheats[1] = true
			end
			position = 1
		else
			position = 1
			if key=="space" then return true end
		end
	elseif currentCode == glitch then
		if key==glitch[position] and position < 6 then
			position = position + 1
		elseif position == 6 then
			if key=="1" then
				print("Glitch through walls for "..teamaname)
				teamacheats[2] = true
			elseif key=="2" then
				print("Glitch through walls for "..teambname)
				teambcheats[2] = true
			end
			position = 1
		else
			position = 1
			if key=="space" then return true end
		end
	end
end

function show.mousepressed(x,y,b)
	if b==1 then return true end
end
