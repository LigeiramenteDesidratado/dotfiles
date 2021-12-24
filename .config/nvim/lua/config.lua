local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>ge', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', "<leader>ld", '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<C-[>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

 -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end

  if client.resolved_capabilities.code_lens then
    vim.cmd [[
      augroup lsp_document_codelens
        au! * <buffer>
        autocmd BufWritePost,CursorHold <buffer> lua vim.lsp.codelens.refresh()
      augroup END
    ]]
  end


  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    update_in_insert = false,

    -- Enable virtual text, override spacing to 4
    virtual_text = {
      spacing = 1,
      prefix = '~',
    },
    -- Use a function to dynamically turn signs off
    -- and on, using buffer local variables
    signs = function(bufnr, _)
      local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'show_signs')
      -- No buffer local variable set, so just enable by default
      if not ok then
        return true
      end

      return result
    end,
  })

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

 local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
nvim_lsp.clangd.setup ({
  ["cmd"] = { 'clangd', '--background-index', '--header-insertion=iwyu' },
   capabilities = capabilities,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  }
})

vim.o.completeopt = "menuone,noselect"

require('nvim-autopairs').setup()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

local cmp = require'cmp'

-- require("nvim-autopairs.completion.cmp").setup({
--   map_cr = true, --  map <CR> on insert mode
--   map_complete = true -- it will auto insert `(` after select function or method item
-- })
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
cmp.setup({
  completion = {
    autocomplete = false
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
      return vim_item
    end
  },
  snippet = {
    expand = function(args)
       vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
    end,
  },
  mapping = {

    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-e>'] = cmp.mapping.close(),
    ['<C-l>'] = function()
      if cmp.visible() then
        cmp.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      })
    else
      cmp.complete()
    end
  end,
    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})

 vim.api.nvim_set_keymap('i', '<C-e>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-e>'", { expr = true })
 vim.api.nvim_set_keymap('i', '<C-q>', "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)': '<C-q>'", { expr = true })
 vim.api.nvim_set_keymap('s', '<C-e>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-e>'", { expr = true })
 vim.api.nvim_set_keymap('s', '<C-q>', "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)': '<C-q>'", { expr = true })


vim.g.buftabline_numbers = 2
vim.g.buftabline_show = 1

vim.cmd[[augroup BufTabline
autocmd!
autocmd Colorscheme * hi BufTabLineCurrent ctermfg=167 ctermbg=none guifg=#85CC66 guibg=none
autocmd Colorscheme * hi BufTabLineActive ctermfg=167 ctermbg=none guifg=#428822 guibg=none
autocmd Colorscheme * hi BufTabLineFill ctermfg=167 ctermbg=none guifg=none guibg=none
autocmd Colorscheme * hi BufTabLineHidden ctermfg=167 ctermbg=none guifg=none guibg=none
augroup END
]]

vim.g.loaded_matchit = 1
vim.g.matchup_matchparen_offscreen = {['method']= 'popup'}






vim.g.move_key_modifier = 'C'



local opts_commented = {
  comment_padding = " ", -- padding between starting and ending comment symbols
  keybindings = {n = "gcc", v = "gc", nl = "gcc"}, -- what key to toggle comment, nl is for mapping <leader>c$, just like dd for d
  prefer_block_comment = false, -- Set it to true to automatically use block comment when multiple lines are selected
  set_keybindings = true, -- whether or not keybinding is set on setup
  ex_mode_cmd = "Comment" -- command for commenting in ex-mode, set it null to not set the command initially.
}

require('commented').setup(opts_commented)


require("dapui").setup()



local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input(vim.fn.getcwd() .. '/', 'build/examples/terror-em-sl/TerrorEmSL')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}
-- If you want to use this for rust and c, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
set_keymap('n', "<leader>x", ":lua require('dap.ui.widgets').hover()<CR>", opts)
set_keymap('n', "<leader>s", ":lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes)<CR>", opts)
set_keymap('n', "<leader>c", ":lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').frames)<CR>", opts)
set_keymap('n', "<F5>", ":lua require'dap'.continue()<CR>", opts)
set_keymap('n', "<leader><CR>", ":lua require'dap'.run_to_cursor()<CR>", opts)
set_keymap('n', "<F2>", ":lua require'dap'.step_over()<CR>", opts)
set_keymap('n', "<F3>", ":lua require'dap'.step_into()<CR>", opts)
set_keymap('n', "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", opts)
set_keymap('n', "<leader>rr", ":lua require'dap'.repl.toggle()<CR>", opts)
set_keymap('n', "<leader><Esc>", ":lua local d = require'dap'; d.disconnect(); d.close()<CR>", opts)



vim.g.better_escape_shortcut = {'jk', 'jj', 'kj'}




require'fzf_lsp'.setup()




vim.g.fzf_preview_window = {'down:50%', 'ctrl-p'}
vim.g.fzf_layout = { ['window']= { ['width']= 0.9, ['height']= 0.9 } }
vim.api.nvim_exec("command! -bang -nargs=* Rg"..
" call fzf#vim#grep("..
"'rg --column --line-number --no-heading --color=always --smart-case --no-ignore-vcs --no-ignore -S -g !.git -g !node_modules -g !go.mod -g !go.sum '.shellescape(<q-args>), 1,"..
"fzf#vim#with_preview({'options': ['--bind=alt-k:preview-up,alt-j:preview-down', '--preview-window=bottom', '--info=inline', '--preview=\"ccat --color=always {}\"']}), <bang>0)", '')

set_keymap('n', '<leader>o', ':Files<CR>', opts )
set_keymap('n', '<leader>f', ':Rg<CR>', opts)
set_keymap('n', '<leader>a', ':Buffers<CR>', opts)
set_keymap('n', '<leader>m', ':History<CR>', opts)

vim.g.signify_sign_add = "▏"
vim.g.signify_sign_change = "▏"
-- keybind.bind_command(edit_mode.NORMAL, "gs", ":SignifyHunkDiff<CR>", { noremap = true })
set_keymap('n', 'gs', ':SignifyHunkDiff<CR>', opts)


require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
    disable_virtual_text = false,
    -- [options]
  },

  indent = {
    enable = true
  },

}

require("nvim-dap-virtual-text").setup {
    enabled = true,                     -- enable this plugin (the default)
    enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,            -- show stop reason when stopped for exceptions
    commented = false,                  -- prefix virtual text with comment string
    -- experimental features:
    virt_text_pos = 'eol',              -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false,                 -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,                 -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil             -- position the virtual text at a fixed window column (starting from the first text column) ,
                                        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

require('iswap').setup{
  -- The keys that will be used as a selection, in order
  -- ('asdfghjklqwertyuiopzxcvbnm' by default)
  keys = 'qwertyuiop',

  -- Grey out the rest of the text when making a selection
  -- (enabled by default)
  -- grey = 'disable',

  -- Highlight group for the sniping value (asdf etc.)
  -- default 'Search'
  hl_snipe = 'ErrorMsg',

  -- Highlight group for the visual selection of terms
  -- default 'Visual'
  hl_selection = 'WarningMsg',

  -- Highlight group for the greyed background
  -- default 'Comment'
  hl_grey = 'LineNr',

  -- Automatically swap with only two arguments
  -- default nil
  autoswap = true
}

set_keymap('n', "<leader>i", "<cmd>ISwap<CR>", opts)
set_keymap('n', "<leader>I", "<cmd>ISwapWith<CR>", opts)
