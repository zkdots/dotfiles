# AGENTS.md

## Project Type
LazyVim Neovim configuration. Plugins in `lua/plugins/`, config in `lua/config/`.

## Commands
- **Format:** `stylua .` (2-space indent, 120 col width per stylua.toml)
- **Validate:** Open Neovim and run `:checkhealth`
- **Reload plugins:** `:Lazy sync`

## LazyVim Plugin Patterns
- Each file in `lua/plugins/` returns a table of plugin specs (auto-loaded by lazy.nvim)
- To extend a LazyVim plugin: use same plugin name with `opts` table (merged automatically)
- To extend lists (not merged by `vim.tbl_deep_extend`): use `opts = function(_, opts)` and `vim.list_extend()` or `table.insert()`
- To disable a plugin: `{ "plugin/name", enabled = false }`
- To import LazyVim extras: `{ import = "lazyvim.plugins.extras.lang.typescript" }`
- Defensive nil checks when extending: `opts.x = opts.x or {}`

## Code Style
- Local requires at top of `config` functions: `local foo = require("foo")`
- Keymaps include `desc` field for which-key integration
- Files: `kebab-case.lua`, variables: `snake_case`
