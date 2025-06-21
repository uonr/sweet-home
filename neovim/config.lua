---@diagnostic disable: undefined-global
vim.loader.enable()

if vim.o.background == "dark" then
    vim.cmd.background("dark")
else
    vim.cmd.background("light")
end
