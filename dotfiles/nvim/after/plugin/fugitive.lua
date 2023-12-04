vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.api.nvim_set_keymap('n', '<leader>gv', ':botright vertical Git<CR>', { noremap = true, silent = true })

