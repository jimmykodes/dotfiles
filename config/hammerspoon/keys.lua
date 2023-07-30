local M = {}

M.cmd = "cmd"
M.alt = "alt"
M.ctrl = "ctrl"
M.shift = "shift"
M.hyper = { M.cmd, M.alt, M.ctrl, M.shift }
M.meh = { M.cmd, M.alt, M.ctrl }

return M
