return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree docs
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      -- 🔄 keep tree in sync with where you actually are
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true, -- change tree root to the focused file's dir
      },

      view = {
        width = {
          min = 35,
          max = 50,
          padding = 2,
        },
        relativenumber = true,
      },

      renderer = {
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "→",
              arrow_open = "↓",
            },
          },
        },
      },

      actions = {
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        open_file = {
          window_picker = { enable = false },
        },
      },

      filters = {
        custom = { ".DS_Store" },
      },

      git = {
        ignore = false,
      },
    })

    -- auto-reveal focused file when the tree is visible
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        local ok, api = pcall(require, "nvim-tree.api")
        if ok and api.tree.is_visible() then
          api.tree.find_file({ open = false, focus = false })
        end
      end,
    })

    -- keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
  end,
}
