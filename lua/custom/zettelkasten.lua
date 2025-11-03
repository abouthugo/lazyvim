local M = {}

function M.create_note()
  vim.ui.input({ prompt = "Note name: " }, function(input)
    if not input or input == "" then
      return
    end

    local filename = input:match("%.md$") and input or input .. ".md"
    local zettel_dir = vim.fn.finddir("00 - Zettelkasten", vim.fn.getcwd() .. ";")

    if zettel_dir == "" then
      vim.notify("Zettelkasten folder not found", vim.log.levels.ERROR)
      return
    end

    vim.cmd("edit " .. zettel_dir .. "/" .. filename)
  end)
end

return M
