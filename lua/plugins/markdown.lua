return {
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
      local app_dir = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app"
      vim.fn.system(
        "cd "
          .. app_dir
          .. " && npm install mermaid@latest && cp node_modules/mermaid/dist/mermaid.min.js _static/mermaid.min.js"
      )
    end,
  },
}
