return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      layout = {},
      win = {
        input = {
          keys = {
            ["<c-r>"] = {
              "preview_scroll_up",
              mode = { "i", "n" },
            },
            ["<Tab>"] = {
              "list_down",
              mode = { "i", "n" },
            },
            ["<S-Tab>"] = {
              "list_up",
              mode = { "i", "n" },
            },
          },
        },
      },
      formatters = {
        file = {
          -- whatever sane or insane value you need, default was 40
          truncate = 40,
        },
      },
    },
  },
}
