return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      bright_script = {
        cmd = {
          "bsc",
          "--lsp",
          "--stdio",
        },
        filetypes = { "brightscript", "brs" },
        single_file_support = true,
        root_markers = { "makefile", "Makefile", ".git" },
        -- Provide empty objects for the configuration sections the server requested
        settings = {
          brightscript = {},
          files = {},
        },
      },
    },
  },
}
