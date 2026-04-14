vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', 'U', '<C-r>')

vim.cmd 'nnoremap j gj'
vim.cmd 'nnoremap k gk'
vim.cmd 'nmap <leader>ce :e ~/.config/nvim/init.lua<CR>'

local function get_explorer_item()
  if _G.Snacks == nil or Snacks.picker == nil then
    return nil
  end

  local current_win = vim.api.nvim_get_current_win()
  for _, picker in ipairs(Snacks.picker.get { source = 'explorer' }) do
    if picker.list and picker.list.win and picker.list.win.win == current_win then
      return picker:current()
    end
  end

  return nil
end

local function copy_to_clipboard(value)
  if value and value ~= '' then
    vim.fn.setreg('+', value)
  end
end

local function copy_absolute_path()
  local item = get_explorer_item()
  if item and item.file then
    copy_to_clipboard(item.file)
    return
  end

  local path = vim.fn.expand '%:p'
  local line = vim.fn.line '.'
  local col = vim.fn.col '.'
  copy_to_clipboard(string.format('%s:%d:%d', path, line, col))
end

local function copy_relative_path()
  local item = get_explorer_item()
  if item and item.file then
    copy_to_clipboard(vim.fn.fnamemodify(item.file, ':.'))
    return
  end

  local path = vim.fn.expand '%:.'
  local line = vim.fn.line '.'
  local col = vim.fn.col '.'
  copy_to_clipboard(string.format('%s:%d:%d', path, line, col))
end

vim.keymap.set('n', '<leader>ca', copy_absolute_path, { desc = 'Copy absolute path with line:col' })
vim.keymap.set('n', '<leader>cr', copy_relative_path, { desc = 'Copy relative path with line:col' })

-- Toggle relative/absolute line numbers
vim.keymap.set('n', '<leader>tn', function()
  if vim.o.relativenumber then
    vim.o.relativenumber = false
    vim.o.number = true
  else
    vim.o.relativenumber = true
    vim.o.number = true
  end
end, { desc = 'Toggle relative/absolute number' })

-- vim.keymap.set('n', '<leader>rr', function()
--   for name, _ in pairs(package.loaded) do
--     if name:match '^user' or name:match '^config' or name:match '^custom' then
--       package.loaded[name] = nil
--     end
--   end
--
--   dofile(vim.env.MYVIMRC)
--   vim.notify('Nvim configuration reloaded!', vim.log.levels.INFO)
-- end, { desc = 'Reload Config' })

vim.keymap.set('n', '<leader>wa', '<cmd>wa<CR>', { desc = '[W]rite [A]ll files' })
vim.keymap.set('n', '<leader>ww', '<cmd>set wrap!<CR>', { desc = 'Toggle [W]ord [W]rap' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

if vim.env.TMUX == nil then
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
end
