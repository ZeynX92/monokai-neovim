return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				-- INFO: Web
				html = { "prettier" },
				css = { "prettier" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettier" },

				-- INFO: PHP
				php = { "php_cs_fixer" },

				-- INFO: Config
				lua = { "stylua" },
				luau = { "stylua" },
				toml = { "taplo" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				zsh = { "beautysh" },
				jsonc = { "prettier" },

				-- INFO: Other
				rust = { "rustfmt" },
				python = { "ruff_fix", "autopep8" }, -- INFO: Fix lint issues (imports и т.д.), затем PEP8-форматирование как в PyCharm
				c = { "clang_format" },
				cpp = { "clang_format" },
			},

			formatters = {
				autopep8 = {
					prepend_args = { "--max-line-length", "120", "--aggressive", "--aggressive" },
					-- INFO: max-line-length=120 совпадает с дефолтом PyCharm;
					-- две --aggressive заставляют autopep8 агрессивнее чинить PEP8-нарушения,
					-- что ближе к поведению "Reformat Code" в PyCharm
				},
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
				async = false,
			},

			notify_on_error = true,
			notify_no_formatters = true,
		})
	end,
}
