-- ~/.config/nvim/init.lua
vim.opt.rtp:prepend(vim.fn.stdpath("config"))
package.path = package.path
	.. ";"
	.. vim.fn.stdpath("config")
	.. "/lua/?.lua;"
	.. vim.fn.stdpath("config")
	.. "/lua/?/init.lua"

require("core.options") -- Load general options
require("core.keymaps") -- Load general keymaps
require("core.snippets") -- Custom code snippets

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set up plugins
require("lazy").setup({
	require("plugins.neotree"),
	require("plugins.colortheme"),
	require("plugins.bufferline"),
	require("plugins.lualine"),
	require("plugins.treesitter"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.autocompletion"),
	require("plugins.none-ls"),
	require("plugins.gitsigns"),
	require("plugins.alpha"),
	require("plugins.indent-blankline"),
	require("plugins.misc"),
	require("plugins.comment"),
})

-- تحميل الإعدادات الأساسية
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- تهيئة نظام إدارة البلجنز (Lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- تحميل البلجنز
require("lazy").setup("plugins")

-- أي إعدادات إضافية
--require("config")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
