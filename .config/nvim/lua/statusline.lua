vim.cmd[[augroup StatusLineColor
  autocmd!
  autocmd Colorscheme * hi HLBracketsST ctermfg=243 ctermbg=234 guifg=#85dc85  guibg=#1c1c1c
  autocmd Colorscheme * hi HLTextST ctermfg=243 ctermbg=234 guifg=#eeeeee  guibg=#303030
augroup END
]]

-- Statusline Modifications
local statusline = "%#HLBracketsST#"
statusline = statusline .. " [%#HLTextST#%f%#HLBracketsST#]"
statusline = statusline .. " [%#HLTextST#%Y%#HLBracketsST#]"
-- statusline = statusline .. " [%#ShowMarksHLl#%{Fugitivestatusline()}%#HLBracketsST#]"
statusline = statusline .. " %m%r%h%w"
statusline = statusline .. "%="
statusline = statusline .. " [%#HLTextST#%{&fileencoding?&fileencoding:&encoding}%#HLBracketsST#]"
statusline = statusline .. " [%#HLTextST#%{&fileformat}%#HLBracketsST#]"
statusline = statusline .. " [ROW:%#HLTextST#%-3l%#HLBracketsST#]"
statusline = statusline .. " [COL:%#HLTextST#%-2c%#HLBracketsST#]"
statusline = statusline .. " [%#HLTextST#%-3p%#HLBracketsST#%%] "

vim.opt.statusline = statusline
vim.opt.laststatus = 3

