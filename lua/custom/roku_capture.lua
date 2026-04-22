local M = {}

function M.capture()
  local bsconfig_path = vim.fn.findfile("bsconfig-local.json", ".;")
  if bsconfig_path == "" then
    vim.notify("No bsconfig-local.json found", vim.log.levels.WARN)
    return
  end

  local cwd = vim.fn.fnamemodify(bsconfig_path, ":p:h")

  if Snacks then
    Snacks.terminal.open("rocapture", { cwd = cwd, interactive = false, auto_close = true })
  else
    vim.cmd("split | term rocapture")
  end
end

return M
