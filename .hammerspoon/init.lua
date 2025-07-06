hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	hs.alert.show("Hello World!")
end)

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "C", function()
	local screen = hs.screen.mainScreen()
	local f = screen:fullFrame()
	hs.mouse.setAbsolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
end)

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "U", function()
	local screen = hs.screen.mainScreen()
	local f = screen:fullFrame()
	hs.mouse.setAbsolutePosition({ x = f.x, y = f.y })
end)

-- Center all visible windows
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "H", function()
	for _, win in ipairs(hs.window.visibleWindows()) do
		local frame = win:frame()
		local screenFrame = win:screen():frame()
		frame.x = screenFrame.x + (screenFrame.w - frame.w) / 2
		frame.y = screenFrame.y + (screenFrame.h - frame.h) / 2
		win:setFrame(frame)
	end
	hs.alert.show("Windows centered")
end)
