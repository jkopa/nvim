vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.xaml",
  command = "set filetype=xml"
})
