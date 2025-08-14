local hk, app, win, screen = hs.hotkey, hs.application, hs.window, hs.screen

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

-- 1) App jumpers
hk.bind({ "ctrl", "shift" }, "return", function()
	app.launchOrFocusByBundleID("net.kovidgoyal.kitty")
end)
hk.bind({ "ctrl", "shift" }, "w", function()
	app.launchOrFocusByBundleID("com.apple.Safari")
end)
hk.bind({ "ctrl", "shift" }, "s", function()
	app.launchOrFocusByBundleID("com.tinyspeck.slackmacgap")
end)
hk.bind({ "ctrl", "shift" }, "b", function()
	app.launchOrFocusByBundleID("org.mozilla.firefox")
end)
hk.bind({ "ctrl", "shift" }, "p", function()
	app.launchOrFocusByBundleID("com.spotify.client")
end)

hk.bind({ "ctrl", "shift" }, "1", function()
	app.launchOrFocusByBundleID("com.apple.Safari")
end)
hk.bind({ "ctrl", "shift" }, "2", function()
	app.launchOrFocusByBundleID("net.kovidgoyal.kitty")
end)
hk.bind({ "ctrl", "shift" }, "3", function()
	app.launchOrFocusByBundleID("com.tinyspeck.slackmacgap")
end)
hk.bind({ "ctrl", "shift" }, "0", function()
	app.launchOrFocusByBundleID("org.mozilla.firefox")
end)
hk.bind({ "ctrl", "shift" }, "9", function()
	app.launchOrFocusByBundleID("com.todoist.mac.Todoist")
end)
hk.bind({ "ctrl", "shift" }, "8", function()
	app.launchOrFocusByBundleID("com.spotify.client")
end)

-- Helpers for sizing
local function centerAlmostFull(w, m)
	w = w or win.focusedWindow()
	m = m or 48
	local f = w:screen():frame()
	w:setFrame({ x = f.x + m, y = f.y + m, w = f.w - 2 * m, h = f.h - 2 * m })
end
local function maximize(w)
	(w or win.focusedWindow()):maximize()
end

-- 2) Apply profile on display changes: external -> center w/ gaps; laptop -> maximize
local function maximizeAll()
	hs.alert.show("Applying - Maximize")
	for _, w in ipairs(win.visibleWindows()) do
		maximize(w)
	end
end
local function centerAlmostFullAll()
	hs.alert.show("Applying - Almost Full")
	for _, w in ipairs(win.visibleWindows()) do
		centerAlmostFull(w, 48)
	end
end

hk.bind({ "ctrl", "alt", "cmd" }, "n", centerAlmostFullAll)
hk.bind({ "ctrl", "alt", "cmd" }, "m", maximizeAll)

-- Little utility to get app IDs
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "I", function()
	local id = hs.application.frontmostApplication():bundleID()
	hs.alert.show(id)            -- pops a toast on screen
	hs.pasteboard.setContents(id) -- also copies it to the clipboard
end)
