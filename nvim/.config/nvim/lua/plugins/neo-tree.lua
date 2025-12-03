return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    -- Ensure the filesystem table exists
    opts.filesystem = opts.filesystem or {}
    -- Ensure the filtered_items table exists
    opts.filesystem.filtered_items = opts.filesystem.filtered_items or {}

    -- Now safely set the value
    opts.filesystem.filtered_items.hide_dotfiles = false
  end,
}
