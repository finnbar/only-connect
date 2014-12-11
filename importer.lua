function importer(filename) -- let's import some questions yeah
	--answers = love.filesystem.read("exampleQuestions.txt")
	picturesR1 = {love.graphics.newImage(filename.."/1a.jpg"),love.graphics.newImage(filename.."/1b.jpg"),love.graphics.newImage(filename.."/1c.jpg"),love.graphics.newImage(filename.."/1d.jpg")}
	audioR1 = {love.audio.newSource(filename.."/1a.mp3"),love.audio.newSource(filename.."/1b.mp3"),love.audio.newSource(filename.."/1c.mp3"),love.audio.newSource(filename.."/1d.mp3")}
	picturesR2 = {love.graphics.newImage(filename.."/2a.jpg"),love.graphics.newImage(filename.."/2b.jpg"),love.graphics.newImage(filename.."/2c.jpg"),love.graphics.newImage(filename.."/2d.jpg")}
	questionsR1 = {}
	groupsR1 = {}
	questionsR2 = {}
	groupsR2 = {}
	questionsR31 = {}
	groupsR31 = {}
	questionsR32 = {}
	groupsR32 = {}
	questionsR4 = {}
	groupsR4 = {}
	errorStr = "" -- because debugging on a school laptop means random error()s rather than serious debug console stuff
	for line in love.filesystem.lines(filename.."/questions.txt") do
		if not (string.match(line,"^%|") or line == "\n" or line == "") then
			-- now I need to search for the tilda and grab the text before it.
			if string.sub(line,1,1) ~= "$" then
				-- let's check for special characters:
				if string.sub(line,1,1) == "*" then
					--error("PICTURE "..line)
					if #groupsR1<6 then
						pictureR1 = #groupsR1+1
					else
						pictureR2 = #groupsR2+1
					end
					line = string.sub(line,2,-1)
				elseif string.sub(line,1,1) == "^" then
					--error("MUSIC "..line)
					musicR1 = #groupsR1+1
					line = string.sub(line,2,-1)
				end
				ans = string.match(line,"[%s%S]+~")
				rem = string.sub(line,#ans,-1)
				ans = string.sub(ans,0,#ans-1) -- this takes the tilda off
				-- ok so now find rem's ; and take the text before that as q1
				errorStr = errorStr .. ans .. ":"
				rem = string.sub(rem,2)
				q = {}
				for i=1,3 do
					n = string.match(rem,"^[%s%S]-;")
					n = string.sub(n,0,-2)
					table.insert(q,n)
					errorStr = errorStr .. n .. ","
					rem = string.sub(rem,#q[i]+2,-1)
				end
				table.insert(q,rem)
				errorStr = errorStr .. rem .. ". "
				-- OK LINE COMPLETE, NOW PUT IN THE RIGHT PLACE
				--error(q[1]..","..q[2]..","..q[3]..","..q[4])
				if #groupsR1 < 6 then
					table.insert(questionsR1,q)
					table.insert(groupsR1,ans)
				elseif #groupsR2 < 6 then
					table.insert(questionsR2,q)
					table.insert(groupsR2,ans)
				elseif #groupsR31 < 4 then
					table.insert(questionsR31,q)
					table.insert(groupsR31,ans)
				elseif #groupsR32 < 4 then
					table.insert(questionsR32,q)
					table.insert(groupsR32,ans)
				else
					for i=1,4 do
						table.insert(questionsR4,q[i])
					end
					table.insert(groupsR4,ans)
				end
			else
				tiebreakerTopic = string.match(line,"[%s%S]+~")
				tiebreakerAnswer = string.sub(line,#tiebreakerTopic+1,-1)
				tiebreakerTopic = string.sub(tiebreakerTopic,2,#tiebreakerTopic-1)
				--error(tiebreakerQuestion..": "..tiebreakerAnswer)
			end
		end
	end
	-- and some more stuff
	-- error(errorStr)
end