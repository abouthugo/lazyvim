local M = {}

function M.run_script()
  -- 1. Find package.json
  local pkg_path = vim.fn.findfile("package.json", ".;")
  if pkg_path == "" then
    vim.notify("No package.json found", vim.log.levels.WARN)
    return
  end

  -- 2. Read and parse scripts
  local content = vim.fn.readfile(pkg_path)
  local data = vim.json.decode(table.concat(content, ""))
  local scripts = data.scripts or {}

  if vim.tbl_isempty(scripts) then
    vim.notify("No scripts found in package.json", vim.log.levels.INFO)
    return
  end

  -- 3. Prepare items for the picker
  local script_names = vim.tbl_keys(scripts)
  table.sort(script_names)

  -- 4. Use the built-in Neovim UI Select
  vim.ui.select(script_names, {
    prompt = "Select npm script to run:",
    kind = "npm_scripts", -- Helps plugins like dressing.nvim customize the UI
    format_item = function(item)
      return string.format("%-15s │ %s", item, scripts[item])
    end,
  }, function(choice)
    if choice then
      local full_cmd = "npm run " .. choice

      -- 5. Execute in Snacks Terminal (Standard in LazyVim)
      if Snacks then
        Snacks.terminal.open(full_cmd, { interactive = true })
      else
        vim.cmd("split | term " .. full_cmd)
        vim.cmd("startinsert")
      end
    end
  end)
end

return M
