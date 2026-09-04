local log = require("salar.core.log")

vim.g.mapleader = " "

local keymap = vim.keymap

local function scroll_keep_cursor(delta)
	local prev = vim.fn.winsaveview()
	local top = vim.fn.line("w0")
	local bot = vim.fn.line("w$")
	local mid = math.floor((top + bot) / 2)
	local target = mid + delta

	if target < 1 then target = 1 end
	if target > vim.fn.line("$") then target = vim.fn.line("$") end

	vim.cmd(target)
	vim.cmd("normal! zz")
	vim.fn.winrestview(prev)
end

keymap.set("n", "<C-u>", function() scroll_keep_cursor(-math.floor(vim.o.lines / 2)) end, { desc = "Scroll half page up (cursor stays)" })
keymap.set("n", "<C-d>", function() scroll_keep_cursor(math.floor(vim.o.lines / 2)) end, { desc = "Scroll half page down (cursor stays)" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase height" })
keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease height" })
keymap.set("n", "<C-Left>", ":vertical resize -4<CR>", { desc = "Narrower" })
keymap.set("n", "<C-Right>", ":vertical resize +4<CR>", { desc = "Wider" })

-- tab management
keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })
keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close current buffer" })
keymap.set("n", "<leader>n", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- file explorer
keymap.set("n", "<C-n>", "<cmd>Ex<CR>", { desc = "Open file explorer" })

vim.keymap.set("n", "<leader>ci", "<cmd>Telescope lsp_incoming_calls<CR>")
vim.keymap.set("n", "<leader>co", "<cmd>Telescope lsp_outgoing_calls<CR>")
vim.keymap.set("n", "<leader>ch", "<cmd>Telescope lsp_implementations<CR>")
vim.keymap.set("n", "<leader>cu", "<cmd>Telescope lsp_references<CR>")

keymap.set("n", "<leader>ts", "<cmd>Theme<CR>", { desc = "Select theme" })
keymap.set("n", "<leader>tn", "<cmd>ThemeNext<CR>", { desc = "Next theme" })
keymap.set("n", "<leader>tp", "<cmd>ThemePrev<CR>", { desc = "Previous theme" })

-- terminal related
keymap.set("t", "<Esc>", [[<C-\><C-n>]])
keymap.set("n", "<leader>th", function()
	vim.cmd("split | terminal")
	vim.cmd("startinsert")
end, { desc = "Open horizontal terminal" })
keymap.set("n", "<leader>tv", function()
	vim.cmd("vsplit | terminal")
	vim.cmd("startinsert")
end, { desc = "Open vertical terminal" })

-- Logging helpers
keymap.set("n", "<leader>lg", "<cmd>SalarLog<CR>", { desc = "Open salar log" })
keymap.set("n", "<leader>gc", "<cmd>SalarLog clear<CR>", { desc = "Clear salar log" })

log.info("core keymaps configured (leader=<Space>)")
