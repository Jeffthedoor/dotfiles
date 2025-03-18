return {
  -- UI
  { "ellisonleao/gruvbox.nvim" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  { "stevearc/dressing.nvim", event = "VeryLazy" },

  --GITSIGNS
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  --LANGs
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.java" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.git" },

  --EXTRA TOOLS
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- "stylua",
        -- "shellcheck",
        -- "shfmt",
        -- "flake8",
      },
    },
  },

  { "otavioschwanck/cool-substitute.nvim", lazy = false, opts = {
    setup_keybindings = true,
  } },

  { "github/copilot.vim", lazy = false },
}
