-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap

-- clear search highlights
map.set("n", "<space><CR>", ":nohl<CR>", { desc = "Clear search highlights" })

-- TODO: fazer um atalho para alterar a linha atual como comentário
