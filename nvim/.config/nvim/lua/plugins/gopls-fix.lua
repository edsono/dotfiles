return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      gopls = function(_, opts)
        opts.capabilities = opts.capabilities or {}
        opts.capabilities.textDocument = opts.capabilities.textDocument or {}
        opts.capabilities.textDocument.semanticTokens = opts.capabilities.textDocument.semanticTokens or {}

        require("lspconfig").gopls.setup(opts)

        return true
      end,
    },
  },
}
