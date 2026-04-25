-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- Custom Template Picker
vim.api.nvim_create_user_command("Template", function()
  local template_dir = vim.fn.stdpath("config") .. "/templates"

  -- Check if directory exists
  if vim.fn.isdirectory(template_dir) == 0 then
    vim.notify("Template directory not found: " .. template_dir, vim.log.levels.ERROR)
    return
  end

  -- Get list of files
  local files = vim.fn.readdir(template_dir)
  if #files == 0 then
    vim.notify("No templates found in " .. template_dir, vim.log.levels.WARN)
    return
  end

  -- Use LazyVim's UI to select a file
  vim.ui.select(files, { prompt = "Select a Template:" }, function(choice)
    if choice then
      -- Read the contents of the chosen template into the current buffer
      vim.cmd("0r " .. template_dir .. "/" .. choice)
      vim.notify("Loaded template: " .. choice, vim.log.levels.INFO)
    end
  end)
end, { desc = "Load a template into the current buffer" })
