return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end

    wk.setup()

    ----------------------------------------------------------------------
    -- Global <leader> mappings (list-form spec)
    ----------------------------------------------------------------------
    wk.add({
      -- housekeeping
      { "<leader>nh", ":nohl<CR>",                               desc = "Clear search highlights" },
      { "<leader>+",  "<C-a>",                                   desc = "Increment number" },
      { "<leader>-",  "<C-x>",                                   desc = "Decrement number" },

      -- splits
      { "<leader>s",  group = "splits" },
      { "<leader>sv", "<C-w>v",                                  desc = "Split window vertically" },
      { "<leader>sh", "<C-w>s",                                  desc = "Split window horizontally" },
      { "<leader>se", "<C-w>=",                                  desc = "Make splits equal size" },
      { "<leader>sx", "<cmd>close<CR>",                          desc = "Close current split" },
      { "<leader>sm", "<cmd>MaximizerToggle<CR>",                desc = "Maximize/minimize a split" },

      -- tabs
      { "<leader>t",  group = "tabs" },
      { "<leader>to", "<cmd>tabnew<CR>",                         desc = "Open new tab" },
      { "<leader>tx", "<cmd>tabclose<CR>",                       desc = "Close current tab" },
      { "<leader>tn", "<cmd>tabn<CR>",                           desc = "Next tab" },
      { "<leader>tp", "<cmd>tabp<CR>",                           desc = "Previous tab" },
      { "<leader>tf", "<cmd>tabnew %<CR>",                       desc = "Open current buffer in new tab" },

      -- workspace/session
      { "<leader>w",  group = "workspace" },
      { "<leader>wr", "<cmd>SessionRestore<CR>",                 desc = "Restore session for cwd" },
      { "<leader>ws", "<cmd>SessionSave<CR>",                    desc = "Save session for cwd" },

      -- file explorer (nvim-tree)
      { "<leader>e",  group = "explorer" },
      { "<leader>ee", "<cmd>NvimTreeToggle<CR>",                 desc = "Toggle file explorer" },
      { "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>",         desc = "Toggle on current file" },
      { "<leader>ec", "<cmd>NvimTreeCollapse<CR>",               desc = "Collapse file explorer" },
      { "<leader>er", "<cmd>NvimTreeRefresh<CR>",                desc = "Refresh file explorer" },

      -- telescope finders
      { "<leader>f",  group = "find" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",           desc = "Fuzzy find files in cwd" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",             desc = "Fuzzy find recent files" },
      { "<leader>fs", "<cmd>Telescope live_grep<cr>",            desc = "Find string in cwd" },
      { "<leader>fc", "<cmd>Telescope grep_string<cr>",          desc = "Find string under cursor" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>",                  desc = "Find TODOs" },

      -- lint / format
      { "<leader>l",  "<cmd>lua require('lint').try_lint()<CR>", desc = "Trigger linting for current file" },
      { "<leader>m",  group = "misc" },
      {
        "<leader>mp",
        "<cmd>lua require('conform').format({lsp_fallback=true,async=false,timeout_ms=1000})<CR>",
        desc = "Format file or range"
      },

      -- diagnostics list (trouble)
      { "<leader>x",  group = "trouble" },
      { "<leader>xx", "<cmd>TroubleToggle<CR>",                       desc = "Toggle trouble list" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>",  desc = "Document diagnostics" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<CR>",              desc = "Quickfix" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<CR>",               desc = "Location list" },
      { "<leader>xt", "<cmd>TodoTrouble<CR>",                         desc = "TODOs in trouble" },
    })

    ----------------------------------------------------------------------
    -- Non-leader globals (list-form)
    ----------------------------------------------------------------------
    wk.add({
      { "jk",    desc = "Exit insert mode",              mode = "i" },

      -- substitute.nvim
      { "s",     desc = "Substitute with motion" },
      { "ss",    desc = "Substitute line" },
      { "S",     desc = "Substitute to end of line" },
      { "s",     desc = "Substitute in visual mode",     mode = "x" },

      -- todo-comments jumps
      { "]t",    desc = "Next TODO comment" },
      { "[t",    desc = "Previous TODO comment" },

      -- jump list navigation
      { "<C-o>", desc = "Go back (jump list back)" },
      { "<C-i>", desc = "Go forward (jump list forward)" },
    })

    ----------------------------------------------------------------------
    -- LSP buffer-local labels on attach (list-form + buffer-scoped)
    ----------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("WhichKeyLspHints", { clear = true }),
      callback = function(ev)
        wk.add({
          -- goto group
          { "g",          group = "+goto",               buffer = ev.buf },
          { "gR",         desc = "LSP References",       buffer = ev.buf },
          { "gD",         desc = "LSP Declaration",      buffer = ev.buf },
          { "gd",         desc = "LSP Definitions",      buffer = ev.buf },
          { "gi",         desc = "LSP Implementations",  buffer = ev.buf },
          { "gt",         desc = "LSP Type Definitions", buffer = ev.buf },

          -- singles outside leader
          { "K",          desc = "Hover Docs",           buffer = ev.buf },
          { "[d",         desc = "Prev Diagnostic",      buffer = ev.buf },
          { "]d",         desc = "Next Diagnostic",      buffer = ev.buf },

          -- leader LSP actions
          { "<leader>c",  group = "code",                buffer = ev.buf },
          { "<leader>ca", desc = "Code Action",          buffer = ev.buf },
          { "<leader>r",  group = "rename/restart",      buffer = ev.buf },
          { "<leader>rn", desc = "Rename",               buffer = ev.buf },
          { "<leader>rs", desc = "Restart LSP",          buffer = ev.buf },
          { "<leader>D",  desc = "Diagnostics (buffer)", buffer = ev.buf },
          { "<leader>d",  desc = "Diagnostics (line)",   buffer = ev.buf },
        })
      end,
    })
  end,
}
