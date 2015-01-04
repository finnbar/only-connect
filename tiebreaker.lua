tie = {}

round4Continued = love.graphics.newImage("assets/round4.png")
panic = true
state = 0 -- 0: "Tiebreaker", 1: Question, 2: Answered

-- pretty much round 4 but much simpler

function tie.load()
	-- a thing
	tiebreakerAnswer = string.upper(tiebreakerAnswer)
	tiebreakerQuestion = string.gsub(tiebreakerAnswer,"A","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"E","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"I","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"O","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"U","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"%b()","")
	tiebreakerQuestion = string.gsub(tiebreakerQuestion,"%W+","")
	finalFormat = {}
	for i=1,#tiebreakerQuestion,3 do
		table.insert(finalFormat,tiebreakerQuestion:sub(i,i+2))
	end
	tiebreakerQuestion = ""
	for i=1,#finalFormat do
		tiebreakerQuestion = tiebreakerQuestion..finalFormat[i].." "
	end
	panicTween = newTween(0,4000,3)
end

function tie.draw()
	if panic then
		--draw panic animation. probably not a thing unless I find a lot of time
		--SCRATCH THAT IT'S A THING
		--I don't need to do xshift stuff to this as it scrolls across the whole screen anyway
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill",0,0,1000*xscale,1000*scale)
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(fonttttttttt)
		love.graphics.print("TIEBREAKER!!!",(300-val(panicTween))*scale,10*scale)
		love.graphics.setFont(fontttt)
		love.graphics.print("TIES",(700-(val(panicTween)*0.5)*scale),5*scale)
		love.graphics.print("BREAKING THINGS",(1000-(val(panicTween)*0.7)*scale),60*scale)
		love.graphics.print("KNOTS",(2200-(val(panicTween)*0.8)*scale),530*scale)
		love.graphics.print("PANIC",(1950-(val(panicTween)*0.7)*scale),570*scale)
		love.graphics.print("SUDDEN DEATH",(1450-(val(panicTween)*0.9))*scale,570*scale)
		love.graphics.print("A LACK OF VOWELS",(1300-(val(panicTween)*0.7))*scale,20*scale)
		love.graphics.print("THE FINAL COUNTDOWN",(700-(val(panicTween)*0.8))*scale,590*scale)
		love.graphics.print("CONNECTING",(2300-(val(panicTween)*0.9))*scale,10*scale)
		love.graphics.print("SERIOUS BUSINESS",(2400-(val(panicTween)*0.7))*scale,580*scale)
		love.graphics.print("THE FINALE",(2200-(val(panicTween)*0.6)*scale),20*scale)
		if val(panicTween)>=panicTween[2] then panic = false end
		--above: directly messing with the tween lib there as tween[2] == end of tween
	else
		love.graphics.setFont(fontttt)
		love.graphics.draw(round4,xshift,0,0,scale,scale)
		love.graphics.printf(tiebreakerTopic,50*scale+xshift,130*scale,700*scale,"center")
		love.graphics.setFont(fonttt)
		if state == 1 then
			love.graphics.printf(tiebreakerQuestion,50*scale+xshift,220*scale,700*scale,"center")
		elseif state == 2 then
			love.graphics.printf(tiebreakerAnswer,50*scale+xshift,220*scale,700*scale,"center")
		end
	end
end

function tie.update(dt)
	if panic then
		updateTween(panicTween,dt)
	end
end

function tie.keypressed(key)
	if not panic then
		if key==" " then
			if state==2 then return true end
			state = 1
			slide()
		end
		if key==teamakey and highlightingBg==0 and state==1 then
			highlightingBg = 1
			buzzIn(1)
		end
		if key==teambkey and highlightingBg==0 and state==1 then
			highlightingBg = 2
			buzzIn(2)
		end
		if key=="up" and highlightingBg~=0 then
			if highlightingBg == 1 then
				teama = teama + 1
			else
				teamb = teamb + 1
			end
			state = 2
			highlightingBg = 0
			slide()
		end
		if key=="down" and highlightingBg~=0 then
			if highlightingBg == 1 then
				teamb = teamb + 1
			else
				teama = teama + 1
			end
			state = 2
			highlightingBg = 0
			slide()
		end
	end
end