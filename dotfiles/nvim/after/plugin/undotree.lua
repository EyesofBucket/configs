vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>uf", function()
    vim.cmd.UndotreeShow()
    vim.cmd.UndotreeFocus()
end)

vim.g.undotree_WindowLayout = 2
vim.g.undotree_ShortIndicators = 1

