local log = require("salar.core.log")

log.info("loading treesitter compat shim (if telescope already loaded)")
local ok_tsc, err_tsc = pcall(function()
  require("salar.core.treesitter_compat").setup()
end)
if not ok_tsc then log.error("treesitter compat failed: " .. tostring(err_tsc)) end

log.info("loading core module: options")
local ok_options, err_options = pcall(require, "salar.core.options")
if not ok_options then log.error("options failed: " .. tostring(err_options)) end

log.info("loading core module: keymaps")
local ok_keymaps, err_keymaps = pcall(require, "salar.core.keymaps")
if not ok_keymaps then log.error("keymaps failed: " .. tostring(err_keymaps)) end

log.info("loading core module: godot")
local ok_godot, err_godot = pcall(function()
  require("salar.core.godot").setup()
end)
if not ok_godot then log.error("godot failed: " .. tostring(err_godot)) end

log.info("loading core module: tools")
local ok_tools, err_tools = pcall(function()
  require("salar.tools").setup()
end)
if not ok_tools then log.error("tools failed: " .. tostring(err_tools)) end

log.info("core modules loaded")
