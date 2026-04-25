return {
  {
    "L3MON4D3/LuaSnip",
    opts = function(_, opts)
      opts.enable_autosnippets = true

      pcall(function()
        require("luasnip.loaders.from_lua").load({
          paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
        })
      end)
    end,
    config = function(_, opts)
      local ls = require("luasnip")
      ls.setup(opts)

      -- Map <Tab> to jump forward
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        else
          -- Fallback to standard Tab behavior if no snippet is active
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
        end
      end, { silent = true, desc = "LuaSnip Jump Forward" })

      -- Map <Shift-Tab> to jump backward
      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true, desc = "LuaSnip Jump Backward" })
    end,
  },
}
