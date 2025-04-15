-- ~/.config/nvim/lua/core/autocmds.lua
vim.api.nvim_create_augroup("MyAutoCmds", { clear = true })

-- مثال لأوامر تلقائية أساسية
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cs", "cpp", "python" }, -- ملفات C# وغيرها
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
	group = "MyAutoCmds",
})

-- يمكنك إضافة أوامر تلقائية أخرى هنا
