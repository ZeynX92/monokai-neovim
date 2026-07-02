--
--  HACK: Entry point
--
--  NOTE: This file was missing from the original backup. Neovim looks for
--  init.lua at the root of the config directory (~/.config/nvim/init.lua);
--  without it, none of the files under lua/ are ever loaded.
--
--  This config supports two run modes:
--    1) Standalone Neovim (terminal)      -> lua/config/*  + lazy.nvim plugins
--    2) Neovim as a VS Code backend        -> lua/code/*    (vscode-neovim extension)
--  `vim.g.vscode` is set automatically by the vscode-neovim extension before
--  this file runs, so we just branch on it.
-----------------------------------------------------------

if vim.g.vscode then
	--  INFO: Running inside VS Code (vscode-neovim extension)
	require("code")
else
	--  INFO: Standalone Neovim
	require("config.options")
	require("config.keymaps")
	require("config.autocmds")
	require("config.lazy")
end
