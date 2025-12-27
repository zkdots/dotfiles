return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        -- Set Opencode as the default chat tool
        default = "opencode",

        -- Define the tool configuration
        tools = {
          opencode = {
            cmd = { "opencode" }, -- MUST be a table (list of strings)
            args = {}, -- Add default args here if needed
            env = {}, -- Add environment variables here if needed
          },
        },
      },
    },
    -- Configure Keymaps
    keys = {
      -- 1. Disable the default toggle key
      { "<C-.>", false },

      -- 2. Set your custom shortcut (Change <leader>oc to your preference)
      {
        "<leader>oc",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Toggle Opencode Chat",
        mode = { "n", "t", "i", "x" },
      },
    },
  },
}
