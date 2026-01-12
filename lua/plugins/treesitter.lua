return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, { "xml" })
    -- Register custom parser
    local parser_config = require("nvim-treesitter.parsers")
    parser_config.brightscript = {
      install_info = {
        url = "https://github.com/abouthugo/tree-sitter-brightscript",
        branch = "feat/brighterscript-support",
        files = { "src/parser.c" },
        revision = "4c01e8bb93acefc55311a07a0a849a295c6b72cd",
      },
      filetype = "brightscript",
      tier = 3,
    }
  end,
}
