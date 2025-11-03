-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local zettel_dir = vim.fn.finddir("00 - Zettelkasten", vim.fn.getcwd() .. ";")

if zettel_dir ~= "" then
  local zettel = require("custom.zettelkasten")
  vim.keymap.set("n", "<leader>fz", zettel.create_note, { desc = "Create Zettelkasten note" })
end
