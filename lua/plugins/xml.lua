return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      lemminx = {
        settings = {
          xml = {
            fileAssociations = {
              {
                pattern = "**/*.xml",
                systemId = "https://devtools.web.roku.com/schema/RokuSceneGraph.xsd",
              },
            },
          },
        },
      },
    },
  },
}
