return {
 "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local disable_markdown = vim.fn.has("nvim-0.12") == 1

    vim.treesitter.language.register("haskell", "lhaskell")

    do
      local non_filetype_match_injection_language_aliases = {
        ex = "elixir",
        pl = "perl",
        sh = "bash",
        uxn = "uxntal",
        ts = "typescript",
      }

      vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local captured = match[pred[2]]
        local node = type(captured) == "table" and captured[#captured] or captured
        if type(node) ~= "userdata" then
          return
        end

        local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
        if not ok then
          return
        end

        local injection_alias = text:lower()
        local filetype = vim.filetype.match({ filename = "a." .. injection_alias })
        metadata["injection.language"] = filetype
          or non_filetype_match_injection_language_aliases[injection_alias]
          or injection_alias
      end, { force = true })
    end

    -- nvim-treesitter (main) no longer manages highlighting itself; that is
    -- handled by Neovim core. Start treesitter highlights for every filetype
    -- whose parser is installed, unless explicitly disabled.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("SalarTreesitterHighlight", { clear = true }),
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if disable_markdown and (ft == "markdown" or ft == "markdown_inline") then
          return
        end
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
