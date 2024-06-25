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
            -- Gray like: Text, Overlay 0, Overlay 1, Overlay 2
            Comment = { fg = cp.overlay0 }, -- just comments
            SpecialComment = { link = "Special" }, -- special things inside a comment
            Text = { fg = cp.text },
            Identifier = { fg = cp.text }, -- (preferred) any variable name
            ["@field"] = { fg = cp.text },
            ["@variable"] = { fg = cp.text },
            ["@property"] = { fg = cp.text },
            ["@parameter"] = { fg = cp.text, style = {} },
            ["@variable.member"] = { fg = cp.text },
            ["@variable.builtin"] = { fg = cp.text },
            ["@tag.attribute"] = { link = "Identifier" },
            ["@punctuation.bracket"] = { link = "Text" },

            -- Purple like: Mauve, Lavender
            Boolean = { fg = cp.lavender }, --  a boolean constant: TRUE, false
            Constant = { fg = cp.mauve }, -- (preferred) any constant

            -- Green like: Green, Teal
            String = { fg = cp.green }, -- a string constant: "this is a string"
            Character = { fg = cp.teal }, --  a character constant: 'c', '\n'
            ["@string.regexp"] = { link = "String" },
            ["@string.escape"] = { link = "Character" },
            ["@constant.regex"] = { link = "Character" },
            ["@operator.regex"] = { link = "Character" },
            ["@property.regex"] = { link = "Character" },
            ["@punctuation.bracket.regex"] = { link = "Character" },
            ["@punctuation.delimiter.regex"] = { link = "Character" },

            -- Blue like: Blue, Sky, Sapphire
            Number = { fg = cp.sky }, --   a number constant: 234, 0xff
            Float = { fg = cp.sky }, --    a floating point constant: 2.3e10

            -- Orange like: Peach, Flamingo
            Conditional = { fg = cp.peach, style = {} }, --  if, then, else, endif, switch, etc.
            Repeat = { fg = cp.peach }, --   for, do, while, etc.
            Label = { fg = cp.peach }, --    case, default, etc.
            Exception = { fg = cp.peach }, --  try, catch, throw
            Keyword = { fg = cp.peach }, --  any other keyword
            StorageClass = { fg = cp.peach }, -- static, register, volatile, etc.
            Structure = { fg = cp.yellow }, --  struct, union, enum, etc.
            Operator = { fg = cp.flamingo }, -- "sizeof", "+", "*", etc.
            Type = { fg = cp.flamingo }, -- (preferred) int, long, char, etc.
            Typedef = { link = "Type" }, --  A typedef
            ["@type.builtin"] = { link = "Type" },
            ["@namespace"] = { fg = cp.peach, style = {} },
            ["@constructor"] = { fg = cp.peach },
            ["@keyword.return"] = { fg = cp.peach },
            ["@keyword.function"] = { fg = cp.peach },
            ["@keyword.operator"] = { fg = cp.peach },

            Tag = { fg = cp.peach, style = {} }, -- you can use CTRL-] on this
            ["@tag"] = { link = "Tag" },
            ["@tag.delimiter"] = { link = "Tag" },

            -- Red like: Red, Marron, Pink
            Macro = { fg = cp.maroon }, -- same as Define
            PreProc = { link = "Macro" }, -- (preferred) generic Preprocessor
            Include = { link = "Macro" }, --  preprocessor #include
            Define = { link = "Macro" }, -- preprocessor #define
            PreCondit = { link = "Macro" }, -- preprocessor #if, #else, #endif, etc.
            Special = { fg = cp.red }, -- (preferred) any special symbol
            SpecialChar = { link = "Special" }, -- special character in a constant
            Debug = { link = "Special" }, -- debugging statements
            ["@constant.builtin"] = { link = "Macro", style = {} },

            -- Yellow like: Yellow, Rosewater
            Function = { fg = cp.yellow }, -- function name (also: methods for classes)
            Statement = { fg = cp.yellow }, -- (preferred) any statement
            Delimiter = { fg = cp.rosewater }, -- character that needs attention
            ["@variable.parameter"] = { fg = cp.rosewater, style = {} },

            -- Todo, fixme
            TodoFgTODO = { fg = cp.mauve },
            TodoBgTODO = { bg = cp.mauve },

            -- Bash
            ["@keyword.import.bash"] = { link = "Keyword" },
            ["@function.call.bash"] = { link = "Text" },
            ["@function.builtin.bash"] = { link = "Macro" },

            -- Lua
            ["@keyword.luadoc"] = { link = "Comment" },

            -- Pyhton
            ["@constructor.python"] = { fg = cp.yellow },
            ["@punctuation.special.python"] = { fg = cp.teal },
            ["@function.method.call.python"] = { link = "Text" },
            ["@string.documentation.python"] = { link = "Comment", style = { "italic" } },

            -- Java
            ["javaFold"] = { link = "Delimiter" },
            ["javaParen"] = { link = "Delimiter" },
            ["javaConceptKind"] = { link = "Keyword" },
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
