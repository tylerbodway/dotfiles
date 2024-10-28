return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-jest",
    "zidhuss/neotest-minitest",
    "olimorris/neotest-rspec",
  },
  opts = {
    adapters = {
      "neotest-plenary",
      "neotest-jest",
      "neotest-minitest",
      "neotest-rspec",
    },
  },
}
