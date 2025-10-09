function SearchBuilder(config)
  assert(type(config) == "table", "must define a config")
  assert(config.url ~= nil, "Missing field 'url' in config")
  local prompt = config.prompt or "Search the web"
  return function()
    vim.ui.input({ prompt = prompt }, function(input)
      if input and input ~= "" then
        local url = config.url .. input
        vim.fn.jobstart({ "open", url })
      end
    end)
  end
end

vim.api.nvim_create_user_command(
  "RoSearch",
  SearchBuilder({ url = "https://developer.roku.com/search?qs=", prompt = "  Search Roku Docs" }),
  { desc = "Search Roku Developer Documentation" }
)

vim.api.nvim_create_user_command(
  "RoCommunitySearch",
  SearchBuilder({ url = "https://community.roku.com/search?q=", prompt = "  Search Roku Community" }),
  { desc = "Search google with reddit filter" }
)

vim.api.nvim_create_user_command(
  "RedditSearch",
  SearchBuilder({ url = "https://google.com/search?q=site:reddit.com ", prompt = "  Search with Reddit filter" }),
  { desc = "Search google with reddit filter" }
)

local map = vim.keymap.set

map("n", "<leader>jo", "<cmd>RoSearch<cr>", { desc = "Roku Search" })
map("n", "<leader>jc", "<cmd>RoCommunitySearch<cr>", { desc = "Roku community search" })
map("n", "<leader>jr", "<cmd>RedditSearch<cr>", { desc = "Reddit Filter Search" })
