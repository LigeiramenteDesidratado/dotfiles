local opt = vim.opt
local g = vim.g
local set_keymap = vim.keymap.set

local nvim_lsp = require('lspconfig')

vim.cmd [[augroup StatusLineColor
  autocmd!
  autocmd Colorscheme * hi HLBracketsST ctermfg=243 ctermbg=234 guifg=#85dc85  guibg=#1c1c1c
  autocmd Colorscheme * hi HLTextST ctermfg=243 ctermbg=234 guifg=#eeeeee  guibg=#303030
augroup END
]]

-- Statusline Modifications
local statusline = "%#HLTextST# [%Y] %f %= R:%-3l C:%-2c %-2p%%"

vim.opt.statusline = statusline
vim.opt.laststatus = 3


local aug = vim.api.nvim_create_augroup("buf_large", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
	callback = function()
		local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
		if ok and stats and (stats.size > 1000000) then
			vim.b.large_buf = true
			vim.cmd("syntax off")
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.spell = false
		else
			vim.b.large_buf = false
		end
	end,
	group = aug,
	pattern = "*",
})



-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', '<leader>ge', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', '<leader>d', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
	-- vim.keymap.set('n', "<leader>q", vim.lsp.buf.document_symbol, opts)
	-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '<C-N>', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<leader>=', vim.lsp.buf.format, opts)

	vim.keymap.set('n', '<leader>\\', vim.lsp.buf.document_highlight, opts)
	vim.keymap.set('n', "<leader>,", ":noh<CR>:lua vim.lsp.buf.clear_references()<CR>", opts)

	if client.resolved_capabilities and client.resolved_capabilities.document_highlight then
		vim.cmd [[
		augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]]
	end


	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = true,
			update_in_insert = false,
			-- Disable virtual_text
			-- virtual_text = false,
			-- Enable virtual text, override spacing to 4
			virtual_text = {
				spacing = 1,
				prefix = '~',
			},
			-- Use a function to dynamically turn signs off
			-- and on, using buffer local variables
			signs = function(buffer_n, _)
				local ok, result = pcall(vim.api.nvim_buf_get_var, buffer_n, 'show_signs')
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


local function setup_lsp(server, opts)
	local conf = nvim_lsp[server]
	conf.setup(opts)
	local try_add = conf.manager.try_add
	conf.manager.try_add = function(bufnr)
		if not vim.b.large_buf then
			return try_add(bufnr)
		end
	end
end

setup_lsp(
	"clangd",
	{
		on_attach = on_attach,
		capabilities = capabilities,
		["cmd"] = { 'clangd', '--background-index', "--clang-tidy",
			"--background-index-priority=background",
			"--suggest-missing-includes",
			"--inlay-hints",
			"--header-insertion=never",
			"--cross-file-rename",
			"--completion-style=bundled", }
	}
)

nvim_lsp.lua_ls.setup({
	cmd = { 'lua-language-server' },
	-- An example of settings for an LSP server.
	--    For more options, see nvim-lspconfig
	settings = {
		Lua = {
			telemetry = { enable = false },
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Setup your lua path
				path = vim.split(package.path, ';'),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand('$VIMRUNTIME/lua')] = true,
					[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
				},
			},
		}
	},
	capabilities = capabilities,
	on_attach = on_attach,
})

nvim_lsp.rls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		rust = {
			unstable_features = true,
			build_on_save = false,
			all_features = true,
		},
	},
}

-- setup golang lsp
nvim_lsp.gopls.setup({
	cmd = { 'gopls' },
	capabilities = capabilities,
	on_attach = on_attach,
})

opt.completeopt = "menuone,noselect"

local npairs = require('nvim-autopairs')
npairs.setup({
	check_ts = true,
	fast_wrap = {
		map = '<M-e>',
		chars = { '{', '[', '(', '"', "'" },
		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
		offset = 0, -- Offset from pattern match
		end_key = '$',
		keys = 'jkhlfnpasdw',
		check_comma = true,
		highlight = 'Search',
		highlight_grey = 'Comment'
	},
})

g.loaded_matchit = 1
g.matchup_matchparen_offscreen = { ['method'] = 'popup' }


g.move_key_modifier = 'C'
g.move_key_modifier_visualmode = 'C'

require('Comment').setup()

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
			if not vim.g.dap_executable then
				vim.g.dap_executable = vim.fn.input(
					"Path to executable: ",
					vim.fn.getcwd() .. "/",
					"file")
			end
			return vim.g.dap_executable
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
		args = function()
			if not vim.g.dap_args then
				local str = vim.fn.input("args: ")
				vim.g.dap_args = vim.fn.split(str)
			end
			return vim.g.dap_args
		end,
		runInTerminal = false,
	},
}
-- If you want to use this for rust and c, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
set_keymap('n', "<leader>x", ":lua require('dap.ui.widgets').hover()<CR>")
set_keymap('n', "<leader>st", ":lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes)<CR>")
set_keymap('n', "<leader>c", ":lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').frames)<CR>")
set_keymap('n', "<F5>", ":lua require'dap'.continue()<CR>")
set_keymap('n', "<leader><CR>", ":lua require'dap'.run_to_cursor()<CR>")
set_keymap('n', "<F2>", ":lua require'dap'.step_over()<CR>")
set_keymap('n', "<F3>", ":lua require'dap'.step_into()<CR>")
set_keymap('n', "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
set_keymap('n', "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
-- set_keymap('n', "<leader>rr", ":lua require'dap'.repl.toggle()<CR>")
set_keymap('n', "<leader><Esc>", ":lua local d = require'dap'; d.disconnect(); d.close()<CR>")
set_keymap('n', "<leader><C-i>", ":lua vim.lsp.inlay_hint(0)<CR>")

require("dapui").setup()

g.better_escape_shortcut = { 'jk', 'jj', 'kj' }

-- g.fzf_preview_window = { 'right:40%', 'ctrl-p' }
g.fzf_layout = { ['down'] = '45%' }

set_keymap('n', '<leader>o', ':GFiles<CR>')
set_keymap('n', '<leader>O', ':Files<CR>')
set_keymap('n', '<leader>f', ':Rg<CR>')
set_keymap('n', '<leader>a', ':Buffers<CR>')
set_keymap('n', '<leader>h', ':History<CR>')

local gitsigns = require('gitsigns');

gitsigns.setup { signs       = {
	add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
	change       = {
		hl = 'GitSignsChange',
		text = '│',
		numhl = 'GitSignsChangeNr',
		linehl = 'GitSignsChangeLn'
	},
	delete       = {
		hl = 'GitSignsDelete',
		text = '_',
		numhl = 'GitSignsDeleteNr',
		linehl = 'GitSignsDeleteLn'
	},
	topdelete    = {
		hl = 'GitSignsDelete',
		text = '‾',
		numhl = 'GitSignsDeleteNr',
		linehl = 'GitSignsDeleteLn'
	},
	changedelete = {
		hl = 'GitSignsChange',
		text = '~',
		numhl = 'GitSignsChangeNr',
		linehl = 'GitSignsChangeLn'
	},
},
	signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir                 = {
		interval = 1000,
		follow_files = true
	},
	attach_to_untracked          = true,
	current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts      = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
	sign_priority                = 6,
	update_debounce              = 100,
	status_formatter             = nil, -- Use default
	max_file_length              = 40000, -- Disable if file is longer than this (in lines)
	preview_config               = {
		-- Options passed to nvim_open_win
		border = 'none',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	},
	yadm                         = {
		enable = false
	},

	on_attach                    = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', 'gn', function()
			if vim.wo.diff then return 'gn' end
			vim.schedule(function() gs.next_hunk() end)
			return '<Ignore>'
		end, { expr = true })

		map('n', 'gN', function()
			if vim.wo.diff then return 'gN' end
			vim.schedule(function() gs.prev_hunk() end)
			return '<Ignore>'
		end, { expr = true })

		-- Actions
		map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
		map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
		map('n', '<leader>hS', gs.stage_buffer)
		map('n', '<leader>hR', gs.reset_buffer)
		map('n', '<leader>hu', gs.undo_stage_hunk)
		map('n', 'gs', gs.preview_hunk)
		map('n', '<leader>hb', function() gs.blame_line { full = true } end)
		-- map('n', '<leader>tb', gs.toggle_current_line_blame)
		map('n', '<leader>hd', gs.diffthis)
		map('n', '<leader>hD', function() gs.diffthis('~') end)
		map('n', '<leader>hh', gs.toggle_deleted)

		-- Text object
		map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end


}


-- require("nvim-dap-virtual-text").setup {
-- 	enabled = true,              -- enable this plugin (the default)
-- 	enabled_commands = true,     -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
-- 	highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
-- 	highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
-- 	show_stop_reason = true,     -- show stop reason when stopped for exceptions
-- 	commented = false,           -- prefix virtual text with comment string
-- 	-- experimental features:
-- 	virt_text_pos = 'eol',       -- position of virtual text, see `:h nvim_buf_set_extmark()`
-- 	all_frames = false,          -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
-- 	virt_lines = false,          -- show virtual lines instead of virtual text (will flicker!)
-- 	virt_text_win_col = nil      -- position the virtual text at a fixed window column (starting from the first text column) ,
-- 	-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
-- }

-- Define my note location
-- g.nv_search_paths = { '~/Notes/Notes' }
-- set_keymap('n', "<leader>.", "<cmd>NV<CR>")

-- g.markdown_fenced_languages = { 'go=go', 'coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript',
-- 	'ruby', 'sass', 'xml' }

-- Disable annoying folding
-- g.vim_markdown_folding_disabled = 1

require("symbols-outline").setup({
	autofold_depth = 0,
	auto_unfold_hover = false,
});

set_keymap('n', "<leader>q", "<cmd>SymbolsOutline<CR>")

-- require 'nvim-treesitter.configs'.setup {
-- 	-- A list of parser names, or "all" (the four listed parsers should always be installed)
-- 	disable = function() return vim.b.large_buf end,
-- 	ensure_installed = { "c", "lua", "vim", "cpp", "rust", "hare" },
--
-- 	-- Install parsers synchronously (only applied to `ensure_installed`)
-- 	sync_install = false,
--
-- 	-- Automatically install missing parsers when entering buffer
-- 	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
-- 	auto_install = true,
--
-- 	-- List of parsers to ignore installing (for "all")
-- 	ignore_install = { "javascript" },
--
-- 	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
-- 	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
--
-- 	highlight = {
-- 		-- `false` will disable the whole extension
-- 		enable = true,
-- 		disable = function() return vim.b.large_buf end,
-- 		-- Instead of true it can also be a list of languages
-- 		additional_vim_regex_highlighting = false,
-- 	},
-- }

-- require('iswap').setup {
-- 	-- The keys that will be used as a selection, in order
-- 	-- ('asdfghjklqwertyuiopzxcvbnm' by default)
-- 	keys = 'qwertyuiop',
--
-- 	-- Grey out the rest of the text when making a selection
-- 	-- (enabled by default)
-- 	grey = 'disable',
--
-- 	-- Highlight group for the sniping value (asdf etc.)
-- 	-- default 'Search'
-- 	hl_snipe = 'ErrorMsg',
--
-- 	-- Highlight group for the visual selection of terms
-- 	-- default 'Visual'
-- 	hl_selection = 'WarningMsg',
--
-- 	-- Highlight group for the greyed background
-- 	-- default 'Comment'
-- 	hl_grey = 'LineNr',
--
-- 	-- Post-operation flashing highlight style,
-- 	-- either 'simultaneous' or 'sequential', or false to disable
-- 	-- default 'sequential'
-- 	flash_style = false,
--
-- 	-- Highlight group for flashing highlight afterward
-- 	-- default 'IncSearch'
-- 	hl_flash = 'ModeMsg',
--
-- 	-- Move cursor to the other element in ISwap*With commands
-- 	-- default false
-- 	move_cursor = true,
--
-- 	-- Automatically swap with only two arguments
-- 	-- default nil
-- 	autoswap = true,
--
-- 	-- Other default options you probably should not change:
-- 	debug = nil,
-- 	hl_grey_priority = '1000',
-- }

-- set_keymap('n', "<leader>i", ":ISwapWith<CR>")
-- set_keymap('n', "<leader>I", ":ISwap<CR>")

-- require 'treesitter-context'.setup {
-- 	enable = true,     -- Enable this plugin (Can be enabled/disabled later via commands)
-- 	max_lines = 0,     -- How many lines the window should span. Values <= 0 mean no limit.
-- 	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
-- 	line_numbers = true,
-- 	multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
-- 	trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
-- 	mode = 'cursor',   -- Line used to calculate context. Choices: 'cursor', 'topline'
-- 	-- Separator between context and content. Should be a single character string, like '-'.
-- 	-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
-- 	separator = nil,
-- 	zindex = 20, -- The Z-index of the context window
-- }

-- require("sg").setup {
-- 	-- Pass your own custom attach function
-- 	--    If you do not pass your own attach function, then the following maps are provide:
-- 	--        - gd -> goto definition
-- 	--        - gr -> goto references
-- 	on_attach = on_attach
-- }
