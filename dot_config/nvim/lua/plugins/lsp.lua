return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'b0o/schemastore.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', function()
            require('snacks').picker.lsp_references()
          end, '[G]oto [R]eferences')
          map('gri', function()
            require('snacks').picker.lsp_implementations()
          end, '[G]oto [I]mplementation')
          map('gd', function()
            require('snacks').picker.lsp_definitions()
          end, '[G]oto [D]efinition')
          map('gD', function()
            require('snacks').picker.lsp_declarations()
          end, '[G]oto [D]eclaration')
          map('gO', function()
            require('snacks').picker.lsp_symbols()
          end, 'Open Document Symbols')
          map('gW', function()
            require('snacks').picker.lsp_workspace_symbols()
          end, 'Open Workspace Symbols')
          map('grt', function()
            require('snacks').picker.lsp_type_definitions()
          end, '[G]oto [T]ype Definition')

          ---@param client vim.lsp.Client
          ---@param method string
          ---@param bufnr? integer
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            -- NVIM 0.12+: method call syntax
            return client:supports_method(method, bufnr)
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                pcall(vim.lsp.buf.clear_references)
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Global harper_ls toggle (off by default, toggle with <leader>tH)
      vim.g.harper_enabled = false
      vim.keymap.set('n', '<leader>tH', function()
        vim.g.harper_enabled = not vim.g.harper_enabled
        for _, client in ipairs(vim.lsp.get_clients { name = 'harper_ls' }) do
          local ns = vim.lsp.diagnostic.get_namespace(client.id)
          vim.diagnostic.enable(vim.g.harper_enabled, { ns_id = ns })
        end
        require('snacks').notify(vim.g.harper_enabled and 'Harper enabled' or 'Harper disabled', {
          level = vim.g.harper_enabled and 'info' or 'warn',
          title = 'Harper',
        })
      end, { desc = 'LSP: [T]oggle [H]arper' })

      -- Dim unused symbols (ts_ls reports them as hints via DiagnosticUnnecessary)
      vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { fg = '#6b7280', italic = true })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = { min = vim.diagnostic.severity.HINT } },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        ts_ls = {},
        cssls = {
          settings = {
            css = { validate = true, lint = { unknownAtRules = 'ignore' } },
            scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
            less = { validate = true },
          },
        },
        somesass_ls = {},
        html = {},
        emmet_language_server = {
          filetypes = { 'html', 'css', 'scss', 'javascriptreact', 'typescriptreact' },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        tailwindcss = {
          filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        harper_ls = {
          on_attach = function(client)
            -- Start disabled; user toggles with <leader>tH
            local ns = vim.lsp.diagnostic.get_namespace(client.id)
            vim.diagnostic.enable(false, { ns_id = ns })
          end,
          settings = {
            ['harper-ls'] = {
              userDictPath = vim.fn.expand '~/.config/dictionary/user.txt',
              workspaceDictPath = '',
              fileDictPath = '',
              linters = {
                SpellCheck = true,
                SpelledNumbers = false,
                AnA = true,
                SentenceCapitalization = true,
                UnclosedQuotes = true,
                WrongApostrophe = false,
                LongSentences = true,
                RepeatedWords = true,
                Spaces = true,
                CorrectNumberSuffix = true,
              },
              codeActions = {
                ForceStable = false,
              },
              markdown = {
                IgnoreLinkTitle = false,
              },
              diagnosticSeverity = 'hint',
              isolateEnglish = false,
              dialect = 'American',
              maxFileLength = 120000,
              ignoredLintsPath = '',
              excludePatterns = {},
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'prettierd',
        'jsonlint',
        'hadolint',
        'eslint_d',
        'typescript-language-server',
        'some-sass-language-server',
        'harper-ls',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
