return {
  ["example block"] = {
    prefix = "example",
    body = {
      "> [!EXAMPLE]",
      "> $0",
    },
  },
  ["note block"] = {
    prefix = "note",
    body = {
      "> [!NOTE]",
      "> $0",
    },
  },
  ["warn block"] = {
    prefix = "warn",
    body = {
      "> [!WARNING]",
      "> $0",
    },
  },
  ["success block"] = {
    prefix = "success",
    body = {
      "> [!SUCCESS]",
      "> $0",
    },
  },
  ["error block"] = {
    prefix = "error",
    body = {
      "> [!ERROR]",
      "> $0",
    },
  },
  ["todo checkbox"] = {
    prefix = "todo",
    body = "- [${1: }] $0",
  },
}
