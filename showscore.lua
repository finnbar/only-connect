show = {}
konamiii = {"up","up","down","down","left","right","left","right","b","a"," "}
position = 1
konamiiiString = ""

function show.load()
	-- a thing
	position = 1
end

function show.draw()

	-- NEXT ADD GRAPHICS (coloured rounded squares behind the names)
	love.graphics.setColor(colours("background"))
	love.graphics.draw(rd,550*scale,115*scale,0,0.25*scale,0.25*scale)
	love.graphics.draw(rd,550*scale,315*scale,0,0.25*scale,0.25*scale)
	love.graphics.setColor(colours("blue",150))
	love.graphics.draw(rd,10*scale,115*scale,0,0.65*scale,0.25*scale)
	love.graphics.setColor(colours("purple",150))
	love.graphics.draw(rd,10*scale,315*scale,0,0.65*scale,0.25*scale)
	love.graphics.setColor(255,255,255)
	if #teamaname<=8 then
		love.graphics.setFont(fonttttt)
		love.graphics.print(teamaname,50*scale,130*scale)
	else
		love.graphics.setFont(fontttttS)
		love.graphics.print(teamaname,50*scale,150*scale)
	end
	love.graphics.setFont(fonttttt)
	love.graphics.print(teama,600*scale,130*scale)
	if #teambname<=8 then
		love.graphics.setFont(fonttttt)
		love.graphics.print(teambname,50*scale,330*scale)
	else
		love.graphics.setFont(fontttttS)
		love.graphics.print(teambname,50*scale,350*scale)
	end
	love.graphics.setFont(fonttttt)
	love.graphics.print(teamb,600*scale,330*scale)
	love.graphics.setFont(fontttt)
	love.graphics.printf(konamiiiString,200*scale,500*scale,400*scale,"center")
end

function show.update(dt)
	konamiiiString = string.sub("KONAMICODE!",0,position-1)
end

function show.keypressed(key)
	if key==konamiii[position] then
		if position==11 then
			print("KCODE ACTIVATED")
			roundIndex=9
			tie.load()
			position = 1
		else
			position = position + 1
		end
	else
		position = 1
		if key==" " then return true end
	end
end

function show.mousepressed(x,y,b)
	if b=="l" then return true end
end