local opt = vim.opt
local g = vim.g
local set_keymap = vim.keymap.set

-- Comma for leader
g.mapleader = ","

-- Copy/Paste/Cut
opt.clipboard = "unnamed,unnamedplus"

-- Save undo history
opt.undofile = true

-- no backup
opt.backup = false
opt.writebackup = false
opt.swapfile = false

--  Enable hidden buffers
opt.hidden = true

-- When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
opt.autoread = true

-- Enable mouse support
opt.mouse = "a"
-- opt.mousemodel='popup'

-- Default indentation rules
-- opt.tabstop = 8
-- opt.softtabstop = 0
-- opt.expandtab = true
-- opt.shiftwidth = 2
vim.cmd("set smarttab")

-- This gives the end-of-line (<EOL>) formats that will be tried when starting to edit a new buffer and when reading a file into an existing buffer
opt.fileformats = "unix,dos,mac"

-- Use triple braces for folding
opt.foldmethod = "marker"

-- Show file name and path on dwm's bar
opt.title = true

-- Shorten updatetime from the default 4000 for quicker CursorHold updates
-- Used for stuff like the VCS gutter updates
opt.updatetime = 750

-- Incremental search and incremental find/replace
opt.incsearch = true
opt.inccommand = "nosplit"

-- Better display for messages
opt.cmdheight = 0

-- Use case-insensitive search if the entire search query is lowercase
opt.ignorecase = true

-- Shows the effects of a command incrementally, as you type.
opt.smartcase = true

-- Highlight while searching
opt.hlsearch = true

-- Faster redrawing
opt.lazyredraw = true

-- Open splits on the right
opt.splitright = true

-- Fix backspace indent
opt.backspace = "indent,eol,start"

-- Show tabs and trailing whitespace
-- opt.list = true
-- opt.listchars:append("eol:↴,tab: ,")

-- Scroll 12 lines/columns before the edges of a window
opt.scrolloff = 8
-- opt.sidescrolloff = 12

-- Show partial commands in the bottom right
opt.showcmd = true

-- Always show the sign column
-- this makes nvim crash. I don't know why
opt.signcolumn = "yes"

-- More convenient buffers
set_keymap('n', '<S-J>', ':bp<CR>')
set_keymap('n', '<S-K>', ':bn<CR>')
set_keymap('n', '<leader>w', ':bd<CR>')

-- duplicate selection to upper and down without polluting the register
set_keymap('v', "<S-J>", ":t'><cr>")
set_keymap('v', "<S-K>", ":t .-1<cr>")

set_keymap('v', "L", "\"oygvA<esc>\"op")
set_keymap('v', "H", "yP")

-- Switch CWD to the directory of the open buffer
set_keymap('n', "<leader>cd", ": cd %:p:h<cr>:pwd<cr>", { noremap = true })

set_keymap('n', '1', '^')
set_keymap('n', "<leader>,", ":noh<CR>")
set_keymap('n', "<leader>lo", ":messages<CR>")
set_keymap('v', "<leader>p", '"_dp')
set_keymap('v', "<leader>P", '"_dP')

-- swap header and source files
set_keymap('n', '<leader>\'', '<cmd>e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>')


-- disable builtins plugins for faster startup
vim.g.loaded_tar = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
--     vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

opt.termguicolors = true
opt.guicursor = ""

-- require('statusline')
vim.opt.laststatus = 3

require('plugins')
require('config')
require('nvim_cmp')
require('terminal').init_config()

vim.cmd [[augroup Perfume
  autocmd!
  autocmd InsertEnter * set cul
  autocmd InsertLeave * set nocul
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  autocmd TextYankPost * lua vim.highlight.on_yank({ higroup = 'Search', timeout = 500 })
  autocmd CompleteDone * lua if vim.fn.pumvisible() == 0 then vim.cmd("pclose") end
augroup END
]]

-- Diff highlights
vim.cmd [[augroup DiffHighlights
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
vim.cmd [[augroup CError
  autocmd!
  autocmd Colorscheme * hi link cErrinBracket Normal
  autocmd Colorscheme * hi link cErrInParen Normal
augroup END
]]


-- autocmd Colorscheme * hi Normal guibg=#2d2110 guifg=#f8ca9b
vim.cmd [[augroup ColorDefaults
autocmd!
autocmd Colorscheme * hi CursorLine guibg=#39260E ctermbg=233
autocmd Colorscheme * hi SignColumn ctermbg=236 guibg=236
autocmd Colorscheme * hi CExtraWhitespace ctermfg=167 ctermbg=none guibg=#742B1F guifg=none
augroup END
]]

vim.cmd [[augroup global_status_line
autocmd!
  autocmd Colorscheme * hi WinSeparator ctermfg=235 ctermbg=233 guifg=#333333  guibg=none
augroup END
]]

-- LSP highlights
vim.cmd [[augroup LspDiagnosticsRelated
  autocmd!
  autocmd Colorscheme * hi LspDiagnosticsUnderlineError guifg=#EB4917 gui=undercurl
  autocmd Colorscheme * hi LspDiagnosticsUnderlineWarning guifg=#EBA217 gui=undercurl
  autocmd Colorscheme * hi LspDiagnosticsUnderlineInformation guifg=#17D6EB, gui=undercurl
  autocmd Colorscheme * hi LspDiagnosticsUnderlineHint guifg=#17EB7A gui=undercurl
  autocmd Colorscheme * hi LspDiagnosticsDefaultError ctermfg=167 ctermbg=none guifg=#CC6666 guibg=none
  autocmd Colorscheme * hi LspDiagnosticsDefaultWarning ctermfg=167 ctermbg=none guifg=#CCA666 guibg=none
  autocmd Colorscheme * hi LspDiagnosticsDefaultInformation ctermfg=167 ctermbg=none guifg=#66A9CC guibg=none
  autocmd Colorscheme * hi LspDiagnosticsDefaultHint ctermfg=167 ctermbg=none guifg=#85CC66 guibg=none
  autocmd Colorscheme * hi LspReferenceText cterm=underline  gui=underline
  autocmd Colorscheme * hi LspReferenceRead ctermfg=167 ctermbg=none guifg=#85CC66 guibg=none
  autocmd Colorscheme * hi LspReferenceWrite ctermfg=168 ctermbg=none guifg=#d75f87 guibg=none

  autocmd Colorscheme * hi LspInlayHint ctermfg=168 ctermbg=none guifg=#6E6763 guibg=#25211F
  autocmd Colorscheme * hi LspReferenceRead ctermfg=11 ctermbg=236 guifg=#5fafaf guibg=#25211F
  autocmd Colorscheme * hi LspReferenceWrite ctermfg=127 ctermbg=236 guifg=#af00af guibg=#25211F
  autocmd Colorscheme * hi LspReferenceText ctermfg=168 ctermbg=none guifg=#875faf guibg=#25211F
  autocmd Colorscheme * hi MatchParen ctermfg=127 ctermbg=236 guifg=#FFE792 guibg=#454522
  autocmd Colorscheme * hi Search ctermfg=127 ctermbg=236 guifg=#FFE792 guibg=#454522
augroup END
]]

vim.cmd [[augroup GLSL
  autocmd!
  autocmd BufNewFile,BufRead *.vs,*.fs,*.shader,*.smshader,*.vertex,*.fragment set ft=glsl
augroup END
]]

vim.cmd [[cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Q1 q!
cnoreabbrev q1 q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall
]]

-- vim.cmd 'colorscheme zenbones'
-- Set colorscheme after options
vim.cmd('colorscheme default')
