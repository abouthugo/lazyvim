return {
  "folke/snacks.nvim",
  opts = {
    picker = {
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
    },
  },
}
