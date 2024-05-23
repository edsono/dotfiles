-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    -- you can do it like this with a config function
    config = function()
      require("catppuccin").setup({
        -- configurations
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        styles = {
          comments = { "italic" },
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false
        },
        color_overrides = {
          mocha = {
            base = "#070710",
          },
        },
        custom_highlights = function(cp)
          return {
            -- Gray like: Overlay 0, Overlay 1, Overlay 2
            Comment = { fg = cp.overlay0 }, -- just comments
            SpecialComment = { link = "Special" }, -- special things inside a comment
            Identifier = { fg = cp.text }, -- (preferred) any variable name

            -- Purple like: Mauve, Lavender
            Constant = { fg = cp.mauve }, -- (preferred) any constant
            Boolean = { fg = cp.mauve }, --  a boolean constant: TRUE, false

            -- Green like: Green, Teal
            String = { fg = cp.green }, -- a string constant: "this is a string"
            Character = { fg = cp.teal }, --  a character constant: 'c', '\n'

            -- Blue like: Blue, Sky, Sapphire
            Number = { fg = cp.sky }, --   a number constant: 234, 0xff
            Float = { fg = cp.sky }, --    a floating point constant: 2.3e10

            -- Orange like: Yellow, Peach, Rosewater
            Function = { fg = cp.text }, -- function name (also: methods for classes)
            Statement = { fg = cp.peach }, -- (preferred) any statement
            Conditional = { fg = cp.peach, style = {} }, --  if, then, else, endif, switch, etc.
            Repeat = { fg = cp.peach }, --   for, do, while, etc.
            Label = { fg = cp.peach }, --    case, default, etc.
            Exception = { fg = cp.peach }, --  try, catch, throw
            Keyword = { fg = cp.peach }, --  any other keyword
            Operator = { fg = cp.rosewater }, -- "sizeof", "+", "*", etc.

            -- Red like: Red, Marron, Pink
            PreProc = { fg = cp.red }, -- (preferred) generic Preprocessor
            Include = { fg = cp.red }, --  preprocessor #include
            Define = { link = "PreProc" }, -- preprocessor #define
            Macro = { fg = cp.red }, -- same as Define
            PreCondit = { link = "PreProc" }, -- preprocessor #if, #else, #endif, etc.

            -- Yellow like: Yellow, Flamingo
            StorageClass = { fg = cp.flamingo }, -- static, register, volatile, etc.
            Structure = { fg = cp.yellow }, --  struct, union, enum, etc.
            Special = { fg = cp.yellow }, -- (preferred) any special symbol
            Type = { fg = cp.flamingo }, -- (preferred) int, long, char, etc.
            Typedef = { link = "Type" }, --  A typedef

            SpecialChar = { link = "Special" }, -- special character in a constant
            Tag = { fg = cp.lavender, style = { "bold" } }, -- you can use CTRL-] on this
            Delimiter = { fg = cp.overlay2 }, -- character that needs attention
            Debug = { link = "Special" }, -- debugging statements

            TodoFgTODO = { fg = cp.mauve },
            TodoBgTODO = { bg = cp.mauve },

            ["@field"] = { fg = cp.text },
            ["@variable"] = { fg = cp.text },
            ["@property"] = { fg = cp.text },
            ["@parameter"] = { fg = cp.rosewater, style = {} },
            ["@namespace"] = { fg = cp.rosewater, style = {} },

            ["@constructor"] = { fg = cp.flamingo },
            ["@type.builtin"] = { fg = cp.flamingo },
            ["@variable.builtin"] = { fg = cp.flamingo, style = {} },
            ["@constant.builtin"] = { fg = cp.flamingo, style = {} },

            ["@string.escape"] = { fg = cp.teal },
            ["@constant.regex"] = { fg = cp.teal },
            ["@operator.regex"] = { fg = cp.teal },
            ["@punctuation.bracket.regex"] = { fg = cp.teal },
            ["@string.documentation.python"] = { fg = cp.overlay0, style = { "italic" } },

            ["@keyword.return"] = { fg = cp.peach },
            ["@keyword.function"] = { fg = cp.peach },
            ["@keyword.operator"] = { fg = cp.peach },
          }
        end,
      })
    end,
    -- or just use opts table
    opts = {
      -- configurations
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
