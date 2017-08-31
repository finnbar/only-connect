r4 = {}

local round4 = love.graphics.newImage("assets/round4.png") -- I wrote this round before thinking of the rounded rectangle method, so we have this instead
local questionNum = 1
local answersR4 = {}
local answered = false
local timerR4 = 10
local newTopic = true

local function moveOn(force)
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
	end
	if questionNum > #questionsR4 then
		return true
	end
	return false
end

function r4.load()
	for q in pairs(questionsR4) do
		-- so we need to convert the answers into questions
		table.insert(answersR4,questionsR4[q])
		questionsR4[q] = string.upper(questionsR4[q])
		-- remove spaces and vowels, bracketed things and non-letters
		questionsR4[q] = string.gsub(questionsR4[q],"[AEIOU ]","")
		questionsR4[q] = string.gsub(questionsR4[q],"%b()","")
		questionsR4[q] = string.gsub(questionsR4[q],"%W+","")
		finalFormat = {} -- not to be confused with Final Fantasy
		-- split the words into groups of three
		for i=1,#questionsR4[q],3 do
			table.insert(finalFormat,questionsR4[q]:sub(i,i+2))
		end
		questionsR4[q] = ""
		-- and feed them into the question
		for i=1,#finalFormat do
			questionsR4[q] = questionsR4[q]..finalFormat[i].." "
		end
	end
	for q in pairs(answersR4) do
		answersR4[q] = string.upper(answersR4[q])
	end
end

function r4.draw()
	love.graphics.setFont(fonts[5])
	love.graphics.draw(round4,xshift,0,0,scale,scale) -- this is the backdrop, essentially
	groupname = groupsR4[math.ceil((questionNum)/4)]
	if groupname == nil then
		return true
	end
	love.graphics.printf(groupname,50*scale+xshift,130*scale,700*scale,"center") -- this is the heading, essentially
	-- print the answer/questions
	if answered then
		love.graphics.printf(answersR4[questionNum],50*scale+xshift,210*scale,700*scale,"center")
	elseif not newTopic then
		love.graphics.printf(questionsR4[questionNum],50*scale+xshift,210*scale,700*scale,"center")
		-- and timer?!
		love.graphics.printf(math.ceil(timerR4),350*scale+xshift,400*scale,100*scale,"center")
	end
end

-- timer!
function r4.update(dt)
	if highlightingBg==0 and (not answered) then
		-- only if noone has buzzed in
		timerR4 = timerR4 - dt
		if timerR4<0 then
			timerR4 = 10
			-- moveOn(true) is continue, whatever
			-- moveOn(false) is just continue unless the answer's not revealed yet, as we'd like to wait for a buzz in first
			if moveOn(true) then return true end
		end
	end
end

function r4.keypressed(key)
	-- buzzing!
	if not newTopic then
		keys = {teamakey, teambkey}
		for i=1,2 do
			if key==keys[i] and highlightingBg==0 and (not answered) then
				highlightingBg = i
				buzzIn(i)
			end
		end
	end
	-- agreeing!
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
	-- disagreeing!
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
	-- continuing on!
	if key=="space" then
		if moveOn() then return true end
		if highlightingBg==0 and (not answered) then
			timerR4 = 10
		end
	end
end
