return {
  -- 1. Ensure tinymist is installed via Mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "tinymist",
      },
    },
  },

  -- 2. Configure the LSP (tinymist)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            formatterMode = "typstyle",
            exportPdf = "onSave", -- Compiles to PDF only when you save
          },
        },
      },
    },
  },

  -- 3. Live Preview Plugin
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function()
      require("typst-preview").update()
    end,
    keys = {
      { "<leader>tp", "<cmd>TypstPreview<cr>", desc = "Typst Preview (Start)" },
      { "<leader>ts", "<cmd>TypstPreviewStop<cr>", desc = "Typst Preview (Stop)" },
      { "<leader>tt", "<cmd>TypstPreviewToggle<cr>", desc = "Typst Preview (Toggle)" },
      { "<leader>tc", "<cmd>TypstPreviewSyncCursor<cr>", desc = "Typst Sync Cursor" },
    },
  },
}
