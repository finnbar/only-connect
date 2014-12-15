tie = {}

round4Continued = love.graphics.newImage("assets/round4.png")
panic = false
state = 0 -- 0: "Tiebreaker", 1: Question, 2: Answered

function tie.load()
	-- a thing
	tiebreakerAnswer = string.upper(tiebreakerAnswer)
	tiebreakerQuestion = string.gsub(tiebreakerAnswer,"A","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"E","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"I","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"O","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"U","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"%b()","")
	finalFormat = {}
	for i=1,#tiebreakerQuestion,3 do
		table.insert(finalFormat,tiebreakerQuestion:sub(i,i+2))
	end
	tiebreakerQuestion = ""
	for i=1,#finalFormat do
		tiebreakerQuestion = tiebreakerQuestion..finalFormat[i].." "
	end
end

function tie.draw()
	if panic then
		--draw panic animation. probably not a thing unless I find a lot of time
	else
		love.graphics.setFont(fontttt)
		love.graphics.draw(round4,0,0,0,scale,scale)
		love.graphics.printf(tiebreakerTopic,50*scale,130*scale,700*scale,"center")
		love.graphics.setFont(fonttt)
		if state == 1 then
			love.graphics.printf(tiebreakerQuestion,50*scale,220*scale,700*scale,"center")
		elseif state == 2 then
			love.graphics.printf(tiebreakerAnswer,50*scale,220*scale,700*scale,"center")
		end
	end
end

function tie.update(dt)

end

function tie.keypressed(key)
	if not panic then
		if key==" " then
			if state==2 then return true end
			state = 1
		end
		if key=="left" and highlightingBg==0 then
			highlightingBg = 1
		end
		if key=="right" and highlightingBg==0 then
			highlightingBg = 2
		end
		if key=="up" and highlightingBg~=0 then
			if highlightingBg == 1 then
				teama = teama + 1
			else
				teamb = teamb + 1
			end
			state = 2
			highlightingBg = 0
		end
		if key=="down" and highlightingBg~=0 then
			if highlightingBg == 1 then
				teamb = teamb + 1
			else
				teama = teama + 1
			end
			state = 2
			highlightingBg = 0
		end
	end
end