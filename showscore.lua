show = {}
konamiii = {"up","up","down","down","left","right","left","right","b","a"," "}
position = 1

function show.load()
	-- a thing
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
	love.graphics.setFont(fonttttt)
	love.graphics.print(teamaname,50*scale,130*scale)
	love.graphics.print(teama,600*scale,130*scale)
	love.graphics.print(teambname,50*scale,330*scale)
	love.graphics.print(teamb,600*scale,330*scale)
end

function show.update(dt)

end

function show.keypressed(key)
	if key==konamiii[position] then
		if position==11 then
			roundIndex=9
			tie.load()
			return true
		else
			position = position + 1
		end
	elseif key==" " then return true end
end

function show.mousepressed(x,y,b)
	if b=="l" then return true end
end