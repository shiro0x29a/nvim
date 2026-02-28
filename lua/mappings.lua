vim.g.mapleader = " "

-- Other
-- to make home_or_word plugin work
vim.keymap.set('n', '<Home>', ':Home<CR>', { silent = true })

-- Termux
--vim.api.nvim_set_keymap('', '<c-1>', '<Nop>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('', '<c-2>', ':shortcut.next-session', { noremap = true, silent = true })
vim.keymap.set('n', '<c-1>', ':shortcut.next-session<CR>')
vim.keymap.set('n', '<c-2>', ':shortcut.previous-session<CR>')

vim.keymap.set('n', '<c-r>', ':redo<CR>')
vim.keymap.set('n', '<c-u>', ':undo<CR>')

-- vim.keymap.set('n', '<c-e>', ':Ex<CR>')
vim.keymap.set('n', '<c-w>', ':w<CR>')

local ex_to_current_file = function()
  local cur_file = vim.fn.expand('%:t')
  vim.cmd.Ex()
  vim.fn.search('^'..cur_file..'$')
end

vim.keymap.set('n', '<c-e>', ex_to_current_file, { desc = 'Netrw: jump to current file' })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    pcall(vim.keymap.del, "n", "t", { buffer = true })
    
    vim.keymap.set("n", "e", function()
      local netrw_dir = vim.b.netrw_curdir or vim.fn.getcwd()
      
      local filename = vim.fn.expand("<cfile>")
      
      if filename ~= "" and filename ~= "./" and filename ~= "../" then
        local fullpath = netrw_dir .. "/" .. filename
        fullpath = fullpath:gsub("//", "/")
        
        vim.cmd("tabedit " .. vim.fn.fnameescape(fullpath))
      end
    end, { buffer = true, desc = "Open in new tab" })
    
  end,
})

vim.keymap.set("n", "tg", "gT")
-- NeoTree
--vim.keymap.set('n', '<leader>E', ':Neotree float reveal<CR>')
--vim.keymap.set('n', '<leader>e', ':Neotree left reveal<CR>')
--vim.keymap.set('n', '<leader>o', ':Neotree float git_status<CR>')

-- Navigation
--vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
--vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
--vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
--vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
--vim.keymap.set('n', '<leader>c', ':ToggleComment<CR>')

-- Splits
--vim.keymap.set('n', '|', ':vsplit<CR>')
--vim.keymap.set('n', '\\', ':split<CR>')

-- Other
--vim.keymap.set('n', '<leader>w', ':w<CR>')
--vim.keymap.set('n', '<leader>x', ':BufferLinePickClose<CR>')
--vim.keymap.set('n', '<leader>X', ':BufferLineCloseRight<CR>')
--vim.keymap.set('n', '<leader>s', ':BufferLineSortByTabs<CR>')
--vim.keymap.set('i', 'jj', '<Esc>')
--vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- Tabs
--vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>')
--vim.keymap.set('n', '<s-Tab>', ':BufferLineCyclePrev<CR>')

-- Terminal
--vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<CR>')
--vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<CR>')
--vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical size=40<CR>')
