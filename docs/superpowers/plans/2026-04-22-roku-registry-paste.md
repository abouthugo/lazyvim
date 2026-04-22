# Roku Registry Paste Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create `lua/custom/roku_registry.lua` and wire it to `<leader>jr` so the user can interactively pick a Roku registry section + key and paste the value at cursor.

**Architecture:** A single Lua module uses `vim.fn.system` for non-interactive `curl` and `xmllint` calls, two chained `vim.ui.select` pickers for section/key selection, and `vim.api.nvim_put` to insert the value at cursor. The keybind is added to `keymaps.lua`.

**Tech Stack:** Lua, Neovim API (`vim.fn`, `vim.ui`, `vim.api`), `curl`, `xmllint`

---

### Task 1: Create `lua/custom/roku_registry.lua`

**Files:**
- Create: `lua/custom/roku_registry.lua`

- [ ] **Step 1: Write the module**

Create `/Users/hperdo162@cable.comcast.com/.config/nvim/lua/custom/roku_registry.lua` with this content:

```lua
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
    local xpath = "//section[name='" .. section .. "']/items/item/key/text()"
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
      local val_xpath = "string(//section[name='" .. section .. "']/items/item[key='" .. key .. "']/value)"
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
```

- [ ] **Step 2: Verify Lua syntax**

```bash
luac -p /Users/hperdo162@cable.comcast.com/.config/nvim/lua/custom/roku_registry.lua
```

Expected: no output (clean parse).

- [ ] **Step 3: Commit**

```bash
git -C ~/.config/nvim add lua/custom/roku_registry.lua
git -C ~/.config/nvim commit -m "feat: add roku_registry custom module"
```

---

### Task 2: Wire keybind in `keymaps.lua`

**Files:**
- Modify: `lua/config/keymaps.lua`

- [ ] **Step 1: Add keybind after the existing roku_capture block**

Open `lua/config/keymaps.lua`. After line 21 (the `roku.capture` keymap), append:

```lua

local roku_registry = require("custom.roku_registry")
vim.keymap.set("n", "<leader>jr", roku_registry.paste_value, { desc = "Roku: paste registry value" })
```

The file should end with:

```lua
local roku = require("custom.roku_capture")
vim.keymap.set("n", "<leader>jc", roku.capture, { desc = "Roku: take screenshot" })

local roku_registry = require("custom.roku_registry")
vim.keymap.set("n", "<leader>jr", roku_registry.paste_value, { desc = "Roku: paste registry value" })
```

- [ ] **Step 2: Verify Lua syntax**

```bash
luac -p /Users/hperdo162@cable.comcast.com/.config/nvim/lua/config/keymaps.lua
```

Expected: no output (clean parse).

- [ ] **Step 3: Commit**

```bash
git -C ~/.config/nvim add lua/config/keymaps.lua
git -C ~/.config/nvim commit -m "feat: bind <leader>jr to Roku registry paste"
```

---

### Task 3: Manual smoke test

- [ ] **Step 1: Open Neovim inside a Roku project directory** (one that has `bsconfig-local.json` with a valid `host`)

- [ ] **Step 2: Open any buffer, position cursor where you want the value inserted**

- [ ] **Step 3: Press `<leader>jr`**

Expected: a `Section>` picker appears with section names from the device registry.

- [ ] **Step 4: Select a section**

Expected: a `Key>` picker appears with keys for that section.

- [ ] **Step 5: Select a key**

Expected: the registry value is inserted at cursor position in the buffer.

- [ ] **Step 6: Test cancellation**

Press `<leader>jr`, open the section picker, then press `<Esc>`. Expected: nothing happens, no error notification.

- [ ] **Step 7: Test missing bsconfig**

Run `<leader>jr` from a directory with no `bsconfig-local.json`. Expected: a WARN notification "No bsconfig-local.json found".
