local M = {}

local log = require("salar.core.log")

-- nvim-treesitter (main) removed the legacy `parsers.ft_to_lang`,
-- `parsers.get_parser` and `configs` sandbox that telescope's previewer
-- still relies on.  Rather than depending on nvim-treesitter's own load
-- order, we replace telescope's ts_highlighter with one built on the
-- Neovim core API (vim.treesitter.start / .language.get_lang) which is
-- stable across 0.10+.
M.setup = function()
  local had_ts, telescope_utils = pcall(require, "telescope.previewers.utils")
  if not had_ts then
    log.debug("telescope not loaded yet, deferring treesitter compat")
    return false
  end

  telescope_utils.ts_highlighter = function(bufnr, ft)
    if ft == nil or ft == "" then
      return false
    end
    -- bail out for filetypes without a parser; get_lang falls back to ft
    local ok_get, lang = pcall(vim.treesitter.language.get_lang, ft)
    if not ok_get or not lang then
      return false
    end
    vim.api.nvim_buf_set_option(bufnr, "syntax", "off")
    local ok_start = pcall(vim.treesitter.start, bufnr, lang)
    return ok_start
  end

  log.debug("patched telescope previewer ts_highlighter -> core vim.treesitter.start")
  return true
end

return M