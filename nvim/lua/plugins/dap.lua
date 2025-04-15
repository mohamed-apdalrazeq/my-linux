-- plugins/lsp.lua
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			-- إعدادات عامة لجميع الخوادم
			local on_attach = function(client, bufnr)
				-- تفعيل الاختصارات عند فتح ملف
				local opts = { noremap = true, silent = true, buffer = bufnr }

				-- اختصارات أساسية
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- الانتقال للتعريف
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- عرض التوثيق
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- إعادة تسمية
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- إجراءات الكود
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- عرض المراجع
			end

			-- إعدادات القدرات (Capabilities)
			local capabilities = cmp_nvim_lsp.default_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- تهيئة خوادم LSP
			require("mason-lspconfig").setup_handlers({
				-- تهيئة افتراضية لجميع الخوادم
				function(server_name)
					lspconfig[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,

				-- تهيئة مخصصة لـ Omnisharp (C#/.NET)
				["omnisharp"] = function()
					lspconfig.omnisharp.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						cmd = { "omnisharp", "--languageserver" },
						settings = {
							FormattingOptions = {
								-- إعدادات تنسيق الكود
								OrganizeImports = true,
								EnableEditorConfigSupport = true,
							},
							MsBuild = {
								LoadProjectsOnDemand = false, -- للأداء في المشاريع الكبيرة
							},
							RoslynExtensionsOptions = {
								EnableAnalyzersSupport = true, -- تفعيل المحللات
								EnableImportCompletion = true, -- إكمال الاستيرادات
							},
							Sdk = {
								IncludePrereleases = true, -- دعم إصدارات SDK التجريبية
							},
						},
						handlers = {
							["textDocument/definition"] = require("omnisharp_extended").handler, -- دعم البحث الموسع
						},
					})
				end,

				-- يمكنك إضافة خوادم أخرى هنا (مثل Python, JS, إلخ)
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
							},
						},
					})
				end,
			})

			-- إعدادات مرئية لـ LSP
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = false,
			})

			-- رموز التشخيص (الأخطاء)
			local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- أوامر مخصصة لـ LSP
			vim.api.nvim_create_user_command("Format", function()
				vim.lsp.buf.format({ async = true })
			end, {})
		end,
	},

	-- إضافة ملحقات إضافية لـ Omnisharp (اختياري)
	{
		"Hoffs/omnisharp-extended-lsp.nvim",
		ft = "cs", -- فقط لملفات C#
	},
}
