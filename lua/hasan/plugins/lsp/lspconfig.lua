return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
  },
  config = function()
    -- plugins
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap

    -- keymaps on attach
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    -- capabilities (standardize offset encoding to avoid warnings)
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local PREFERRED_OFFSET = "utf-16" -- <- pick one; utf-16 is safest across servers
    capabilities.offsetEncoding = { PREFERRED_OFFSET }

    -- ensure each client uses the same encoding
    local function force_offset_encoding(client)
      client.offset_encoding = PREFERRED_OFFSET
    end

    -- diagnostic signs (prefer new API, fallback to legacy if unavailable)
    do
      local icons = { Error = "", Warn = "", Hint = "󰠠", Info = "" }
      if vim.diagnostic and type(vim.diagnostic.define_sign) == "function" then
        vim.diagnostic.define_sign("Error", { text = icons.Error, texthl = "DiagnosticSignError" })
        vim.diagnostic.define_sign("Warn", { text = icons.Warn, texthl = "DiagnosticSignWarn" })
        vim.diagnostic.define_sign("Hint", { text = icons.Hint, texthl = "DiagnosticSignHint" })
        vim.diagnostic.define_sign("Info", { text = icons.Info, texthl = "DiagnosticSignInfo" })
      else
        for type, icon in pairs(icons) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end
      end
    end

    -- handlers live inside mason_lspconfig.setup({ handlers = { ... } })
    mason_lspconfig.setup({
      handlers = {
        -- default handler for any installed server not explicitly configured below
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_init = force_offset_encoding,
          })
        end,

        -- svelte
        ["svelte"] = function()
          lspconfig.svelte.setup({
            capabilities = capabilities,
            on_init = force_offset_encoding,
            on_attach = function(client, _)
              vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.js", "*.ts" },
                callback = function(ctx)
                  client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                end,
              })
            end,
          })
        end,

        -- graphql
        ["graphql"] = function()
          lspconfig.graphql.setup({
            capabilities = capabilities,
            on_init = force_offset_encoding,
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
          })
        end,

        -- emmet
        ["emmet_ls"] = function()
          lspconfig.emmet_ls.setup({
            capabilities = capabilities,
            on_init = force_offset_encoding,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
          })
        end,

        -- lua
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_init = force_offset_encoding,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                completion = { callSnippet = "Replace" },
              },
            },
          })
        end,
      },
    })
  end,
}
