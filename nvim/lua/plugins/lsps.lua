return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  -- {
  --   -- Main LSP Configuration
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     -- Automatically install LSPs and related tools to stdpath for Neovim
  --     { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
  --     "williamboman/mason-lspconfig.nvim",
  --     "WhoIsSethDaniel/mason-tool-installer.nvim",
  --
  --     -- Useful status updates for LSP.
  --     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
  --     { "j-hui/fidget.nvim", opts = {} },
  --
  --     -- Allows extra capabilities provided by nvim-cmp
  --     "hrsh7th/cmp-nvim-lsp",
  --   },
  --   config = function()
  --     -- Brief aside: **What is LSP?**
  --     --
  --     -- LSP is an initialism you've probably heard, but might not understand what it is.
  --     --
  --     -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  --     -- and language tooling communicate in a standardized fashion.
  --     --
  --     -- In general, you have a "server" which is some tool built to understand a particular
  --     -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  --     -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  --     -- processes that communicate with some "client" - in this case, Neovim!
  --     --
  --     -- LSP provides Neovim with features like:
  --     --  - Go to definition
  --     --  - Find references
  --     --  - Autocompletion
  --     --  - Symbol Search
  --     --  - and more!
  --     --
  --     -- Thus, Language Servers are external tools that must be installed separately from
  --     -- Neovim. This is where `mason` and related plugins come into play.
  --     --
  --     -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  --     -- and elegantly composed help section, `:help lsp-vs-treesitter`
  --
  --     --  This function gets run when an LSP attaches to a particular buffer.
  --     --    That is to say, every time a new file is opened that is associated with
  --     --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --     --    function will be executed to configure the current buffer
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  --       callback = function(event)
  --         -- NOTE: Remember that Lua is a real programming language, and as such it is possible
  --         -- to define small helper and utility functions so you don't have to repeat yourself.
  --         --
  --         -- In this case, we create a function that lets us more easily define mappings specific
  --         -- for LSP related items. It sets the mode, buffer and description for us each time.
  --         local map = function(keys, func, desc, mode)
  --           mode = mode or "n"
  --           vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
  --         end
  --
  --         -- Jump to the definition of the word under your cursor.
  --         --  This is where a variable was first declared, or where a function is defined, etc.
  --         --  To jump back, press <C-t>.
  --         map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
  --
  --         -- Find references for the word under your cursor.
  --         map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  --
  --         -- Jump to the implementation of the word under your cursor.
  --         --  Useful when your language has ways of declaring types without an actual implementation.
  --         map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  --
  --         -- Jump to the type of the word under your cursor.
  --         --  Useful when you're not sure what type a variable is and you want to see
  --         --  the definition of its *type*, not where it was *defined*.
  --         map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
  --
  --         -- Fuzzy find all the symbols in your current document.
  --         --  Symbols are things like variables, functions, types, etc.
  --         map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  --
  --         -- Fuzzy find all the symbols in your current workspace.
  --         --  Similar to document symbols, except searches over your entire project.
  --         map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
  --
  --         -- Rename the variable under your cursor.
  --         --  Most Language Servers support renaming across files, etc.
  --         map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  --
  --         -- Execute a code action, usually your cursor needs to be on top of an error
  --         -- or a suggestion from your LSP for this to activate.
  --         map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
  --
  --         -- WARN: This is not Goto Definition, this is Goto Declaration.
  --         --  For example, in C this would take you to the header.
  --         map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  --
  --         -- The following two autocommands are used to highlight references of the
  --         -- word under your cursor when your cursor rests there for a little while.
  --         --    See `:help CursorHold` for information about when this is executed
  --         --
  --         -- When you move your cursor, the highlights will be cleared (the second autocommand).
  --         local client = vim.lsp.get_client_by_id(event.data.client_id)
  --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
  --           local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
  --           vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.document_highlight,
  --           })
  --
  --           vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.clear_references,
  --           })
  --
  --           vim.api.nvim_create_autocmd("LspDetach", {
  --             group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
  --             callback = function(event2)
  --               vim.lsp.buf.clear_references()
  --               vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
  --             end,
  --           })
  --         end
  --
  --         -- The following code creates a keymap to toggle inlay hints in your
  --         -- code, if the language server you are using supports them
  --         --
  --         -- This may be unwanted, since they displace some of your code
  --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
  --           map("<leader>th", function()
  --             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
  --           end, "[T]oggle Inlay [H]ints")
  --         end
  --       end,
  --     })
  --
  --     -- LSP servers and clients are able to communicate to each other what features they support.
  --     --  By default, Neovim doesn't support everything that is in the LSP specification.
  --     --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --     --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  --     local capabilities = vim.lsp.protocol.make_client_capabilities()
  --     capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
  --
  --     -- Enable the following language servers
  --     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --     --
  --     --  Add any additional override configuration in the following tables. Available keys are:
  --     --  - cmd (table): Override the default command used to start the server
  --     --  - filetypes (table): Override the default list of associated filetypes for the server
  --     --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --     --  - settings (table): Override the default settings passed when initializing the server.
  --     --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  --     local servers = {
  --       -- clangd = {},
  --       -- gopls = {},
  --       -- pyright = {},
  --       -- rust_analyzer = {},
  --       -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --       --
  --       -- Some languages (like typescript) have entire language plugins that can be useful:
  --       --    https://github.com/pmizio/typescript-tools.nvim
  --       --
  --       -- But for many setups, the LSP (`ts_ls`) will work just fine
  --       -- ts_ls = {},
  --       --
  --
  --       lua_ls = {
  --         -- cmd = {...},
  --         -- filetypes = { ...},
  --         -- capabilities = {},
  --         settings = {
  --           Lua = {
  --             completion = {
  --               callSnippet = "Replace",
  --             },
  --             -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
  --             -- diagnostics = { disable = { 'missing-fields' } },
  --           },
  --         },
  --       },
  --     }
  --
  --     -- Ensure the servers and tools above are installed
  --     --  To check the current status of installed tools and/or manually install
  --     --  other tools, you can run
  --     --    :Mason
  --     --
  --     --  You can press `g?` for help in this menu.
  --     require("mason").setup()
  --
  --     -- You can add other tools here that you want Mason to install
  --     -- for you, so that they are available from within Neovim.
  --     local ensure_installed = vim.tbl_keys(servers or {})
  --     vim.list_extend(ensure_installed, {
  --       "stylua", -- Used to format Lua code
  --     })
  --     require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  --
  --     require("mason-lspconfig").setup({
  --       handlers = {
  --         function(server_name)
  --           local server = servers[server_name] or {}
  --           -- This handles overriding only values explicitly passed
  --           -- by the server configuration above. Useful when disabling
  --           -- certain features of an LSP (for example, turning off formatting for ts_ls)
  --           server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
  --           require("lspconfig")[server_name].setup(server)
  --         end,
  --       },
  --     })
  --   end,
  -- },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup autoformat
      LazyVim.format.register(LazyVim.lsp.formatter())

      -- setup keymaps
      LazyVim.lsp.on_attach(function(client, buffer)
        require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      LazyVim.lsp.setup()
      LazyVim.lsp.on_dynamic_capability(require("lazyvim.plugins.lsp.keymaps").on_attach)

      -- diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      if vim.fn.has("nvim-0.10") == 1 then
        -- inlay hints
        if opts.inlay_hints.enabled then
          LazyVim.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
            if
              vim.api.nvim_buf_is_valid(buffer)
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
          end)
        end

        -- code lens
        if opts.codelens.enabled and vim.lsp.codelens then
          LazyVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = buffer,
              callback = vim.lsp.codelens.refresh,
            })
          end)
        end
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            local icons = LazyVim.config.icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end

      if LazyVim.lsp.is_enabled("denols") and LazyVim.lsp.is_enabled("vtsls") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        LazyVim.lsp.disable("vtsls", is_deno)
        LazyVim.lsp.disable("denols", function(root_dir, config)
          if not is_deno(root_dir) then
            config.settings.deno.enable = false
          end
          return false
        end)
      end
    end,
  },
}
