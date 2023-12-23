-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

local open_in_nvim_tree = function(prompt_bufnr)
	local action_state = require("telescope.actions.state")
	local Path = require("plenary.path")
	local actions = require("telescope.actions")

	local entry = action_state.get_selected_entry()[1]
	local entry_path = Path:new(entry):parent():absolute()
	actions._close(prompt_bufnr, true)
	entry_path = Path:new(entry):parent():absolute()
	entry_path = entry_path:gsub("\\", "\\\\")

	-- vim.cmd("NvimTreeClose")
	-- vim.cmd("NvimTreeOpen " .. entry_path)

	file_name = nil
	for s in string.gmatch(entry, "[^/]+") do
		file_name = s
	end

	vim.cmd("/" .. file_name)
	vim.cmd("NvimTreeFindFile")
end

-- configure telescope
telescope.setup({
	-- configure custom mappings
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
})

telescope.load_extension("fzf")
