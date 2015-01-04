show = {}
konamiii = {"up","up","down","down","left","right","left","right","b","a"," "}
position = 1
konamiiiString = ""

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
		love.graphics.setFont(fonttttt)
		love.graphics.print(teamaname,50*scale+xshift,130*scale)
	else
		love.graphics.setFont(fontttttS)
		love.graphics.print(teamaname,50*scale+xshift,150*scale)
	end
	love.graphics.setFont(fonttttt)
	love.graphics.print(teama,600*scale+xshift,130*scale)
	-- MORE scaling
	if #teambname<=8 then
		love.graphics.setFont(fonttttt)
		love.graphics.print(teambname,50*scale+xshift,330*scale)
	else
		love.graphics.setFont(fontttttS)
		love.graphics.print(teambname,50*scale+xshift,350*scale)
	end
	love.graphics.setFont(fonttttt)
	love.graphics.print(teamb,600*scale+xshift,330*scale)
	love.graphics.setFont(fontttt)
	-- KONAMICODE! see below
	love.graphics.printf(konamiiiString,200*scale+xshift,500*scale,400*scale,"center")
end

function show.update(dt)
	konamiiiString = string.sub("KONAMICODE!",0,position-1)
end

function show.keypressed(key)
	-- if the full KONAMI CODE is entered, skip to the tiebreaker
	if key==konamiii[position] and position<11 then
		position = position + 1
	elseif position==11 then
		if key==" " then
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
		if key==" " then return true end
	end
end

function show.mousepressed(x,y,b)
	if b=="l" then return true end
end