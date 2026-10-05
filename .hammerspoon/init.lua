local hk, app, win, screen = hs.hotkey, hs.application, hs.window, hs.screen

-- Every hotkey is registered through bind() so the cheat sheet stays in sync
local bindings = {}
local modOrder = { ctrl = 1, alt = 2, shift = 3, cmd = 4 }
local modSymbol = { ctrl = "⌃", alt = "⌥", shift = "⇧", cmd = "⌘" }
local function label(mods, key)
	local sorted = { table.unpack(mods) }
	table.sort(sorted, function(a, b)
		return modOrder[a] < modOrder[b]
	end)
	local s = ""
	for _, m in ipairs(sorted) do
		s = s .. modSymbol[m]
	end
	return s .. key:upper()
end
local function bind(mods, key, desc, fn)
	hk.bind(mods, key, fn)
	table.insert(bindings, { text = desc, subText = label(mods, key) })
end

local excludedBundleIDs = {
	["com.martinfekete.tuneful"] = true,
}
local function isExcluded(w)
	local a = w:application()
	return a and excludedBundleIDs[a:bundleID()]
end

bind({ "cmd", "alt", "ctrl" }, "W", "Show Hello World alert", function()
	hs.alert.show("Hello World!")
end)

-- Move mouse to screen center / upper-left
bind({ "ctrl", "alt", "cmd" }, "C", "Move mouse to screen center", function()
	local f = screen.mainScreen():fullFrame()
	hs.mouse.setAbsolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
end)

bind({ "ctrl", "alt", "cmd" }, "U", "Move mouse to screen upper-left", function()
	local f = screen.mainScreen():fullFrame()
	hs.mouse.setAbsolutePosition({ x = f.x, y = f.y })
end)

-- Center all visible windows
bind({ "ctrl", "alt", "cmd" }, "G", "Center all visible windows", function()
	for _, w in ipairs(win.visibleWindows()) do
		if not isExcluded(w) then
			local frame = w:frame()
			local screenFrame = w:screen():frame()
			frame.x = screenFrame.x + (screenFrame.w - frame.w) / 2
			frame.y = screenFrame.y + (screenFrame.h - frame.h) / 2
			w:setFrame(frame)
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

local launchers = {
	{ key = "1", name = "Safari", id = "com.apple.Safari" },
	{ key = "2", name = "Kitty", id = "net.kovidgoyal.kitty" },
	{ key = "3", name = "Slack", id = "com.tinyspeck.slackmacgap" },
	{ key = "4", name = "Claude", id = "com.anthropic.claudefordesktop" },
	{ key = "5", name = "Mail", id = "com.apple.mail" },
	{ key = "6", name = "Spotify", id = "com.spotify.client" },
	{ key = "7", name = "Todoist", id = "com.todoist.mac.Todoist" },
	{ key = "8", name = "WhatsApp", id = "net.whatsapp.WhatsApp" },
	{ key = "9", name = "Ghostty", id = "com.mitchellh.ghostty" },
	{ key = "0", name = "Firefox", id = "org.mozilla.firefox" },
}
for _, l in ipairs(launchers) do
	bind({ "ctrl", "shift" }, l.key, "Launch " .. l.name, function()
		app.launchOrFocusByBundleID(l.id)
	end)
end

bind({ "ctrl", "shift" }, "-", "Wrong key", function()
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

-- Apply a sizing profile to all visible windows: center w/ gaps or maximize
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
bind({ "ctrl", "alt", "cmd" }, "D", "Toggle light/dark mode", function()
	hs.osascript.applescript([[
		tell application "System Events"
			tell appearance preferences
				set dark mode to not dark mode
			end tell
		end tell
	]])
end)

bind({ "ctrl", "alt", "cmd" }, "B", "Center focused window almost full", centerAlmostFull)
bind({ "ctrl", "alt", "cmd" }, "N", "Center all visible windows almost full", centerAlmostFullAll)
bind({ "ctrl", "alt", "cmd" }, "M", "Maximize all visible windows", maximizeAll)

-- Spotify controls
local function ifSpotifyRunning(fn)
	return function()
		if hs.spotify.isRunning() then
			fn()
		else
			hs.alert.show("Spotify is not running")
		end
	end
end
bind({ "ctrl", "alt", "cmd" }, "P", "Spotify play/pause", ifSpotifyRunning(hs.spotify.playpause))
bind({ "ctrl", "alt", "cmd" }, "]", "Spotify next track", ifSpotifyRunning(hs.spotify.next))
bind({ "ctrl", "alt", "cmd" }, "[", "Spotify previous track", ifSpotifyRunning(hs.spotify.previous))

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
			nowPlayingTimer = nil
			nowPlayingCanvas = nil
			c:delete(0.4)
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

bind({ "ctrl", "alt", "cmd" }, "O", "Show current Spotify track", showNowPlayingHUD)

-- Little utility to get app IDs
bind({ "ctrl", "alt", "cmd" }, "I", "Show frontmost app bundle ID", function()
	local id = app.frontmostApplication():bundleID()
	hs.alert.show(id) -- pops a toast on screen
	hs.pasteboard.setContents(id) -- also copies it to the clipboard
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

bind({ "ctrl", "alt", "cmd" }, "A", "Keep the Mac awake", function()
	keepAwakeChooser:show()
end)

-- Searchable cheat sheet of every hotkey registered through bind()
local cheatSheetChooser = hs.chooser.new(function(choice)
	if not choice then
		return
	end
	hs.alert.show(choice.text .. " (" .. choice.subText .. ")")
end)
bind({ "ctrl", "alt", "cmd" }, "K", "Show cheat sheet", function()
	cheatSheetChooser:choices(bindings)
	cheatSheetChooser:show()
end)
