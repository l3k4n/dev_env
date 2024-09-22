local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = require("telescope.config").values.file_previewer({}),
    sorter = require("telescope.config").values.generic_sorter({}),
  }):find()
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Open window" })
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Add" })

    vim.keymap.set("n", "<leader>j", function() harpoon:list():select(1) end, { desc = "Harpoon: select 1" })
    vim.keymap.set("n", "<leader>k", function() harpoon:list():select(2) end, { desc = "Harpoon: select 2" })
    vim.keymap.set("n", "<leader>l", function() harpoon:list():select(3) end, { desc = "Harpoon: select 3" })
    vim.keymap.set("n", "<leader>;", function() harpoon:list():select(4) end, { desc = "Harpoon: select 4" })
  end
}
