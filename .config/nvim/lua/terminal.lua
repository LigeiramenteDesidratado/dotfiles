local opt = vim.opt
local g = vim.g
local set_keymap = vim.keymap.set

local terminal = {}

local TERMINAL_BUF_NAME = "Popup terminal"

local function get_buf_by_name(name)
  for _, v in pairs(vim.api.nvim_list_bufs()) do
    if vim.endswith(vim.api.nvim_buf_get_name(v), name) then
      return v
    end
  end

  return nil
end

local function find_win_with_buf(buf)
  local tabpage = vim.api.nvim_get_current_tabpage()

  for _, v in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(v) == buf and vim.api.nvim_win_get_tabpage(v) == tabpage then
      return v
    end
  end

  return nil
end

local function open_bottom_split()
  -- Open a window and shove it to the bottom
  vim.cmd("split")
  vim.cmd("wincmd J")
  -- vim.api.nvim_win_set_height(0, 12)
end

local function open_or_focus_term()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)
  if terminal_buf == nil then
    -- We need to create a terminal buffer
    open_bottom_split()

    vim.cmd("terminal")
    vim.cmd("set nobuflisted")
    -- vim.o.signcolumn = "no"
    vim.api.nvim_buf_set_name(0, TERMINAL_BUF_NAME)
  else
    local terminal_win = find_win_with_buf(terminal_buf)
    if terminal_win == nil then
      open_bottom_split()
      vim.api.nvim_win_set_buf(0, terminal_buf)
    else
      vim.api.nvim_set_current_win(terminal_win)
    end
  end

  -- Enter insert mode
  vim.cmd("startinsert")
end

function terminal.hide_term()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)
  if terminal_buf == nil then return end
  local terminal_win = find_win_with_buf(terminal_buf)
  if terminal_win == nil then return end

  vim.api.nvim_win_close(terminal_win, false)
end

-- Save and restore terminal height {{{

local last_term_win_size = nil

function terminal.save_term_win()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)
  if terminal_buf == nil then return end
  local terminal_win = find_win_with_buf(terminal_buf)
  if terminal_win == nil then return end

  last_term_win_size = vim.api.nvim_win_get_height(terminal_win)
end

function terminal.restore_term_win()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)
  if terminal_buf == nil then return end
  local terminal_win = find_win_with_buf(terminal_buf)
  if terminal_win == nil then return end

  if last_term_win_size ~= nil then
    vim.api.nvim_win_set_height(terminal_win, last_term_win_size)
  end
end

-- }}}

local function build_command()

  open_or_focus_term()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)

  vim.api.nvim_chan_send(terminal_buf, "cmake --build build --target world3D -j 2\r")
end

local function run_command()

  open_or_focus_term()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)

  vim.api.nvim_chan_send(terminal_buf, "./build/TestSites/world3D/world3D\r")
end

function terminal.init_config()

  local opts = { noremap = true, silent = true }
  set_keymap('n', "<leader>t", open_or_focus_term, opts)
  set_keymap('n', "<leader>m", build_command, opts)
  set_keymap('n', "<leader>e", run_command, opts)

  set_keymap('t', '<leader>t', "<C-\\><C-n>:lua require('terminal').hide_term()<CR>", opts)
  set_keymap('t', 'jk', '<C-\\><C-n>', opts)
  set_keymap('t', '<C-w>k', '<C-\\><C-n><C-w>k', opts)
  set_keymap('t', '<C-w>j', '<C-\\><C-n><C-w>j', opts)
  set_keymap('t', '<C-w>l', '<C-\\><C-n><C-w>l', opts)
  set_keymap('t', '<C-w>h', '<C-\\><C-n><C-w>h', opts)



  -- autocmd QuitPre * <cmd>lua require('terminal').same_term_win
  vim.cmd [[augroup TerminalG
  autocmd!
  autocmd WinClosed * lua vim.schedule(require('terminal').restore_term_win)
  autocmd TermOpen * setlocal statusline=%#HLBracketsST#[%#HLTextST#%f%#HLBracketsST#]
  augroup END
  ]]

end

return terminal
