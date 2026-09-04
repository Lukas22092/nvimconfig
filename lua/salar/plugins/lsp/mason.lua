return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local log = require("salar.core.log")
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local ensure_installed = {
			"ts_ls",
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"lua_ls",
			"graphql",
			"emmet_ls",
			"pyright",
			"clangd",
			"rust_analyzer",
		}

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = ensure_installed,
		})

		log.info("mason ready; ensure_installed: " .. table.concat(ensure_installed, ", "))

		-- Report which requested servers are not yet installed (lspconfig-name aware)
		local installed = require("mason-lspconfig").get_installed_servers()
		local missing = {}
		for _, server in ipairs(ensure_installed) do
			if not vim.tbl_contains(installed, server) then
				missing[#missing + 1] = server
			end
		end
		if #missing > 0 then
			log.warn("mason servers not yet installed: " .. table.concat(missing, ", "))
		else
			log.debug("all mason servers already installed")
		end
	end,
}
