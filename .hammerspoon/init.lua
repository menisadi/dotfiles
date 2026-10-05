local hk, app, win, screen = hs.hotkey, hs.application, hs.window, hs.screen

local excludedBundleIDs = {
	["com.martinfekete.tuneful"] = true,
}
local function isExcluded(w)
	local a = w:application()
	return a and excludedBundleIDs[a:bundleID()]
end

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
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "G", function()
	for _, win in ipairs(hs.window.visibleWindows()) do
		if not isExcluded(win) then
			local frame = win:frame()
			local screenFrame = win:screen():frame()
			frame.x = screenFrame.x + (screenFrame.w - frame.w) / 2
			frame.y = screenFrame.y + (screenFrame.h - frame.h) / 2
			win:setFrame(frame)
		end
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
	app.launchOrFocusByBundleID("net.whatsapp.Whatsapp")
end)
hk.bind({ "ctrl", "shift" }, "7", function()
	app.launchOrFocusByBundleID("com.todoist.mac.Todoist")
end)
hk.bind({ "ctrl", "shift" }, "6", function()
	app.launchOrFocusByBundleID("com.spotify.client")
end)
hk.bind({ "ctrl", "shift" }, "4", function()
	app.launchOrFocusByBundleID("com.anthropic.claudefordesktop")
end)
hk.bind({ "ctrl", "shift" }, "5", function()
	app.launchOrFocusByBundleID("com.apple.mail")
end)

hk.bind({ "ctrl", "shift" }, "-", function()
	hs.alert.show("Oh dear, that's the wrong key!")
end)

-- Helpers for sizing
local function centerAlmostFull(w, m)
	w = w or win.focusedWindow()
	if not w or isExcluded(w) then return end
	m = m or 48
	local f = w:screen():frame()
	w:setFrame({ x = f.x + m, y = f.y + m, w = f.w - 2 * m, h = f.h - 2 * m })
end
local function maximize(w)
	w = w or win.focusedWindow()
	if not w or isExcluded(w) then return end
	w:maximize()
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

-- Toggle system light/dark mode
hk.bind({ "ctrl", "alt", "cmd" }, "D", function()
	hs.osascript.applescript([[
		tell application "System Events"
			tell appearance preferences
				set dark mode to not dark mode
			end tell
		end tell
	]])
end)

hk.bind({ "ctrl", "alt", "cmd" }, "B", centerAlmostFull)
hk.bind({ "ctrl", "alt", "cmd" }, "N", centerAlmostFullAll)
hk.bind({ "ctrl", "alt", "cmd" }, "M", maximizeAll)

-- Spotify controls
hk.bind({ "ctrl", "alt", "cmd" }, "P", hs.spotify.playpause)
hk.bind({ "ctrl", "alt", "cmd" }, "]", hs.spotify.next)
hk.bind({ "ctrl", "alt", "cmd" }, "[", hs.spotify.previous)

-- Now Playing HUD (canvas popup with album art)
local nowPlayingCanvas = nil
local nowPlayingTimer = nil

local function hideNowPlayingHUD()
	if nowPlayingTimer then
		nowPlayingTimer:stop()
		nowPlayingTimer = nil
	end
	if nowPlayingCanvas then
		nowPlayingCanvas:delete()
		nowPlayingCanvas = nil
	end
end

local function buildNowPlayingHUD(artwork)
	hideNowPlayingHUD()

	local track = hs.spotify.getCurrentTrack() or "Unknown Track"
	local artist = hs.spotify.getCurrentArtist() or "Unknown Artist"
	local album = hs.spotify.getCurrentAlbum() or ""

	local w, h, pad, art = 475, 125, 15, 95
	local screenFrame = screen.mainScreen():frame()
	local x = screenFrame.x + (screenFrame.w - w) / 2
	local y = screenFrame.y + 80

	local c = hs.canvas.new({ x = x, y = y, w = w, h = h })
	c:level(hs.canvas.windowLevels.floating)
	c:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)

	c:insertElement({
		type = "rectangle",
		action = "fill",
		fillColor = { red = 0.08, green = 0.08, blue = 0.08, alpha = 0.92 },
		roundedRectRadii = { xRadius = 18, yRadius = 18 },
		frame = { x = 0, y = 0, w = w, h = h },
	})

	if artwork then
		c:insertElement({
			type = "image",
			image = artwork,
			frame = { x = pad, y = pad, w = art, h = art },
			imageScaling = "scaleProportionally",
			roundedRectRadii = { xRadius = 8, yRadius = 8 },
			clipToPath = true,
		})
	end

	local textX = pad + (artwork and (art + pad) or 0)
	local textW = w - textX - pad

	c:insertElement({
		type = "text",
		text = track,
		textFont = ".AppleSystemUIFontBold",
		textSize = 20,
		textColor = { white = 1 },
		frame = { x = textX, y = pad, w = textW, h = 28 },
	})
	c:insertElement({
		type = "text",
		text = artist,
		textFont = ".AppleSystemUIFont",
		textSize = 16,
		textColor = { white = 0.85 },
		frame = { x = textX, y = pad + 30, w = textW, h = 25 },
	})
	if album ~= "" then
		c:insertElement({
			type = "text",
			text = album,
			textFont = ".AppleSystemUIFont",
			textSize = 15,
			textColor = { white = 0.6 },
			frame = { x = textX, y = pad + 58, w = textW, h = 25 },
		})
	end

	nowPlayingCanvas = c
	c:show(0.15)
	nowPlayingTimer = hs.timer.doAfter(4, function()
		if nowPlayingCanvas == c then
			c:hide(0.4)
			hs.timer.doAfter(0.4, hideNowPlayingHUD)
		end
	end)
end

local function showNowPlayingHUD()
	if not hs.spotify.isRunning() then
		hs.alert.show("Spotify is not running")
		return
	end
	local artworkURL = hs.spotify.getCurrentTrackArtworkURL()
	if artworkURL and artworkURL ~= "" then
		hs.image.imageFromURL(artworkURL, buildNowPlayingHUD)
	else
		buildNowPlayingHUD(nil)
	end
end

hk.bind({ "ctrl", "alt", "cmd" }, "O", showNowPlayingHUD)

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
		"Ctrl+Shift+4: Launch Claude",
		"Ctrl+Shift+5: Launch Mail",
		"Ctrl+Shift+6: Launch Spotify",
		"Ctrl+Shift+7: Launch Todoist",
		"Ctrl+Shift+8: Launch Whatsapp",
		"Ctrl+Shift+9: Launch Ghostty",
		"Ctrl+Shift+0: Launch Firefox\n",
		"Ctrl+Alt+Cmd+B: Center focused window almost full",
		"Ctrl+Alt+Cmd+N: Center all visible windows almost full",
		"Ctrl+Alt+Cmd+G: Center all visible windows",
		"Ctrl+Alt+Cmd+M: Maximize all visible windows",
		"Ctrl+Alt+Cmd+I: Show frontmost app bundle ID\n",
		"Ctrl+Alt+Cmd+P: Spotify play/pause",
		"Ctrl+Alt+Cmd+]: Spotify next track",
		"Ctrl+Alt+Cmd+[: Spotify previous track",
		"Ctrl+Alt+Cmd+O: Show current Spotify track\n",
		"Ctrl+Alt+Cmd+A: Keep the Mac awake for a chosen duration\n",
		"Ctrl+Alt+Cmd+H: Show this help message",
		"Ctrl+Alt+Cmd+K: Show cheat sheet",
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
	{ text = "Launch Claude", subText = "Ctrl + Shift + 4" },
	{ text = "Launch Mail", subText = "Ctrl + Shift + 5" },
	{ text = "Launch Spotify", subText = "Ctrl + Shift + 6" },
	{ text = "Launch Todoist", subText = "Ctrl + Shift + 7" },
	{ text = "Launch Whatsapp", subText = "Ctrl + Shift + 8" },
	{ text = "Launch Ghostty", subText = "Ctrl + Shift + 9" },
	{ text = "Launch Firefox", subText = "Ctrl + Shift + 0" },
	{ text = "Center focused window almost full", subText = "Ctrl + Alt + Cmd + B" },
	{ text = "Center all visible windows almost full", subText = "Ctrl + Alt + Cmd + N" },
	{ text = "Center all visible windows", subText = "Ctrl + Alt + Cmd + G" },
	{ text = "Center all visible windows almost full", subText = "Ctrl + Alt + Cmd + J" },
	{ text = "Maximize all visible windows", subText = "Ctrl + Alt + Cmd + M" },
	{ text = "Show frontmost app bundle ID", subText = "Ctrl + Alt + Cmd + I" },
	{ text = "Spotify play/pause", subText = "Ctrl + Alt + Cmd + P" },
	{ text = "Spotify next track", subText = "Ctrl + Alt + Cmd + ]" },
	{ text = "Spotify previous track", subText = "Ctrl + Alt + Cmd + [" },
	{ text = "Show current Spotify track", subText = "Ctrl + Alt + Cmd + O" },
	{ text = "Keep the Mac awake", subText = "Ctrl + Alt + Cmd + A" },
}

-- Create the chooser object
local cheatSheetChooser = hs.chooser.new(function(choice)
	if not choice then
		hs.alert.show("")
	else
		local choice_title_text = choice.text .. " (" .. choice.subText .. ")"
		hs.alert.show(choice_title_text)
	end
end)
cheatSheetChooser:choices(cheatSheetData)
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "K", function()
	cheatSheetChooser:show()
end)

-- Keep the Mac awake for a chosen duration, driven by Amphetamine
local function amphetamine(command)
	local ok, _, err = hs.osascript.applescript('tell application "Amphetamine" to ' .. command)
	if not ok then
		hs.alert.show("Amphetamine: command failed")
		print("Amphetamine error: " .. hs.inspect(err))
	end
	return ok
end

local keepAwakeChoices = {
	{ text = "15 minutes", subText = "Keep awake for 15 minutes", duration = 15, interval = "minutes" },
	{ text = "30 minutes", subText = "Keep awake for 30 minutes", duration = 30, interval = "minutes" },
	{ text = "1 hour", subText = "Keep awake for 1 hour", duration = 1, interval = "hours" },
	{ text = "3 hours", subText = "Keep awake for 3 hours", duration = 3, interval = "hours" },
	-- Amphetamine treats duration 0 / interval 0 as an infinite session
	{ text = "Indefinitely", subText = "Keep awake until turned off", duration = 0, interval = "0" },
	{ text = "Off", subText = "End the current session", off = true },
}

local keepAwakeChooser = hs.chooser.new(function(choice)
	if not choice then
		return
	end
	if choice.off then
		if amphetamine("end session") then
			hs.alert.show("Awake: off")
		end
		return
	end
	local options = string.format(
		"{duration:%d, interval:%s, displaySleepAllowed:false}",
		choice.duration,
		choice.interval
	)
	if amphetamine("start new session with options " .. options) then
		hs.alert.show("Awake: " .. choice.text)
	end
end)
keepAwakeChooser:choices(keepAwakeChoices)
keepAwakeChooser:rows(#keepAwakeChoices)
keepAwakeChooser:placeholderText("Keep awake for…")

hk.bind({ "ctrl", "alt", "cmd" }, "A", function()
	keepAwakeChooser:show()
end)
