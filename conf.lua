function love.conf(t)
	t.console = true
	t.title = "Only Connect"
	t.window.height = 650
	t.window.resizable = true
	--t.window.fullscreen = true
	t.window.fullscreentype = "desktop"
	t.window.width = (t.window.height/650)*800
	t.modules.joystick = false
	t.modules.physics = false
	t.modules.thread = false
	t.modules.system = false
end