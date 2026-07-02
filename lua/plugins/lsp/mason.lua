return {
	"mason-org/mason.nvim", -- NOTE: repo moved from williamboman/mason.nvim
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Mason",
	dependencies = {
		"mason-org/mason-lspconfig.nvim", -- NOTE: repo moved from williamboman/mason-lspconfig.nvim
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	--  INFO: Keymaps
	keys = {
		{ "<leader>m", "<Cmd>Mason<CR>", desc = "Mason" }, -- Call Mason
	},

	--  INFO: Options
	config = function()
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		--  TIP: UI
		mason.setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		--  TIP: LSPs
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"cssls",
				"emmet_ls",
				"jsonls",
				"html",
				"rust_analyzer",
				"tailwindcss",
				"bashls",
				"hyprls",
				"qmlls",
				"pyright",
				"ruff", -- INFO: Python linter/formatter as LSP
				"clangd", -- INFO: C/C++ LSP
			},
			-- NOTE: mason-lspconfig >= 2.0 calls vim.lsp.enable() automatically
			-- for every server installed above, so a separate vim.lsp.enable({...})
			-- list (see lsp_config.lua) only needs to additionally enable servers
			-- that were NOT installed through Mason (e.g. hyprls, qmlls).
			automatic_enable = true,
		})

		--  TIP: Formatters / linters not tied to an LSP server
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"prettierd",
				"stylua",
				"shfmt",
				"beautysh",
				"taplo",
				"clang-format", -- INFO: C/C++ formatter (clangd does not format on its own)
			},
			run_on_start = true,
			start_delay = 1000,
		})

		--  TIP: Check if all formatters are installed if not install them
		vim.defer_fn(function()
			require("mason-tool-installer").check_install(false)
		end, 1000)
	end,
}
