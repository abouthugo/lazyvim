# Roku Registry Paste — Design Spec

## Goal

Add a Neovim keybind (`<leader>jr`) that lets the user interactively select a section
and key from the Roku device registry, then pastes the value at the current cursor
position in the buffer.

## Architecture

A new custom Lua module `lua/custom/roku_registry.lua` exposes a single public
function `M.paste_value()`. The function is wired to `<leader>jr` in
`lua/config/keymaps.lua`. All HTTP and XML work is done via non-interactive
`vim.fn.system()` calls to `curl` and `xmllint` (same dependencies the original
shell script required). Interactive selection is handled by two chained
`vim.ui.select` calls, which integrate with Snacks/Telescope natively.

## Module: `lua/custom/roku_registry.lua`

### `M.paste_value()` flow

1. `vim.fn.findfile("bsconfig-local.json", ".;")` — warn + return if not found.
2. `vim.fn.readfile()` + `vim.json.decode()` — read host. Error if `host` missing.
3. `vim.fn.system("curl -sf --connect-timeout 5 --max-time 10 'http://<host>:8060/query/registry/dev'")` — error if curl fails or empty.
4. Pipe XML into `xmllint --xpath 'string(//status)' -` via `vim.fn.system`. Error if status != `"OK"`.
5. Extract section names via `xmllint --xpath '//section/name/text()' -`, split on newlines.
6. `vim.ui.select(sections, { prompt = "Section> " }, callback)` — return silently on cancel.
7. Inside callback: extract keys for selected section via `xmllint --xpath`.
8. `vim.ui.select(keys, { prompt = "Key> " }, callback)` — return silently on cancel.
9. Inside callback: extract value via `xmllint --xpath "string(...)"`.
10. `vim.api.nvim_put({ value }, "c", true, true)` — insert at cursor.

### Error handling

- All errors: `vim.notify(msg, vim.log.levels.ERROR)` + early return.
- Cancelled pickers: silent return (no notification).
- No `pcall` — consistent with existing custom modules.

## Keybind

```lua
local roku_registry = require("custom.roku_registry")
vim.keymap.set("n", "<leader>jr", roku_registry.paste_value, { desc = "Roku: paste registry value" })
```

Added at the bottom of `lua/config/keymaps.lua`, after the existing `roku_capture` block.

## Dependencies

- `curl` (already required by roregistry shell script)
- `xmllint` / libxml2 (already required by roregistry shell script)
- `jq` is NOT needed — JSON parsing is done natively via `vim.json.decode`
- `fzf` is NOT needed — replaced by `vim.ui.select`
