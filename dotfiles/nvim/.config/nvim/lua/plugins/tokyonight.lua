return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "storm",
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = {},
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "dark",
      },
      lualine_bold = true,
      hide_inactive_statusline = true,

      on_colors = function(colors) colors.hint = colors.orange end,
      on_highlights = function(hl, c)
        -- preferred syntax group styles
        hl["@string"] = { fg = "#f6c177" }
        hl["@keyword.import"] = { fg = "#ff7b72" }

        -- darker punctuations
        hl["@punctuation"] = { fg = "#787e96" }
        hl["@punctuation.bracket"] = { link = "@punctuation" }
        hl["@punctuation.delimiter"] = { link = "@punctuation" }

        hl.TelescopeNormal = { bg = "#090c0f", fg = c.fg_dark }
        hl.TelescopeBorder = { bg = "#090c0f", fg = c.bg_dark }
        hl.TelescopePromptNormal = { bg = "#090c0f" }
        hl.TelescopePromptBorder = { bg = "#090c0f", fg = "#11161c" }
        hl.TelescopePromptTitle = { bg = "#090c0f", fg = "#11161c"  }
      end,
    })

    vim.cmd.colorscheme("tokyonight-night")
  end
}
