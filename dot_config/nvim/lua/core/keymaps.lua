-- ============================================================================
-- BASIC NAVIGATION & EDITING
-- ============================================================================

-- Clear search highlights on escape
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Undo/Redo
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo last change' })

-- Move by visual lines (wrap-aware)
vim.keymap.set('n', 'j', 'gj', { desc = 'Move down (visual line)' })
vim.keymap.set('n', 'k', 'gk', { desc = 'Move up (visual line)' })

-- Prevent arrow keys
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>', { noremap = true })
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>', { noremap = true })
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>', { noremap = true })
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>', { noremap = true })

vim.keymap.set('n', 'H', '^', { desc = 'Move to start of line' })
vim.keymap.set('n', 'L', 'g_', { desc = 'Move to end of line' })

-- horizontal scrolling
vim.keymap.set('n', 'zl', '5zl', { desc = 'Scroll right' })
vim.keymap.set('n', 'zh', '5zh', { desc = 'Scroll left' })

vim.keymap.set('i', 'jk', '<Esc>', { desc = 'insert mode esc', nowait = true })
vim.keymap.set('n', '<leader>ep', '<C-^>', { desc = '[E]xplore [p]revious buffer' })

-- Center buffer while navigating
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center cursor' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center cursor' })
vim.keymap.set('n', '{', '{zz', { desc = 'Jump to previous paragraph and center' })
vim.keymap.set('n', '}', '}zz', { desc = 'Jump to next paragraph and center' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Search previous and center' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'Search next and center' })
vim.keymap.set('n', 'gd', 'gdzz', { desc = 'Go to definition and center' })
vim.keymap.set('n', '<C-i>', '<C-i>zz', { desc = 'Jump forward in jump list and center' })
vim.keymap.set('n', '<C-o>', '<C-o>zz', { desc = 'Jump backward in jump list and center' })
vim.keymap.set('n', '%', '%zz', { desc = 'Jump to matching bracket and center' })
vim.keymap.set('n', '*', '*zz', { desc = 'Search for word under cursor and center' })
vim.keymap.set('n', '#', '#zz', { desc = 'Search backward for word under cursor and center' })

vim.keymap.set('v', 'L', '$<left>', { desc = 'Move to end of line in visual mode' })
vim.keymap.set('v', 'H', '^', { desc = 'Move to beginning of line in visual mode' })

-- Join lines while keeping cursor position
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })

-- Move lines up/down (VSCode-style)
vim.keymap.set('n', '<C-Up>', "<Cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = 'Move line up' })
vim.keymap.set('n', '<C-Down>', "<Cmd>execute 'move .+' . v:count1<CR>==", { desc = 'Move line down' })
vim.keymap.set('i', '<C-Up>', '<esc><Cmd>m .-2<CR>==gi', { desc = 'Move line up' })
vim.keymap.set('x', '<C-Up>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('i', '<C-Down>', '<esc><Cmd>m .+1<CR>==gi', { desc = 'Move line down' })
vim.keymap.set('x', '<C-Down>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = 'Move selection down' })

-- ============================================================================
-- INDENTATION & VISUAL MODE
-- ============================================================================

-- Maintain selection after indent
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Preserve selection and cursor on yank in visual mode
vim.keymap.set('x', 'y', 'ygv<Esc>', { desc = 'Yank and preserve selection' })
vim.keymap.set('x', 'p', 'P', { desc = 'Paste without override' })

-- ============================================================================
-- DELETION & CLIPBOARD
-- ============================================================================

-- Delete into void (don't overwrite clipboard)
vim.keymap.set({ 'n', 'x' }, 'x', '"_x', { desc = 'Delete character into void' })
vim.keymap.set({ 'n', 'x' }, '<Del>', '"_x', { desc = 'Delete character into void' })

-- System clipboard operations (copy to system clipboard)
-- Uncomment if you want to use these keybinds
-- vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
-- vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })

-- Delete into void register (don't overwrite clipboard)
-- vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete to void register' })

-- Paste in visual mode without overwriting clipboard (greatest remap ever)
-- Replaces selection with clipboard content without losing what was deleted
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without overwriting clipboard' })

-- Quick save
vim.keymap.set({ 'n', 'i' }, '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })

-- ============================================================================
-- TOGGLE OPTIONS
-- ============================================================================

-- stylua: ignore
vim.keymap.set('n', '<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = '[T]oggle [D]iagnostics' }) 
vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = '[T]oggle [w]ord wrap' })
vim.keymap.set('n', '<leader>ts', ':set list!<CR>', { desc = '[T]oggle [s]pace visibility' })
vim.keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>rr', '<cmd>restart<cr>', { desc = 'Restart Neovim' })

-- ============================================================================
-- COPY PATH
-- ============================================================================

local cp = require 'core.copy_path'

-- stylua: ignore start
vim.keymap.set('n', '<leader>ca', function() cp { absolute = true } end, { desc = 'Copy absolute path' })
vim.keymap.set('n', '<leader>cr', function() cp {} end,                  { desc = 'Copy relative path' })
vim.keymap.set('v', '<leader>cr', function() cp { visual = true } end,   { desc = 'Copy relative path with line range' })
-- stylua: ignore end

-- ============================================================================
-- COMMAND ABBREVIATIONS (typo fixes)
-- ============================================================================

vim.cmd 'cnoreabbrev W w'
vim.cmd 'cnoreabbrev Wa wa'
vim.cmd 'cnoreabbrev Wq wq'
vim.cmd 'cnoreabbrev WQ wq'
vim.cmd 'cnoreabbrev Q q'
vim.cmd 'cnoreabbrev Qa qa'

-- ============================================================================
-- NOTES: Default keymaps not remapped
-- ============================================================================

-- Spelling (built-in):
--   ]s / [s       → next/prev misspelled word
--   z=            → spelling suggestions
--   zg            → add to spellfile
--   zw            → mark as wrong
--   zu            → undo correction
--   :set spell    → enable spell checking

-- LSP (set by lsp.lua):
--   gra           → code actions
--   gri           → implementations
--   grn           → rename
--   grr           → references
--   grt           → type definition
--   grx           → run codelens
--   gO            → document symbols
--   <C-S>         → signature help (insert mode)
