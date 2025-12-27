return {
  {
    "NickvanDyke/opencode.nvim",
    event = "VeryLazy",
    dependencies = {
      { "folke/snacks.nvim", optional = true },
    },
    config = function()
      -- 1. Correct Configuration Method
      vim.g.opencode_opts = {
        provider = {
          enabled = "snacks", -- Use snacks terminal
        },
        events = {
          reload = true, -- Auto-reload buffers
        },
      }
      vim.o.autoread = true
      -- 2. Keymaps (Using <leader>o prefix to be consistent)
      local map = vim.keymap.set
      -- Toggle: <leader>oa
      map({ "n", "t" }, "<leader>oa", function()
        require("opencode").toggle()
      end, { desc = "Opencode Toggle" })
      -- Ask: <leader>ok
      map({ "n", "x" }, "<leader>ok", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Opencode Ask" })
      -- Actions: <leader>ox
      map({ "n", "x" }, "<leader>ox", function()
        require("opencode").select()
      end, { desc = "Opencode Actions" })
      -- 3. Operators (Keep 'go' as it's idiomatic)
      map({ "n", "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { expr = true, desc = "Add range to Opencode" })
      map("n", "goo", function()
        return require("opencode").operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to Opencode" })
    end,
  },
}
