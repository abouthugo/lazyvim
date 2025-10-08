return {
  ["rooibos testSuite"] = {
    prefix = "testSuite",
    body = {
      "namespace $1Test",
      '\t@SGNode("$1")',
      '\t@suite("$1 tests")',
      "\tclass $1Tests extends rooibos.BaseTestSuite",
      "\t\t$0",
      "\tend class",
      "end namespace",
    },
  },
  ["rooibos setup"] = {
    prefix = "setup",
    body = {
      "\t\tprotected override sub setup()",
      "\t\t\t$0",
      "\t\tend sub",
    },
  },
  ["rooibos it"] = {
    prefix = "it",
    body = {
      '\t\t@it("$1")',
      "\t\tsub _()",
      "\t\t$0",
      "\t\tend sub",
    },
  },
  ["Observe field"] = {
    prefix = "ofi",
    body = { 'ObserveField("$1", $0)' },
  },
  ["Create Object"] = {
    prefix = "cobj",
    body = { 'createObject("roSGNode", "$0")' },
  },
  ["Find Node"] = {
    prefix = "fnode",
    body = { 'm.top.findNode("$0")' },
  },
}
