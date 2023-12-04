require'FTerm'.setup({
    border = 'rounded'
})

vim.keymap.set('n', '<C-Space>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-Space>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
