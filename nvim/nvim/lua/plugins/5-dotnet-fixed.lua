-- ملف: lua/plugins/dotnet10.lua
-- إعداد محسن خصيصاً لـ .NET 10

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "omnisharp" },
        automatic_installation = false, -- نعطله لنتحكم يدوياً
      })

      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- تحسين capabilities للـ .NET 10
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }

      -- إعداد OmniSharp المخصص لـ .NET 10
      lspconfig.omnisharp.setup({
        capabilities = capabilities,

        -- أوامر بديلة للعثور على OmniSharp (محدث للمسار الفعلي)
        cmd = function()
          local omnisharp_paths = {
            "/home/mohamed/.omnisharp/omnisharp/OmniSharp", -- المسار الفعلي لديك
            "~/.local/bin/omnisharp",
            "omnisharp",
            "/usr/local/bin/omnisharp",
            "/usr/bin/omnisharp"
          }

          for _, path in ipairs(omnisharp_paths) do
            local expanded_path = vim.fn.expand(path)
            if vim.fn.executable(expanded_path) == 1 then
              return { expanded_path, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
            end
          end

          -- إذا لم نجد OmniSharp، استخدم المسار المباشر
          vim.notify(
            "استخدام المسار المباشر لـ OmniSharp",
            vim.log.levels.INFO
          )
          return { "/home/mohamed/.omnisharp/omnisharp/OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
        end,

        -- إعدادات محسنة لـ .NET 10
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          MsBuild = {
            LoadProjectsOnDemand = false,
          },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            AnalyzeOpenDocumentsOnly = false,
          },
          Sdk = {
            IncludePrereleases = true, -- مهم لـ .NET 10
          },
        },

        -- تهيئة محسنة
        init_options = {
          AutomaticWorkspaceInit = true,
        },

        -- معالجة الأخطاء والتوصيل
        on_attach = function(client, bufnr)
          -- انتظار حتى يكتمل تحميل المشروع
          local function setup_keymaps()
            local bufopts = { noremap = true, silent = true, buffer = bufnr }

            -- Navigation
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

            -- Code actions
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format({ async = true })
            end, bufopts)

            -- Signature help
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)

            -- Diagnostics
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, bufopts)
          end

          -- تأخير قصير للتأكد من اكتمال التحميل
          vim.defer_fn(setup_keymaps, 2000)

          -- رسالة تأكيد
          vim.notify("OmniSharp متصل بـ .NET 10", vim.log.levels.INFO)
        end,

        -- معالجة أفضل للأخطاء
        on_error = function(err)
          vim.notify("خطأ OmniSharp: " .. tostring(err), vim.log.levels.ERROR)
        end,
      })
    end,
  },

  -- باقي الإضافات
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
          { name = 'buffer', priority = 500 },
          { name = 'path', priority = 250 },
        },
      })
    end,
  },
}

-- إعدادات .NET 10 خاصة
vim.g.dotnet_build_project = function()
  vim.cmd('!dotnet build')
end

vim.g.dotnet_run_project = function()
  vim.cmd('!dotnet run')
end

-- أوامر مخصصة
vim.api.nvim_create_user_command('DotNetVersion', function()
  vim.cmd('!dotnet --version')
end, {})

vim.api.nvim_create_user_command('DotNetInfo', function()
  vim.cmd('!dotnet --info')
end, {})

-- إعداد التشخيص المحسن
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = 'always',
  },
  float = {
    source = 'always',
    border = 'rounded',
    header = '',
    prefix = '',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
