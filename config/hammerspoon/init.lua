local hotkeys = require "hotkeys"

for _, hotkey in ipairs(hotkeys.hotkeys) do
  hs.hotkey.bind(hotkey.mod, hotkey.key, hotkey.func)
end

hs.notify.new({ title = "Hammerspoon", informativeText = "Config Reloaded" }):send()
