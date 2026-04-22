# AGENTS.md — Neovim Configuration

This is a personal Neovim configuration built on [LazyVim](https://lazyvim.org) with custom
plugins, utilities, and BrightScript/Roku development tooling.

---

## Repository Structure

```
lua/config/        # Core Neovim settings (auto-loaded by LazyVim)
  lazy.lua         # Plugin manager bootstrap + lazy.nvim setup
  options.lua      # vim.opt / vim.g settings, custom filetype definitions
  keymaps.lua      # Custom keymaps (loaded on VeryLazy event)
  autocmds.lua     # Custom autocommands (currently a placeholder)

lua/plugins/       # Plugin specs — one file per plugin or logical group
lua/custom/        # Standalone Lua utility modules (not plugin specs)
snippets/          # mini.snippets snippet files (Lua format, per language)
queries/xml/       # Custom Treesitter highlight and injection queries
css/               # Markdown-preview.nvim custom stylesheets
```

---

## Build / Lint / Test

This is a Neovim config, not a compiled project. There is no build step and no
automated test suite.

**Formatting — StyLua:**
```sh
stylua lua/          # format all Lua files
stylua --check lua/  # check without writing (useful in CI)
```

StyLua settings are in `stylua.toml`:
- `indent_type = "Spaces"`, `indent_width = 2`, `column_width = 120`

**No test runner is configured.** Verify changes by launching Neovim and exercising
the affected feature interactively. The `.gitignore` excludes `.tests/` and `tt.*`
in case busted/plenary tests are added in the future.

**Validating Lua syntax without Neovim:**
```sh
luac -p lua/custom/npm_runner.lua   # syntax-check a single file
```

---

## Code Style

### Formatting

- **Indentation:** 2 spaces (never tabs).
- **Line length:** 120 characters max.
- **Formatter:** StyLua. Run it before committing. Use `-- stylua: ignore` inline to
  opt out of formatting on a specific line when necessary.

### File Layout

Every plugin spec file returns a single table or array of tables:

```lua
-- Simple opts override
return {
  "author/plugin.nvim",
  opts = { key = value },
}

-- Explicit setup via config function
return {
  "author/plugin.nvim",
  config = function(_, opts)
    local plugin = require("plugin")
    plugin.setup(opts)
  end,
}

-- Extending parent opts (LazyVim pattern)
return {
  "author/plugin.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.some_list, { "extra_item" })
  end,
}
```

Custom utility modules in `lua/custom/` use the `M` table pattern:

```lua
local M = {}

function M.do_something()
  -- body
end

return M
```

### Imports / Requires

- Require plugin modules **inside** `config` or `opts` functions so they load lazily:
  ```lua
  config = function(_, opts)
    local oil = require("oil")
    oil.setup(opts)
  end
  ```
- Require custom modules at the call site (e.g. in `keymaps.lua`) — not at module
  scope — unless the module is designed to run at startup (like `custom/search.lua`).
- Avoid top-level `require("plugin")` in plugin spec files; `dap.lua` is a known
  exception because the DAP adapter must be registered at startup.

### Naming Conventions

- **snake_case** for all Lua identifiers: variables, functions, module keys.
  ```lua
  local pkg_path = vim.fn.findfile("package.json", ".;")
  local script_names = vim.tbl_keys(scripts)
  function M.run_script() ... end
  ```
- **camelCase** appears only when calling external APIs that require it (DAP adapter
  fields like `rootDir`, `logLevel`; plugin config keys defined by upstream authors).
- Module table is always named `M`.
- Local aliases for frequently called functions are acceptable:
  ```lua
  local map = vim.keymap.set
  ```
- User commands are `PascalCase` (e.g. `RoSearch`, `RoCommunitySearch`).

### Comments

- Comment the **why**, not the **what**.
- Use `--` single-line comments only; no block comment syntax.
- Disabled/experimental code is kept commented out (not deleted) with a note explaining
  its status if non-obvious.
- The file `lua/plugins/example.lua` is a reference template guarded by
  `if true then return {} end` — do not remove it.

---

## Error Handling

Four patterns are used depending on context:

**1. Guard + early return (preferred in custom modules):**
```lua
if pkg_path == "" then
  vim.notify("No package.json found", vim.log.levels.WARN)
  return
end
```

**2. `vim.notify` with appropriate severity:**
```lua
vim.notify("Zettelkasten folder not found", vim.log.levels.ERROR)
vim.notify("No scripts found in package.json", vim.log.levels.INFO)
```
Match severity to impact: `ERROR` for unrecoverable, `WARN` for degraded operation,
`INFO` for expected empty states.

**3. `assert` for programmer-facing preconditions:**
```lua
assert(type(config) == "table", "must define a config")
assert(config.url ~= nil, "Missing field 'url' in config")
```
Use `assert` only when a wrong call indicates a programming error, not a runtime
condition.

**4. Optional-global capability check:**
```lua
if Snacks then
  Snacks.terminal.open(cmd, { interactive = true })
else
  vim.cmd("split | term " .. cmd)
end
```
Always provide a fallback when relying on globals that may not be loaded.

**Avoid `pcall`/`xpcall` in custom code** unless wrapping a third-party call that is
known to throw. Let lazy.nvim's error reporting surface plugin failures.

---

## Plugin Management

**Plugin manager:** `lazy.nvim` (stable branch, auto-bootstrapped from GitHub).

- Plugin specs live in `lua/plugins/*.lua`. Every file in that directory is
  automatically scanned — no manual registration needed.
- `defaults.lazy = false` — custom plugins load at startup unless marked `lazy = true`
  explicitly.
- `defaults.version = false` — always track latest git commit, not semver tags.
- Plugin versions are pinned in `lazy-lock.json`. Commit lockfile changes deliberately.
- LazyVim extras are declared in `lazyvim.json`. Add extras there, not in Lua code.

---

## Domain: BrightScript / Roku

A significant portion of this config targets Roku development:

- **LSP:** `bsc --lsp` configured in `lua/plugins/lsp.lua`
- **DAP:** `roku-debug` adapter in `lua/plugins/dap.lua` (note: top-level `require("dap")`)
- **Treesitter:** custom `tree-sitter-brightscript` parser in `lua/plugins/treesitter.lua`
- **Filetypes:** `.brs` and `.bs` registered as `brightscript` in `options.lua`
- **XML injections:** BrightScript injected into XML CDATA in `queries/xml/injections.scm`
- **Snippets:** Rooibos test helpers in `snippets/brightscript.lua`
- **Search commands:** `RoSearch`, `RoCommunitySearch` in `lua/custom/search.lua`

When modifying DAP, LSP, or Treesitter for BrightScript, test by opening a `.brs`
or `.xml` (SceneGraph) file inside a real Roku project.

---

## Key Keybindings Added by This Config

| Key           | Action                                 |
|---------------|----------------------------------------|
| `<leader>cx`  | Run npm script from `package.json`     |
| `<leader>fz`  | Create Zettelkasten note (when in CWD) |
| `<leader>jo`  | Search Roku Developer Docs             |
| `<leader>jc`  | Search Roku Community Forum            |
| `<leader>jr`  | Paste Roku registry value at cursor    |
| `<leader>js`  | Reddit-filtered Google search          |
