return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      bright_script = {
        cmd = {
          "bsc",
          "--lsp",
          "--stdio",
        },
        filetypes = { "brightscript", "brs", "bs" },
        log_level = "TRACE",
        single_file_support = true,
        root_markers = { "bsconfig.json", "makefile", "Makefile", ".git" },
        -- Provide empty objects for the configuration sections the server requested
        settings = {
          brightscript = {
            diagnostics = {
              enabled = true,
            },
          },
          files = {},
        },
      },
    },
  },
}
