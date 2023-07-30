local keys = require "keys"

local hotkeys = {
  {
    mod = keys.hyper,
    key = "r",
    func = function()
      hs.reload()
    end
  },
  {
    mod = keys.hyper,
    key = "t",
    func = function()
      hs.application.launchOrFocus("wezTerm")
    end
  },
  {
    mod = keys.hyper,
    key = "a",
    func = function()
      hs.application.launchOrFocus("arc")
    end
  },
  {
    mod = keys.hyper,
    key = "s",
    func = function()
      hs.application.launchOrFocus("slack")
    end
  },
  {
    mod = keys.meh,
    key = "s",
    func = hs.spotify.displayCurrentTrack
  },
  -- window sizing
  {
    -- snap window left half
    mod = keys.hyper,
    key = "h",
    func = function()
      local win = hs.window.focusedWindow()
      local screen = win:screen()
      local max = screen:frame()
      local f = win:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h

      win:setFrame(f)
    end
  },
  {
    -- snap window right half
    mod = keys.hyper,
    key = "l",
    func = function()
      local win = hs.window.focusedWindow()
      local screen = win:screen()
      local max = screen:frame()
      local f = win:frame()

      f.x = max.x + (max.w / 2)
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h

      win:setFrame(f)
    end
  },
  {
    -- snap window top half
    mod = keys.hyper,
    key = "k",
    func = function()
      local win = hs.window.focusedWindow()
      local screen = win:screen()
      local max = screen:frame()
      local f = win:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w
      f.h = max.h / 2

      win:setFrame(f)
    end
  },
  {
    -- snap window bottom
    mod = keys.hyper,
    key = "j",
    func = function()
      local win = hs.window.focusedWindow()
      local screen = win:screen()
      local max = screen:frame()
      local f = win:frame()

      f.x = max.x
      f.y = max.y + (max.h / 2)
      f.w = max.w
      f.h = max.h / 2

      win:setFrame(f)
    end
  },
  {
    -- snap window upper left
    mod = keys.hyper,
    key = "u",
    func = function()
      local win = hs.window.focusedWindow()
      local screen = win:screen()
      local max = screen:frame()
      local f = win:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h / 2

      win:setFrame(f)
    end
  },
  {
    -- snap window lower left
    mod = keys.hyper,
    key = "y",
    func = function()
      local win = hs.window.focusedWindow()
      local screen = win:screen()
      local max = screen:frame()
      local f = win:frame()

      f.x = max.x
      f.y = max.y + (max.h / 2)
      f.w = max.w / 2
      f.h = max.h / 2

      win:setFrame(f)
    end
  },
  {
    -- snap window upper right
    mod = keys.hyper,
    key = "i",
    func = function()
      local win = hs.window.focusedWindow()
      local screen = win:screen()
      local max = screen:frame()
      local f = win:frame()

      f.x = max.x + (max.w / 2)
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h / 2

      win:setFrame(f)
    end
  },
  {
    -- snap window lower right
    mod = keys.hyper,
    key = "o",
    func = function()
      local win = hs.window.focusedWindow()
      local screen = win:screen()
      local max = screen:frame()
      local f = win:frame()

      f.x = max.x + (max.w / 2)
      f.y = max.y + (max.h / 2)
      f.w = max.w / 2
      f.h = max.h / 2

      win:setFrame(f)
    end
  },
  {
    -- snap window left
    mod = keys.hyper,
    key = "p",
    func = function()
      local win = hs.window.focusedWindow()
      local screen = win:screen()
      local max = screen:frame()
      local f = win:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w
      f.h = max.h

      win:setFrame(f)
    end
  },
}

return {
  hotkeys = hotkeys
}
