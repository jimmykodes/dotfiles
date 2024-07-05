local keys = require "keys"
local window = require "windows"

local hotkeys = {
	{
		mod = keys.hyper,
		key = "r",
		func = hs.reload
	},
	{
		mod = keys.hyper,
		key = "s",
		func = hs.spotify.displayCurrentTrack
	},
	-- window sizing
	{
		-- snap window left half
		mod = keys.hyper,
		key = "h",
		func = window.left_half,
	},
	{
		-- snap window right half
		mod = keys.hyper,
		key = "l",
		func = window.right_half,
	},
	{
		-- snap window top half
		mod = keys.hyper,
		key = "k",
		func = window.top_half
	},
	{
		-- snap window bottom
		mod = keys.hyper,
		key = "j",
		func = window.bottom_half,
	},
	{
		-- snap window upper left
		mod = keys.hyper,
		key = "u",
		func = window.upper_left,
	},
	{
		-- snap window lower left
		mod = keys.hyper,
		key = "y",
		func = window.lower_left,
	},
	{
		-- snap window upper right
		mod = keys.hyper,
		key = "i",
		func = window.upper_right,
	},
	{
		-- snap window lower right
		mod = keys.hyper,
		key = "o",
		func = window.lower_right,
	},
	{
		-- snap window middle
		mod = keys.hyper,
		key = "m",
		func = window.middle,
	},
	{
		-- maximize window
		mod = keys.hyper,
		key = "p",
		func = function() hs.window.focusedWindow():maximize(0) end
	},
	{
		-- toggle window full screen
		mod = keys.hyper,
		key = "f",
		func = function()
			local win = hs.window.focusedWindow()
			win:setFullScreen(not win:isFullScreen())
		end
	},
}

return {
	hotkeys = hotkeys
}
