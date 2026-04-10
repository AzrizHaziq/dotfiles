if not vim.g.vscode then
  return
end

local opts = { noremap = true, silent = true }

local mappings = {
  { 'n', '<leader>ge', 'editor.action.marker.next' },
  { 'n', '<leaderp>gE', 'editor.action.marker.prev' },
  { 'n', '<leader>cp', 'copyFilePath' },
  { 'n', '<leader>cr', 'copyRelativeFilePath' },
  { 'n', '<leader>re', 'editor.action.rename' },
  { 'n', '<leader>.', 'editor.action.quickFix' },
  { 'n', '<leader>zc', 'editor.fold' },
  { 'n', '<leader>zR', 'editor.unfoldAll' },
  { 'n', '<leader>za', 'editor.toggleFold' },
  { 'n', '<leader>zM', 'editor.foldAll' },
  { 'n', '<leader>zo', 'editor.unfold' },
}

for _, mapping in ipairs(mappings) do
  local mode, key, command = mapping[1], mapping[2], mapping[3]

  vim.keymap.set(mode, key, function()
    vim.fn.VSCodeNotify(command)
  end, opts)
end
