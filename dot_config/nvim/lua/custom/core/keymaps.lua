vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', 'U', '<C-r>')

vim.cmd 'nnoremap j gj'
vim.cmd 'nnoremap k gk'
vim.cmd 'nmap <leader>ce :e ~/.config/nvim/init.lua<CR>'

vim.keymap.set('n', '<leader>ca', function()
  if vim.bo.filetype == 'oil' then
    return
  end

  local path = vim.fn.expand '%:p'
  local line = vim.fn.line '.'
  local col = vim.fn.col '.'
  local full = string.format('%s:%d:%d', path, line, col)
  vim.fn.setreg('+', full)
end, { desc = 'Copy absolute path with line:col' })

vim.keymap.set('n', '<leader>cr', function()
  if vim.bo.filetype == 'oil' then
    return
  end

  local path = vim.fn.expand '%:.'
  local line = vim.fn.line '.'
  local col = vim.fn.col '.'
  local full = string.format('%s:%d:%d', path, line, col)
  vim.fn.setreg('+', full)
end, { desc = 'Copy relative path with line:col' })

vim.keymap.set('n', '<leader>rr', function()
  for name, _ in pairs(package.loaded) do
    if name:match '^user' or name:match '^config' or name:match '^custom' then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify('Nvim configuration reloaded!', vim.log.levels.INFO)
end, { desc = 'Reload Config' })

if vim.g.vscode then
  vim.keymap.set('n', '<leader>fr', function()
    vim.fn.VSCodeNotify 'workbench.files.action.showActiveFileInExplorer'
  end, { silent = true, desc = 'Reveal file in Explorer' })
else
  vim.keymap.set('n', '<leader>fr', function()
    require('oil').open_float(vim.fn.expand '%:p:h')
  end, { desc = 'Reveal current file in Oil' })
end

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
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
