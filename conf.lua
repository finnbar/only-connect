function love.conf(t)
	t.console = true
	t.title = "Only Connect"
	t.window.height = 650
	t.window.resizable = true
	--t.window.fullscreen = true
	t.window.fullscreentype = "desktop"
	t.window.width = (t.window.height/650)*800
end