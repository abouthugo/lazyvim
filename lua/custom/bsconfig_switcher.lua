local M = {}

local PROFILES = {
  work = "10.0.0.179",
  home = "10.0.0.238",
}

-- vim.fn.json_encode produces compact JSON; this formats it with 2-space indentation.
local function pretty_json(obj)
  local lines = { "{" }
  local keys = vim.tbl_keys(obj)
  table.sort(keys)
  for i, key in ipairs(keys) do
    local comma = i < #keys and "," or ""
    lines[#lines + 1] = string.format('  "%s": "%s"%s', key, obj[key], comma)
  end
  lines[#lines + 1] = "}"
  return table.concat(lines, "\n") .. "\n"
end

local function write_profile(host)
  local password = vim.fn.getenv("ROKU_DEV_PASSWORD")
  -- vim.fn.getenv returns vim.NIL (not nil) when the variable is unset
  if not password or password == vim.NIL or password == "" then
    vim.notify("ROKU_DEV_PASSWORD is not set", vim.log.levels.ERROR)
    return
  end

  local path = vim.fn.getcwd() .. "/bsconfig-local.json"
  local file = io.open(path, "w")
  if not file then
    vim.notify("Could not write " .. path, vim.log.levels.ERROR)
    return
  end

  file:write(pretty_json({ host = host, password = password }))
  file:close()
  vim.notify("bsconfig-local.json → host set to " .. host, vim.log.levels.INFO)
end

function M.switch_to_work()
  write_profile(PROFILES.work)
end

function M.switch_to_home()
  write_profile(PROFILES.home)
end

return M
