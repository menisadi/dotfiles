local hk, app, win, screen = hs.hotkey, hs.application, hs.window, hs.screen

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	hs.alert.show("Hello World!")
end)

-- Move mouse to screen center / upper-left
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
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "M", function()
	for _, win in ipairs(hs.window.visibleWindows()) do
		local frame = win:frame()
		local screenFrame = win:screen():frame()
		frame.x = screenFrame.x + (screenFrame.w - frame.w) / 2
		frame.y = screenFrame.y + (screenFrame.h - frame.h) / 2
		win:setFrame(frame)
	end
	hs.alert.show("Windows centered")
end)

-- App jumpers
-- NOTE: Old bindings, kept (for now) for reference
-- hk.bind({ "ctrl", "shift" }, "return", function()
-- 	app.launchOrFocusByBundleID("net.kovidgoyal.kitty")
-- end)
-- hk.bind({ "ctrl", "shift" }, "w", function()
-- 	app.launchOrFocusByBundleID("com.apple.Safari")
-- end)
-- hk.bind({ "ctrl", "shift" }, "s", function()
-- 	app.launchOrFocusByBundleID("com.tinyspeck.slackmacgap")
-- end)
-- hk.bind({ "ctrl", "shift" }, "b", function()
-- 	app.launchOrFocusByBundleID("org.mozilla.firefox")
-- end)
-- hk.bind({ "ctrl", "shift" }, "p", function()
-- 	app.launchOrFocusByBundleID("com.spotify.client")
-- end)

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
	app.launchOrFocusByBundleID("com.mitchellh.ghostty")
end)
hk.bind({ "ctrl", "shift" }, "8", function()
	app.launchOrFocusByBundleID("com.todoist.mac.Todoist")
end)
hk.bind({ "ctrl", "shift" }, "7", function()
	app.launchOrFocusByBundleID("com.spotify.client")
end)

hk.bind({ "ctrl", "shift" }, "-", function()
	hs.alert.show("Oh dear, that's the wrong key!")
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

hk.bind({ "ctrl", "alt", "cmd" }, "b", centerAlmostFull)
hk.bind({ "ctrl", "alt", "cmd" }, "n", centerAlmostFullAll)
hk.bind({ "ctrl", "alt", "cmd" }, "m", maximizeAll)

-- Little utility to get app IDs
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "I", function()
	local id = hs.application.frontmostApplication():bundleID()
	hs.alert.show(id) -- pops a toast on screen
	hs.pasteboard.setContents(id) -- also copies it to the clipboard
end)

-- Add a keymap to show on screen all aveilable hammerspoon hotkeys
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "H", function()
	-- For now we will just show all hotkeys in an alert
	-- We also, for now, will simply list the hotkeys defined in this init.lua file
	-- We will improve this later
	local hotkeys = {
		"Cmd+Alt+Ctrl+W: Show Hello World alert",
		"Ctrl+Alt+Cmd+C: Move mouse to screen center",
		"Ctrl+Alt+Cmd+U: Move mouse to screen upper-left\n",
		"Ctrl+Shift+1: Launch Safari",
		"Ctrl+Shift+2: Launch Kitty",
		"Ctrl+Shift+3: Launch Slack",
		"Ctrl+Shift+0: Launch Firefox",
		"Ctrl+Shift+9: Launch Ghostty",
		"Ctrl+Shift+8: Launch Todoist",
		"Ctrl+Shift+7: Launch Spotify\n",
		"Ctrl+Alt+Cmd+B: Center focused window almost full",
		"Ctrl+Alt+Cmd+N: Center all visible windows almost full",
		"Ctrl+Alt+Cmd+M: Center all visible windows",
		"Ctrl+Alt+Cmd+M: Maximize all visible windows",
		"Ctrl+Alt+Cmd+I: Show frontmost app bundle ID\n",
		"Ctrl+Alt+Cmd+H: Show this help message",
	}
	-- hs.alert.show(table.concat(hotkeys, "\n"), 10) -- show for 10 seconds
	hs.alert.show(table.concat(hotkeys, "\n"), {
		atScreenEdge = 1,
		padding = 35,
	}, 5)
end)

-- A better cheat sheet using hs.chooser
local cheatSheetData = {
	{ text = "Show Hello World alert", subText = "Cmd + Alt + Ctrl + W" },
	{ text = "Move mouse to screen center", subText = "Ctrl + Alt + Cmd + C" },
	{ text = "Move mouse to screen upper-left", subText = "Ctrl + Alt + Cmd + U" },
	{ text = "Launch Safari", subText = "Ctrl + Shift + 1" },
	{ text = "Launch Kitty", subText = "Ctrl + Shift + 2" },
	{ text = "Launch Slack", subText = "Ctrl + Shift + 3" },
	{ text = "Launch Firefox", subText = "Ctrl + Shift + 0" },
	{ text = "Launch Ghostty", subText = "Ctrl + Shift + 9" },
	{ text = "Launch Todoist", subText = "Ctrl + Shift + 8" },
	{ text = "Launch Spotify", subText = "Ctrl + Shift + 7" },
	{ text = "Center focused window almost full", subText = "Ctrl + Alt + Cmd + B" },
	{ text = "Center all visible windows almost full", subText = "Ctrl + Alt + Cmd + N" },
	{ text = "Center all visible windows", subText = "Ctrl + Alt + Cmd + M" },
	{ text = "Maximize all visible windows", subText = "Ctrl + Alt + Cmd + M" },
	{ text = "Show frontmost app bundle ID", subText = "Ctrl + Alt + Cmd + I" },
}

-- Create the chooser object
local cheatSheetChooser = hs.chooser.new(function(choice)
	-- NOTE: We are not doing anything on selection for now
	if not choice then
		return
	end
end)
cheatSheetChooser:choices(cheatSheetData)
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "C", function()
	cheatSheetChooser:show()
end)
