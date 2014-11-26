-- WELCOME TO ONLY CONNECT
-- THE ONLY SHOW ABOUT CONNECTING
-- YEAH

require "round1"
require "round2"
require "round3"
require "round4"
require "showscore"
require "tiebreaker" --very serious business

teama = 0
teamb = 0
rounds = {r1,show,r2,show,r3,show,r4,show,tie}
roundIndex = 7 -- TEMP USUALLY ZERO

bg = love.graphics.newImage("assets/oclogo.png")
fontttt = love.graphics.newFont("assets/RopaSans-Regular.ttf",50)

function love.load()
	-- a thing
	love.graphics.setFont(fontttt)
	if rounds[roundIndex] then rounds[roundIndex].load() end
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(bg,0,0)
	if roundIndex > 0 then
		if rounds[roundIndex].draw() then
			roundIndex = roundIndex + 1
			if rounds[roundIndex] then rounds[roundIndex].load() end
		end
	else
		--main menu jazz
	end
end

function love.update(dt)
	if roundIndex > 0 then
		if rounds[roundIndex].update(dt) then
			-- the round has ended IT HAS RETURNED TRUE
			roundIndex = roundIndex + 1
			if rounds[roundIndex] then rounds[roundIndex].load() end
		end
	else
		--main menu jazz
	end
end

function love.keypressed(key)
	if roundIndex > 0 then
		if rounds[roundIndex].keypressed(key) then
			roundIndex = roundIndex + 1
			if rounds[roundIndex] then rounds[roundIndex].load() end
		end
	else
		--main menu jazz
	end
end