-- Plugin overrides and additions on top of LazyVim defaults.
-- LazyVim "extras" (typescript, json, mini-starter, etc.) are tracked in
-- lazyvim.json — manage them with `:LazyExtras`.

return {
  -- Colorscheme: match Ghostty's Catppuccin Mocha + let its background opacity show through
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = { enabled = true },
        mason = true,
        native_lsp = { enabled = true },
        which_key = true,
        mini = { enabled = true },
      },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-mocha" } },

  -- Disable trouble (delete this line to re-enable)
  { "folke/trouble.nvim", enabled = false },

  -- Add emoji completion to nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- Telescope: prompt on top, plus a "find plugin file" mapping
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- Add pyright
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
      },
    },
  },

  -- Extend treesitter parsers (does not overwrite LazyVim defaults)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },

  -- Mason: extra tools (note: package was renamed williamboman -> mason-org)
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
