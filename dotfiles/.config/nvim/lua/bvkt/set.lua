vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

if (vim.loop.os_uname().sysname == "Windows_NT")
then
    vim.opt.undodir = os.getenv("USERPROFILE") .. "/.vim/undodir"
else
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.mouse = ""

vim.opt.showmode = false
