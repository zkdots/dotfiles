return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", "<leader>t", vim.cmd.UndotreeToggle, { desc = "toogle undo tree" })
  end,
}
