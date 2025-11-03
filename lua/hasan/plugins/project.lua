return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  config = function()
    require("project_nvim").setup({
      -- Let LSP root take priority, then fall back to pattern matching
      detection_methods = { "lsp", "pattern" },
      patterns = {
        ".git",
        "package.json",
        "pyproject.toml",
        "poetry.lock",
        "go.mod",
        "Cargo.toml",
        "Makefile",
      },
      silent_chdir = true, -- don't print cwd messages
      ignore_lsp = {},     -- add LSP names here if you want to exclude them
      manual_mode = false, -- automatically detect project roots
    })

    -- Optional: add Telescope integration for quickly switching projects
    pcall(function()
      require("telescope").load_extension("projects")
    end)
  end,
}
