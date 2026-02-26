-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("custom.search")

-- MarkDown Preview custom css
-- vim.g.mkdp_theme = "light"
vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/css/github-markdown.css")
vim.g.mkdp_highlight_css = vim.fn.expand("~/.config/nvim/css/highlight.css")
