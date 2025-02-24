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
          },
        },
      },
    },
  },
}
