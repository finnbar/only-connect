r4 = {}

round4 = love.graphics.newImage("assets/round4.png")
topics = {"Things","Whatsits"}
questions = {"Thing","Another Thing","Too many things","Thing Two the sequel","Quavers","Mars","Walkers","Walkies"}
answers = {"Thing","Another Thing","Too many things","Thing Two the sequel","Quavers","Mars","Walkers","Walkies"}
questionNum = 1
answered = false
timer = 150

function r4.load()
	for q in pairs(questions) do
		questions[q] = string.upper(questions[q])
		questions[q] = string.gsub(questions[q]," ","")
		questions[q] = string.gsub(questions[q],"A","")
		questions[q] = string.gsub(questions[q],"E","")
		questions[q] = string.gsub(questions[q],"I","")
		questions[q] = string.gsub(questions[q],"O","")
		questions[q] = string.gsub(questions[q],"U","")
		finalFormat = {}
		for i=1,#questions[q],3 do
			table.insert(finalFormat,questions[q]:sub(i,i+2))
		end
		questions[q] = ""
		for i=1,#finalFormat do
			questions[q] = questions[q]..finalFormat[i].." "
		end
	end
	for q in pairs(answers) do
		answers[q] = string.upper(answers[q])
	end
end

function r4.draw()
	love.graphics.draw(round4,0,0)
	love.graphics.printf(topics[math.ceil((questionNum)/4)],50,130,700,"center")
	if answered then
		love.graphics.printf(answers[questionNum],50,210,700,"center")
	else
		love.graphics.printf(questions[questionNum],50,210,700,"center")
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
		if questionNum > #questions then
			return true
		end
	end
end