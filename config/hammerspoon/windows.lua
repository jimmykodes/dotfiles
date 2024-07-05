local M = {}

local function resize(funcs)
	local win = hs.window.focusedWindow()
	local screen = win:screen()
	local max = screen:frame()
	local f = win:frame()

	local dx = funcs['x'] or function(m) return m.x end
	local dy = funcs['y'] or function(m) return m.y end
	local dw = funcs['w'] or function(m) return m.w end
	local dh = funcs['h'] or function(m) return m.h end

	f.x = dx(max)
	f.y = dy(max)
	f.w = dw(max)
	f.h = dh(max)

	win:setFrame(f, 0)
end

function M.left_half()
	resize({ w = function(m) return m.w / 2 end })
end

function M.right_half()
	resize({
		x = function(m) return m.x + (m.w / 2) end,
		w = function(m) return m.w / 2 end,
	})
end

function M.top_half()
	resize({ h = function(m) return m.h / 2 end })
end

function M.bottom_half()
	resize({
		y = function(m) return m.y + (m.h / 2) end,
		h = function(m) return m.h / 2 end,
	})
end

function M.upper_left()
	resize({
		w = function(m) return m.w / 2 end,
		h = function(m) return m.h / 2 end,
	})
end

function M.lower_left()
	resize({
		y = function(m) return m.y + (m.h / 2) end,
		w = function(m) return m.w / 2 end,
		h = function(m) return m.h / 2 end,
	})
end

function M.upper_right()
	resize({
		x = function(m) return m.x + (m.w / 2) end,
		w = function(m) return m.w / 2 end,
		h = function(m) return m.h / 2 end,
	})
end

function M.lower_right()
	resize({
		x = function(m) return m.x + (m.w / 2) end,
		y = function(m) return m.y + (m.h / 2) end,
		w = function(m) return m.w / 2 end,
		h = function(m) return m.h / 2 end,
	})
end

function M.middle()
	resize({
		x = function(m) return m.x + (m.w / 4) end,
		w = function(m) return m.w / 2 end,
	})
end

return M
