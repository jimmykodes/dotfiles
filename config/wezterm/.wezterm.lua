local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.keys = {
	{
		key = 'p',
		mods = 'SUPER',
		action = wezterm.action.ActivateCommandPalette,
	},
	{
		key = 'C',
		mods = 'SUPER',
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = 'd',
		mods = 'SUPER',
		action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},
	{
		key = 'D',
		mods = 'SUPER',
		action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
	},
	{
		key = 'J',
		mods = 'SUPER',
		action = wezterm.action.ActivatePaneDirection 'Down',
	},
	{
		key = 'K',
		mods = 'SUPER',
		action = wezterm.action.ActivatePaneDirection 'Up',
	},
	{
		key = 'H',
		mods = 'SUPER',
		action = wezterm.action.ActivatePaneDirection 'Left',
	},
	{
		key = 'L',
		mods = 'SUPER',
		action = wezterm.action.ActivatePaneDirection 'Right',
	},
}

config.color_scheme = "pokemon"
-- NL == No Ligatures
-- NFM == No Font Mono (meaning the icons are monospaced, too)
config.font = wezterm.font 'JetBrainsMonoNL NFM'
config.font_size = 16


-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

-- Returns true if the beginning of the string matches the provided prefix
local function has_prefix(s, prefix)
	return string.sub(s, 1, #prefix) == prefix
end

-- unceremoniously strips the length of `prefix` from the string.
-- do your own checking to make sure the string actually _has_ the
-- prefix you are removing
local function trim_prefix(s, prefix)
	return string.sub(s, #prefix + 1)
end

-- tries to intelligently shorten file paths so tab titles don't explode
local function shorten_path(p)
	local home = os.getenv("HOME")
	if has_prefix(p, home .. "/go/src/github.com/") then
		return trim_prefix(p, home .. "/go/src/github.com/")
	else
		return p
	end
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end

	-- Otherwise, use the foreground process.
	-- If the process is nvim, include the working dir
	local pane = tab_info.active_pane
	local bn = basename(pane.foreground_process_name)
	if bn == "nvim" then
		return "nvim - " .. shorten_path(pane.current_working_dir.file_path)
	elseif bn == "zsh" then
		return " " .. shorten_path(pane.current_working_dir.file_path)
	end
	return bn
end

wezterm.on('format-tab-title', tab_title)

return config
