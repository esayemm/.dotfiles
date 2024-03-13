return {
	{
		"echasnovski/mini.ai",
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				line = "<C-_>",
			},
			opleader = {
				line = "<C-_>",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			-- use nerdfonts icons
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					map("n", "<leader>hs", gs.stage_hunk, { desc = "stage hunk" })
					map("n", "<leader>hr", gs.reset_hunk, { desc = "reset hunk" })
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "stage hunk" })
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "reset hunk" })
					map("n", "<leader>hS", gs.stage_buffer, { desc = "stage buffer" })
					map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "reset buffer" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "preview hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "blame line" })
					map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle current line blame" })
					map("n", "<leader>hd", gs.diffthis, { desc = "diff this" })
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end, { desc = "diff this (base)" })
					map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle deleted" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{ "famiu/bufdelete.nvim" },
	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = 20,
			open_mapping = [[<c-\>]],
			direction = "horizontal",
		},
	},
	{
		"jedrzejboczar/possession.nvim",
		config = function()
			local cwd = vim.fn.getcwd():gsub("/", "%%")

			require("possession").setup({
				commands = {
					save = "SSave",
					load = "SLoad",
					delete = "SDelete",
					list = "SList",
				},
				autosave = { current = true, tmp = true, tmp_name = cwd, on_load = true, on_quit = true },
			})
		end,
	},
}
