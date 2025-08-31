-- ملف: lua/base/dotnet-autocmds.lua
-- أضف هذا المحتوى إلى ملف lua/base/3-autocmds.lua أو أنشئ ملفاً جديداً

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- مجموعة إعدادات .NET
local dotnet_group = augroup('DotNetSettings', { clear = true })

-- إعدادات خاصة بملفات C#
autocmd('FileType', {
  group = dotnet_group,
  pattern = 'cs',
  callback = function()
    -- إعدادات المسافات البادئة
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.softtabstop = 4

    -- تمكين طي الكود
    vim.opt_local.foldmethod = 'syntax'
    vim.opt_local.foldlevel = 99

    -- تحسين عرض النصوص الطويلة
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = true

    -- إعدادات خاصة بـ C#
    vim.keymap.set('n', '<leader>db', ':DotnetBuild<CR>', { buffer = true, desc = 'Build .NET project' })
    vim.keymap.set('n', '<leader>dr', ':DotnetRun<CR>', { buffer = true, desc = 'Run .NET project' })
    vim.keymap.set('n', '<leader>dt', ':DotnetTest<CR>', { buffer = true, desc = 'Test .NET project' })
  end
})

-- إعدادات خاصة بملفات المشروع
autocmd('FileType', {
  group = dotnet_group,
  pattern = { 'xml', 'csproj', 'sln' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.softtabstop = 2
  end
})

-- تمكين التشخيص التلقائي عند حفظ الملف
autocmd('BufWritePre', {
  group = dotnet_group,
  pattern = '*.cs',
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})

-- إعدادات خاصة للتطوير السريع
autocmd('BufEnter', {
  group = dotnet_group,
  pattern = '*.cs',
  callback = function()
    -- تفعيل الحفظ التلقائي
    vim.opt_local.autowrite = true
    vim.opt_local.autowriteall = true
  end
})

-- أوامر مخصصة للـ .NET
vim.api.nvim_create_user_command('DotnetBuild', function()
  vim.cmd('!dotnet build')
end, { desc = 'Build the current .NET project' })

vim.api.nvim_create_user_command('DotnetRun', function()
  vim.cmd('!dotnet run')
end, { desc = 'Run the current .NET project' })

vim.api.nvim_create_user_command('DotnetTest', function()
  vim.cmd('!dotnet test')
end, { desc = 'Run tests for the current .NET project' })

vim.api.nvim_create_user_command('DotnetRestore', function()
  vim.cmd('!dotnet restore')
end, { desc = 'Restore NuGet packages' })

vim.api.nvim_create_user_command('DotnetClean', function()
  vim.cmd('!dotnet clean')
end, { desc = 'Clean the current .NET project' })

-- إعدادات LSP خاصة بـ .NET
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = 'always',
  },
  float = {
    source = 'always',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- أيقونات التشخيص
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
