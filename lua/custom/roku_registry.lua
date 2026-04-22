local M = {}

-- Run a shell command and return trimmed stdout, or nil on failure.
local function sh(cmd)
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

-- Split a string on newlines, discarding blank lines.
local function split_lines(s)
  local lines = {}
  for line in s:gmatch("[^\n]+") do
    local trimmed = vim.trim(line)
    if trimmed ~= "" then
      table.insert(lines, trimmed)
    end
  end
  return lines
end

function M.paste_value()
  -- 1. Locate bsconfig-local.json
  local bsconfig_path = vim.fn.findfile("bsconfig-local.json", ".;")
  if bsconfig_path == "" then
    vim.notify("No bsconfig-local.json found", vim.log.levels.WARN)
    return
  end

  -- 2. Read host from config
  local content = vim.fn.readfile(bsconfig_path)
  local ok, data = pcall(vim.json.decode, table.concat(content, ""))
  if not ok or type(data) ~= "table" then
    vim.notify("Failed to parse bsconfig-local.json", vim.log.levels.ERROR)
    return
  end
  local host = data.host
  if not host or host == "" then
    vim.notify("'host' field not found in bsconfig-local.json", vim.log.levels.ERROR)
    return
  end

  -- 3. Fetch registry XML
  local url = "http://" .. host .. ":8060/query/registry/dev"
  local xml = sh("curl -sf --connect-timeout 5 --max-time 10 " .. vim.fn.shellescape(url))
  if not xml or xml == "" then
    vim.notify("Could not reach Roku device at " .. host, vim.log.levels.ERROR)
    return
  end

  -- 4. Validate status
  local status = sh("echo " .. vim.fn.shellescape(xml) .. " | xmllint --xpath 'string(//status)' -")
  if status ~= "OK" then
    local err_msg = sh("echo " .. vim.fn.shellescape(xml) .. " | xmllint --xpath 'string(//error)' -") or ""
    vim.notify("Registry error: " .. (err_msg ~= "" and err_msg or "status=" .. (status or "?")), vim.log.levels.ERROR)
    return
  end

  -- 5. Extract section names
  local sections_raw = sh("echo " .. vim.fn.shellescape(xml) .. " | xmllint --xpath '//section/name/text()' -")
  if not sections_raw or sections_raw == "" then
    vim.notify("No registry sections found", vim.log.levels.INFO)
    return
  end
  local sections = split_lines(sections_raw)

  -- 6. First picker: select section
  vim.ui.select(sections, { prompt = "Section> " }, function(section)
    if not section then
      return
    end

    -- 7. Extract keys for selected section
    local xpath = '//section[name="' .. section .. '"]/items/item/key/text()'
    local keys_raw = sh("echo " .. vim.fn.shellescape(xml) .. " | xmllint --xpath " .. vim.fn.shellescape(xpath) .. " -")
    if not keys_raw or keys_raw == "" then
      vim.notify("No items found in section '" .. section .. "'", vim.log.levels.INFO)
      return
    end
    local keys = split_lines(keys_raw)

    -- 8. Second picker: select key
    vim.ui.select(keys, { prompt = "Key> " }, function(key)
      if not key then
        return
      end

      -- 9. Extract value
      local val_xpath = 'string(//section[name="' .. section .. '"]/items/item[key="' .. key .. '"]/value)'
      local value = sh("echo " .. vim.fn.shellescape(xml) .. " | xmllint --xpath " .. vim.fn.shellescape(val_xpath) .. " -")
      if not value then
        vim.notify("Failed to extract value for " .. section .. "/" .. key, vim.log.levels.ERROR)
        return
      end

      -- 10. Paste at cursor
      vim.api.nvim_put({ value }, "c", true, true)
    end)
  end)
end

return M
