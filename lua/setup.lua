vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.xaml",
  command = "set filetype=xml"
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.CPP",
  command = "set filetype=cpp"
})
