return {

  {

    "wnkz/monoglow.nvim",

    lazy = false,

    priority = 1000,

    config = function()
      require("monoglow").setup({

        on_colors = function(_) end,

        on_highlights = function(h, c)
          -- Make all function tokens use the glow accent

          h.Function = { fg = c.glow, bold = true }

          h["@function"] = { fg = c.glow, bold = true }

          h["@function.call"] = { fg = c.glow }

          h["@method"] = { fg = c.glow }

          h["@method.call"] = { fg = c.glow }

          h.String = { fg = "#6EE0B4" }

          h["@string"] = { fg = "#6EE0B4" }

          h["@variable.builtin"] = { fg = c.glow, bold = true }

          h.LspInlayHint = { fg = "#606060", italic = true }
        end,
      })

      vim.cmd.colorscheme("monoglow")
    end,
  },
}
