return {
  { "nvim-neotest/neotest-go" },
  { "nvim-neotest/neotest-python" },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { "neotest-go", "neotest-python" } },
  },
}
