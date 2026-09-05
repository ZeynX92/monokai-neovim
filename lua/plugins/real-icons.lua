return {
	"Mirsmog/real-icons.nvim",
	build = ":RealIconsInstallPack material",
	cond = not vim.g.vscode,
	event = "VeryLazy",
	enabled = true,
	commit = "82882a5",

	config = function()
		require("real-icons").setup({
			pack = "material",

			overrides = {
				extensions = {
					qml = "../../assets/icons/qml.svg",
				},
				filenames = {
					["hyprland.conf"] = "../../assets/icons/hyprland.svg",
					["hyprland.lua"] = "../../assets/icons/hyprland.svg",
					["hypridle.conf"] = "../../assets/icons/hyprland.svg",
					["hyprlock.conf"] = "../../assets/icons/hyprland.svg",
				},
			},

			integrations = {
				neo_tree = false, -- INFO: kept in sync with lspsaga's winbar, which uses plain nvim-web-devicons
				bufferline = true,
				mini_files = true,
				telescope = true,
				telescope_file_browser = true,
				lualine = true,
			},
		})
	end,
}
