local vim = vim

opts = { noremap=true, silent=true }
opts_expr = { noremap=true, silent=true, expr=true }

function set_keymap(...) vim.api.nvim_set_keymap(...) end
function set_option(...) vim.api.nvim_set_option(...) end

-- Comma for leader, backslash for local leader
vim.g.mapleader = ","

-- Copy/Paste/Cut
vim.o.clipboard = "unnamed,unnamedplus"

-- Save undo history
vim.o.undofile = true

-- no backup
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

--  Enable hidden buffers
vim.o.hidden = true

-- When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
vim.o.autoread = true

-- Enable mouse support
vim.o.mouse = "a"
vim.o.mousemodel='popup'

-- Default indentation rules
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.cmd("set smarttab")

-- This gives the end-of-line (<EOL>) formats that will be tried when starting to edit a new buffer and when reading a file into an existing buffer
vim.o.fileformats="unix,dos,mac"

-- Use triple braces for folding
vim.o.foldmethod = "marker"

-- Show file name and path on dwm's bar
vim.o.title = true

-- Shorten updatetime from the default 4000 for quicker CursorHold updates
-- Used for stuff like the VCS gutter updates
vim.o.updatetime = 750

-- Incremental search and incremental find/replace
vim.o.incsearch = true
vim.o.inccommand = "nosplit"

-- Better display for messages
vim.o.cmdheight = 2

-- Use case-insensitive search if the entire search query is lowercase
vim.o.ignorecase = true

-- Shows the effects of a command incrementally, as you type.
vim.o.smartcase = true

-- Highlight while searching
vim.o.hlsearch = true

-- Faster redrawing
vim.o.lazyredraw = true

-- Open splits on the right
vim.o.splitright = true

-- Fix backspace indent
vim.o.backspace = "indent,eol,start"

-- Show tabs and trailing whitespace
vim.opt.list = true
-- vim.opt.listchars = { tab = '│', eol = ' ', trail = '-'}

-- Scroll 12 lines/columns before the edges of a window
vim.o.scrolloff = 12
vim.o.sidescrolloff = 12

-- Show partial commands in the bottom right
vim.o.showcmd = true

-- Always show the sign column
-- this makes nvim crash. I don't know why
vim.o.signcolumn = "yes"

-- vim.o.termguicolors = true

-- More convenient buffers
set_keymap('n', '<S-J>', ':bp<CR>', opts)
set_keymap('n', '<S-K>', ':bn<CR>', opts)
set_keymap('n', '<leader>w', ':bd<CR>', opts)

-- duplicate selection to upper and down without polluting the register
set_keymap('v', "<S-J>", ":t'><cr>", opts)
set_keymap('v', "<S-K>", ":t .-1<cr>", opts)

-- Paste in visual mode without polluting the register
-- set_keymap('v', "<leader>p", '"_dP', opts)
-- set_keymap('v', "<leader>P", '"_dP', opts)

-- Switch CWD to the directory of the open buffer
set_keymap('n', "<leader>cd", ": cd %:p:h<cr>:pwd<cr>", { noremap=true })

set_keymap('n', "<leader>,", ":noh<CR>", opts)
set_keymap('n', "<leader>lo", ":messages<CR>", opts)

set_keymap('v', "<leader>p", '"_dp', opts)
set_keymap('v', "<leader>P", '"_dP', opts)

require('statusline')
require('plugins')
require('config')
require('terminal').init_config()

vim.cmd[[augroup Perfume
  autocmd!
  autocmd InsertEnter,InsertLeave * set cul!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  autocmd TextYankPost * lua vim.highlight.on_yank({ higroup = 'Search', timeout = 100 })
  autocmd CompleteDone * lua if vim.fn.pumvisible() == 0 then vim.cmd("pclose") end
augroup END
]]

-- Diff highlights
vim.cmd[[augroup DiffHighlights
  autocmd!
  autocmd Colorscheme * hi DiffAdd ctermfg=193 ctermbg=none guifg=#66CC6C guibg=none
  autocmd Colorscheme * hi DiffChange ctermfg=189 ctermbg=none guifg=#B166CC guibg=none
  autocmd Colorscheme * hi DiffDelete ctermfg=167 ctermbg=none guifg=#CC6666 guibg=none
  autocmd Colorscheme * hi MatchWordCur cterm=underline gui=underline
  autocmd Colorscheme * hi MatchParenCur cterm=underline gui=underline
  autocmd Colorscheme * hi MatchWord cterm=underline gui=underline
  autocmd Colorscheme * hi DiffAdd ctermfg=193 ctermbg=none guifg=#66CC6C guibg=none
  autocmd Colorscheme * hi DiffChange ctermfg=189 ctermbg=none guifg=#B166CC guibg=none
  autocmd Colorscheme * hi DiffDelete ctermfg=167 ctermbg=none guifg=#CC6666 guibg=none
augroup END
]]

-- remove a syntax error in C files
vim.cmd[[augroup CError
  autocmd!
  autocmd Colorscheme * hi link cErrinBracket Normal
  autocmd Colorscheme * hi link cErrInParen Normal
augroup END
]]

vim.opt.termguicolors = true

vim.cmd[[augroup ColorDefaults
autocmd!
autocmd Colorscheme * hi Normal guibg=233 ctermbg=233
autocmd Colorscheme * hi SignColumn ctermbg=236 guibg=236
autocmd Colorscheme * hi CExtraWhitespace ctermfg=167 ctermbg=none guibg=#742B1F guifg=none
augroup END
]]

-- LSP highlights
vim.cmd[[augroup LspDiagnosticsRelated
  autocmd!
  autocmd Colorscheme * hi LspDiagnosticsUnderlineError guifg=#EB4917 gui=undercurl
  autocmd Colorscheme * hi LspDiagnosticsUnderlineWarning guifg=#EBA217 gui=undercurl
  autocmd Colorscheme * hi LspDiagnosticsUnderlineInformation guifg=#17D6EB, gui=undercurl
  autocmd Colorscheme * hi LspDiagnosticsUnderlineHint guifg=#17EB7A gui=undercurl
  autocmd Colorscheme * hi LspDiagnosticsDefaultError ctermfg=167 ctermbg=none guifg=#CC6666 guibg=none
  autocmd Colorscheme * hi LspDiagnosticsDefaultWarning ctermfg=167 ctermbg=none guifg=#CCA666 guibg=none
  autocmd Colorscheme * hi LspDiagnosticsDefaultInformation ctermfg=167 ctermbg=none guifg=#66A9CC guibg=none
  autocmd Colorscheme * hi LspDiagnosticsDefaultHint ctermfg=167 ctermbg=none guifg=#85CC66 guibg=none
  autocmd Colorscheme * hi LspReferenceText cterm=underline ctermfg=167 ctermbg=none gui=underline guifg=#85CC66 guibg=none
  autocmd Colorscheme * hi LspReferenceRead ctermfg=167 ctermbg=none guifg=#85CC66 guibg=none
  autocmd Colorscheme * hi LspReferenceWrite ctermfg=168 ctermbg=none guifg=#d75f87 guibg=none
augroup END
]]

vim.cmd[[augroup matchup_matchparen_highlight
  autocmd!
  autocmd ColorScheme * hi MatchParen ctermfg=202 guifg=#ff5f00
augroup END
]]

vim.cmd("colorscheme pinkmare")
