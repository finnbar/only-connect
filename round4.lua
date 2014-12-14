r4 = {}

round4 = love.graphics.newImage("assets/round4.png")
questionNum = 1
answersR4 = {}
answered = false
timerR4 = 10
newTopic = true

function r4.load()
	for q in pairs(questionsR4) do
		table.insert(answersR4,questionsR4[q])
		questionsR4[q] = string.upper(questionsR4[q])
		questionsR4[q] = string.gsub(questionsR4[q]," ","")
		questionsR4[q] = string.gsub(questionsR4[q],"A","")
		questionsR4[q] = string.gsub(questionsR4[q],"E","")
		questionsR4[q] = string.gsub(questionsR4[q],"I","")
		questionsR4[q] = string.gsub(questionsR4[q],"O","")
		questionsR4[q] = string.gsub(questionsR4[q],"U","")
		questionsR4[q] = string.gsub(questionsR4[q],"%b()","")
		finalFormat = {}
		for i=1,#questionsR4[q],3 do
			table.insert(finalFormat,questionsR4[q]:sub(i,i+2))
		end
		questionsR4[q] = ""
		for i=1,#finalFormat do
			questionsR4[q] = questionsR4[q]..finalFormat[i].." "
		end
	end
	for q in pairs(answersR4) do
		answersR4[q] = string.upper(answersR4[q])
	end
end

function r4.draw()
	love.graphics.setFont(fontttt)
	love.graphics.draw(round4,0,0)
	love.graphics.printf(groupsR4[math.ceil((questionNum)/4)],50,130,700,"center")
	if answered then
		love.graphics.printf(answersR4[questionNum],50,210,700,"center")
	elseif not newTopic then
		love.graphics.printf(questionsR4[questionNum],50,210,700,"center")
	end
end

function r4.update(dt)
	timerR4 = timerR4 - dt
	if timerR4<0 then
		timerR4 = 10
		if moveOn(true) then return true end
	end
end

function r4.keypressed(key)
	if not newTopic then
		if key=="left" and highlightingBg==0 and not answered then
			highlightingBg = 1
			buzzIn(1)
		end
		if key=="right" and highlightingBg==0 and not answered then
			highlightingBg = 2
			buzzIn(2)
		end
	end
	if key=="up" and highlightingBg~=0 then
		answered = true
		if highlightingBg == 1 then
			teama = teama + 1
		else
			teamb = teamb + 1
		end
		debugScorePrint()
		highlightingBg = 0
		swapped = false
		slide()
	end
	if key=="down" and highlightingBg~=0 then
		if not swapped then
			if highlightingBg == 1 then
				teama = teama - 1
				highlightingBg = 2
			else
				teamb = teamb - 1
				highlightingBg = 1
			end
			debugScorePrint()
			swapped = true
		else
			swapped = false
			highlightingBg = 0
			answered = true
			slide()
		end
	end
	if key==" " then
		if moveOn() then return true end
		timerR4 = 10
	end
end

function moveOn(force)
	if force==nil then force=false end
	if newTopic then
		newTopic = false
	else
		if answered then
			questionNum = questionNum + 1
			answered = false
			if questionNum%4 == 1 then
				newTopic = true
			end
			slide()
		elseif force then
			answered = true
			highlightingBg = 0
			slide()
		end
		if questionNum > #questionsR4 then
			return true
		end
	end
	return false
end

function r4.mousepressed(x,y,button)
	-- if button == "l" then
	-- 	if answered then
	-- 		questionNum = questionNum + 1
	-- 		answered = false
	-- 	else
	-- 		answered = true
	-- 	end
	-- 	if questionNum > #questionsR4 then
	-- 		return true
	-- 	end
	-- end
end