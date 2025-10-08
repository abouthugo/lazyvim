-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.filetype.add({
  extension = {
    brs = "brightscript",
    bs = "brightscript",
  },
})

vim.opt.backupext = ".bak"

vim.g.lazyvim_mini_snippets_in_completion = true
