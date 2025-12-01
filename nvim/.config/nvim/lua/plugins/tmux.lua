return {
  -- tmux-aware split navigation
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1 -- Disable auto-mappings to avoid LazyVim override
    end,
  }, -- no opts needed for defaults [web:22]
  -- LuaLS helper for better Lua typing; preloads plenary types
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- exposes plenary modules to LuaLS when editing Lua
        { path = "${3rd}/plenary.nvim/lua", words = { "plenary" } },
      },
    },
  },
}
