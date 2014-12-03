r4 = {}

round4 = love.graphics.newImage("assets/round4.png")
topics = {"Things","Whatsits","Netrunner Cards"}
questionsR4 = {"Thing","Another Thing","Too many things","Thing Two the sequel","Quavers","Mars","Walkers","Walkies","Sure Gamble","Ice Wall","Magnum Opus","Astroscript Pilot Program"}
answersR4 = {"Thing","Another Thing","Too many things","Thing Two the sequel","Quavers","Mars","Walkers","Walkies","Sure Gamble","Ice Wall","Magnum Opus","Astroscript Pilot Program"}
questionNum = 1
answered = false
timer = 150

function r4.load()
	for q in pairs(questionsR4) do
		questionsR4[q] = string.upper(questionsR4[q])
		questionsR4[q] = string.gsub(questionsR4[q]," ","")
		questionsR4[q] = string.gsub(questionsR4[q],"A","")
		questionsR4[q] = string.gsub(questionsR4[q],"E","")
		questionsR4[q] = string.gsub(questionsR4[q],"I","")
		questionsR4[q] = string.gsub(questionsR4[q],"O","")
		questionsR4[q] = string.gsub(questionsR4[q],"U","")
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
	love.graphics.printf(topics[math.ceil((questionNum)/4)],50,130,700,"center")
	if answered then
		love.graphics.printf(answersR4[questionNum],50,210,700,"center")
	else
		love.graphics.printf(questionsR4[questionNum],50,210,700,"center")
	end
end

function r4.update(dt)
	timer = timer - dt
	if timer<0 then
		return true
	end
end

function r4.keypressed(key)
	if key==" " then
		if answered then
			questionNum = questionNum + 1
			answered = false
		else
			answered = true
		end
		if questionNum > #questionsR4 then
			return true
		end
	end
end

function r4.mousepressed(x,y,button)
	if button == "l" then
		if answered then
			questionNum = questionNum + 1
			answered = false
		else
			answered = true
		end
		if questionNum > #questionsR4 then
			return true
		end
	end
end