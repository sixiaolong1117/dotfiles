-- NeoVim configuration
-- This file is intentionally plugin-free so it works on a fresh install.

local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

opt.number = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.completeopt = { "menu", "menuone", "noselect" }

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>w", "<cmd>write<cr>", opts)
keymap("n", "<leader>q", "<cmd>quit<cr>", opts)
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", opts)
keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)

keymap("n", "<leader>sv", "<cmd>vsplit<cr>", opts)
keymap("n", "<leader>sh", "<cmd>split<cr>", opts)
keymap("n", "<c-h>", "<c-w>h", opts)
keymap("n", "<c-j>", "<c-w>j", opts)
keymap("n", "<c-k>", "<c-w>k", opts)
keymap("n", "<c-l>", "<c-w>l", opts)

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("n", "<leader>y", '"+y', opts)
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>p", '"+p', opts)

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    pcall(function()
      vim.cmd([[%s/\s\+$//e]])
    end)
    vim.fn.setpos(".", save_cursor)
  end,
})
