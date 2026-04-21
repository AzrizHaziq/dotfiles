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

-- keep on highlight text and can hit multiple time < or >
vim.keymap.set('v', '<', '<gv', { desc = 'indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'indent right and reselect' })

vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = '[T]oggle [w]ord wrap' })
vim.keymap.set('n', '<leader>tW', ':set list!<CR>', { desc = '[T]oggle [W]hiteSpace' })
vim.keymap.set('n', '<leader>tn', '<cmd>set relativenumber!<CR>', { desc = '[T]oggle [N]umber or relative number' })
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = '[T]oggle [D]iagnostics' })

-- seems like will not be using this
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<leader>wa', '<cmd>wa<CR>', { desc = '[W]rite [A]ll files' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })

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

-- like vscode alt+down/up move loc up down swapping
-- from https://github.com/nickjj/dotfiles/blob/master/.config/nvim/lua/config/keymaps.lua
vim.keymap.set('n', '<C-Up>', "<Cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = 'Move Up' })
vim.keymap.set('n', '<C-Down>', "<Cmd>execute 'move .+' . v:count1<CR>==", { desc = 'Move Down' })
vim.keymap.set('i', '<C-Down>', '<esc><Cmd>m .+1<CR>==gi', { desc = 'Move Down' })
vim.keymap.set('i', '<C-Up>', '<esc><Cmd>m .-2<CR>==gi', { desc = 'Move Up' })
vim.keymap.set('x', '<C-Down>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = 'Move Down' })
vim.keymap.set('x', '<C-Up>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = 'Move Up' })

vim.keymap.set({ 'n', 'x' }, 'x', '"_x', { desc = 'Delete Chars Into Void' })
vim.keymap.set({ 'n', 'x' }, 'X', '"_D', { desc = 'Delete to EOL Into Void' })
vim.keymap.set({ 'n', 'x' }, '<Del>', '"_x', { desc = 'Delete Chars Into Void' })

vim.keymap.set('x', 'y', 'ygv<Esc>', { desc = 'Yank Preserve Cursor' })
vim.keymap.set('x', 'p', 'P', { desc = 'Paste Without Override' })

-- this trigger external command
-- vim.keymap.set('x', 'gt', "c<C-r>=system('tcc', getreg('\"'))[:-2]<CR>", { desc = 'Titleize Text' })
