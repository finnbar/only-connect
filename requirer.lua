require "round1"
require "round2"
require "round3"
require "round4"
require "showscore"
require "tiebreaker" --very serious business
require "tween"
require "importer"

bg = love.graphics.newImage("assets/oclogo.png")

rd = love.graphics.newImage("assets/rounded.png") -- the ONE rounded rectangle, which is kinda important y'know yeah, see below

--[[
love.graphics.draw(rd,0,0,0,0.75,0.2)
-- this consists of object (obv. rd), x, y, rotation, xscale (where 1 fills the screen), yscale
]]

colList = {purple={91,0,117},blue={8,83,207},green={13,145,99},greenblue={13,127,131},unselected={18,49,103},selected={183,214,237},transition={119,197,215},background={191,225,250}}

function colours(name,alpha)
	if alpha==nil then alpha=255 end
	return {colList[name][1],colList[name][2],colList[name][3],alpha}
end

font = love.graphics.newFont("assets/RopaSans-Regular.ttf",12)
fonttt = love.graphics.newFont("assets/RopaSans-Regular.ttf",40)
fontttt = love.graphics.newFont("assets/RopaSans-Regular.ttf",50)
fonttttt = love.graphics.newFont("assets/RopaSans-Regular.ttf",100) -- aka big font

--[[ NOTE TO SELF: order of heiroglyphs is
Reeds, Lion, Twisted,
Viper, Water, Eye.
]]

heiroglyphs = {reeds=love.graphics.newImage("assets/reeds.png"),lion=love.graphics.newImage("assets/lion.png"),twisted=love.graphics.newImage("assets/twisted.png"),viper=love.graphics.newImage("assets/viper.png"),water=love.graphics.newImage("assets/water.png"),eye=love.graphics.newImage("assets/eye.png")}

buzzer1 = love.audio.newSource("assets/onlyConnect1buzz.mp3")
buzzer2 = love.audio.newSource("assets/onlyConnect2buzz.mp3")
pressSound = love.audio.newSource("assets/click.mp3")
slideSound = love.audio.newSource("assets/slice.mp3")
slideLong = love.audio.newSource("assets/slicelong.mp3")
bad = love.audio.newSource("assets/bad.mp3")
worse = love.audio.newSource("assets/worse.mp3")
bad:setVolume(0.1)
worse:setVolume(0.1)