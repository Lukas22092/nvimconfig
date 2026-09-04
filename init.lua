local lsp_log = vim.lsp.log.get_filename()
local max_lsp_log_size = 10 * 1024 * 1024

local stat = vim.uv.fs_stat(lsp_log)
if stat and stat.size > max_lsp_log_size then
	local fd = vim.uv.fs_open(lsp_log, "w", 420)
	if fd then
		vim.uv.fs_close(fd)
	end
end

vim.lsp.log.set_level(vim.log.levels.ERROR)

local start_time = vim.uv.hrtime()

require("salar.core")

local core_time_ms = (vim.uv.hrtime() - start_time) / 1e6
local log = require("salar.core.log")
log.info(string.format("init: salar.core loaded in %.1fms", core_time_ms))

require("salar.lazy")

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local total_ms = (vim.uv.hrtime() - start_time) / 1e6
		log.info(string.format("init: startup complete in %.1fms", total_ms))
	end,
})
