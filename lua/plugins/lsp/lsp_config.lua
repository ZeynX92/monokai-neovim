return {
	-- HACK: LSPs config
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		enabled = true,

		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp", enabled = true },
		},

		config = function()
			-- HACK: LSPs

			-- INFO: LSPs configs

			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						--  TIP: make the language server recognize "vim" global
						diagnostics = {
							globals = { "vim" },
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
				filetypes = { "lua", "luau" },
			})

			vim.lsp.config("emmet_ls", {
				filetypes = {
					"html",
					"css",
					"scss",
					"javascriptreact",
					"typescriptreact",
					"svelte",
					"vue",
					"javascript",
					"typescript",
				},
				showSuggestionsAsSnippets = true,
			})

			vim.lsp.config("qmlls", {
				cmd = { "qml-language-server" },
				filetypes = { "qml" },
				root_markers = { ".qmlls.ini", "shell.qml", ".git" },
			})

			--  INFO: C / C++ (clangd)
			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
				root_markers = {
					"compile_commands.json",
					"compile_flags.txt",
					".clangd",
					"CMakeLists.txt",
					"Makefile",
					".git",
				},
				--  TIP: clangd needs utf-16 offsets, unlike most other servers
				capabilities = {
					offsetEncoding = { "utf-16" },
				},
			})

			--  HACK: Auto-detect the project's virtualenv so pyright doesn't fall
			--  back to a system Python that lacks the project's dependencies
			--  (this is what causes [reportMissingImports] even though the
			--  packages are installed — pyright was just looking in the wrong
			--  interpreter). Defined before the "ruff" config below so both
			--  servers can use it.
			local function find_python_path()
				--  TIP: Respect an already-activated venv first
				if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
					local activated = vim.env.VIRTUAL_ENV .. "/bin/python"
					if vim.fn.executable(activated) == 1 then
						return activated
					end
				end

				--  TIP: Otherwise look for a common venv folder name in the project root
				local root = vim.fs.root(0, { "pyrightconfig.json", "pyproject.toml", "setup.py", ".git" })
					or vim.fn.getcwd()

				for _, name in ipairs({ ".venv", "venv", "env", ".env" }) do
					local candidate = root .. "/" .. name .. "/bin/python"
					if vim.fn.executable(candidate) == 1 then
						return candidate
					end
				end

				--  TIP: Fall back to whatever "python3" resolves to in PATH
				return vim.fn.exepath("python3")
			end

			--  INFO: Python (Ruff as linter/formatter LSP, runs alongside Pyright)
			vim.lsp.config("ruff", {
				filetypes = { "python" },
				init_options = {
					settings = {
						logLevel = "error",
						interpreter = { find_python_path() },
					},
				},
			})

			--  INFO: Python (Pyright as type-checker, defers import-sorting to Ruff)
			vim.lsp.config("pyright", {
				before_init = function(_, config)
					config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
						python = { pythonPath = find_python_path() },
					})
				end,
				settings = {
					python = {
						pythonPath = find_python_path(),
						analysis = {
							diagnosticSeverityOverrides = {
								reportAttributeAccessIssue = "none",
								reportPrivateImportUsage = "none",
							},
						},
					},
					pyright = {
						--  TIP: Avoid clashing with Ruff's import organizer
						disableOrganizeImports = true,
					},
				},
			})

			-- INFO: LSPs activation
			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"html",
				"cssls",
				"jsonls",
				"emmet_ls",
				"rust_analyzer",
				"tailwindcss",
				"bashls",
				"hyprls",
				"qmlls",
				"pyright",
				"ruff",
				"clangd",
			})
		end,
	},

	-- HACK: Diagnostic config
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000, --  TIP: needs to be loaded in first
		keys = {
			{ "<leader>td", "<Cmd>lua require('tiny-inline-diagnostic').toggle()<CR>", desc = "Toggle diagnostics" },
		},
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "modern",
				transparent_bg = false,
				transparent_cursorline = false,
				signs = {
					diag = "󱓻",
				},
				hi = {
					mixing_color = "CursorColumn",
				},
				options = {
					use_icons_from_diagnostic = true,

					multilines = {
						enabled = true,
						always_show = false,
					},
				},
				disabled_ft = {},
			})

			--  INFO: Change the Diagnostic symbols
			vim.diagnostic.config({
				underline = false,
				virtual_text = false,
				update_in_insert = false,
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = "󰠠 ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
			})
		end,
	},
}
