-- Tween.lua, a very basic tween library, written by Finnbar Keating

-- tween like you've never tweened before! ...how do you tween?
-- In all seriousness, this library helps smooth movement.
-- You give it a set of values to move through in a certain time, and it does that.
-- newTween() creates a new tween
-- updateTween() MUST be run during the update loop otherwise it will not move.
-- val() just returns the value of the tween at this given point in time.

function newTween(start,stop,dur,reverse)
	if reverse==nil then reverse = false end
	return {start,stop,dur,reverse,0} -- 5th value is time passed (relative to dur)
end

function updateTween(t,dt) --DELTA TIME!
	if not t[4] then
		if math.abs(t[5])<(t[3]) then
			t[5]=t[5]+dt
		else
			t[5]=t[3]
		end
		if t[5]>t[3] then t[5]=t[3] end
	else
		if t[4]==0 then
			t[5]=t[5]+dt
		else
			t[5]=t[5]-dt
		end
	end
	-- now check reverse
	if t[4] then
		if t[5]>t[3] then
			t[4]=1
		elseif t[5]<0 then
			t[4]=0
		end
	end
end

function val(t)
	dif = t[2]-t[1]
	perc = t[5]/t[3]
	return t[1] + (perc*dif)
end