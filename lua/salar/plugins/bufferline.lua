return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local bufferline = require("bufferline")

		local function hl(name)
			return vim.api.nvim_get_hl(0, { name = name, link = false })
		end

		local function fg_or(group, fallback)
			local value = hl(group)
			return (value and value.fg) or fallback
		end

		local function bg_or(group, fallback)
			local value = hl(group)
			return (value and value.bg) or fallback
		end

		local function sync_fill_highlight()
			local normal = hl("Normal")
			local tabline_fill = hl("TabLineFill")
			local tabline = hl("TabLine")
			local fill_bg = bg_or("TabLineFill", bg_or("TabLine", bg_or("Normal", "#1e1e2e")))

			vim.api.nvim_set_hl(0, "BufferLineFill", { bg = fill_bg })
		end

		local function sync_tab_highlights()
			local normal = hl("Normal")
			if not normal then
				return
			end

			local base_bg = bg_or("TabLine", normal.bg)
			local base_fg = fg_or("TabLine", normal.fg)
			local selected_bg = bg_or("TabLineSel", normal.bg)
			local selected_fg = fg_or("TabLineSel", normal.fg)
			local warn_fg = fg_or("DiagnosticWarn", base_fg)
			local special_fg = fg_or("Special", selected_fg)

			vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = base_bg, fg = base_fg })
			vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { bg = base_bg, fg = base_fg })
			vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = selected_bg, fg = selected_fg, bold = true })
			vim.api.nvim_set_hl(0, "BufferLineDuplicate", { bg = base_bg, fg = base_fg })
			vim.api.nvim_set_hl(0, "BufferLineDuplicateVisible", { bg = base_bg, fg = base_fg })
			vim.api.nvim_set_hl(0, "BufferLineDuplicateSelected", { bg = selected_bg, fg = selected_fg, bold = true })
			vim.api.nvim_set_hl(0, "BufferLineModified", { bg = base_bg, fg = warn_fg })
			vim.api.nvim_set_hl(0, "BufferLineModifiedVisible", { bg = base_bg, fg = warn_fg })
			vim.api.nvim_set_hl(0, "BufferLineModifiedSelected", { bg = selected_bg, fg = warn_fg })
			vim.api.nvim_set_hl(0, "BufferLineSeparator", { bg = base_bg, fg = base_bg })
			vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { bg = base_bg, fg = base_bg })
			vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { bg = selected_bg, fg = selected_bg })
			vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { bg = selected_bg, fg = special_fg })
		end

		local options = {
			options = {
				mode = "buffers",
				separator_style = "thin",
				always_show_bufferline = true,
				sort_by = "insert_after_current",
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(_, _, diag)
					local icons = { Error = " ", Warn = " ", Hint = " ", Info = " " }
					local parts = {}
					for severity, count in pairs(diag) do
						if icons[severity] then
							table.insert(parts, icons[severity] .. count)
						end
					end
					return table.concat(parts, " ")
				end,
				modified_icon = "●",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		}

		bufferline.setup(options)
		sync_fill_highlight()
		sync_tab_highlights()

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("SalarBufferlineThemeSync", { clear = true }),
			callback = function()
				bufferline.setup(options)
				sync_fill_highlight()
				sync_tab_highlights()
			end,
		})

		vim.keymap.set("n", "<leader>h", ":BufferLineMovePrev<CR>", { silent = true, desc = "Move buffer left" })
		vim.keymap.set("n", "<leader>l", ":BufferLineMoveNext<CR>", { silent = true, desc = "Move buffer right" })
	end,
}