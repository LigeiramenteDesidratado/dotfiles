-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end,
	},
}

return require('packer').startup(function(use)
	-- Packer can manage itself
	use { 'wbthomason/packer.nvim' }

	-- Colors
	use { 'habamax/vim-colors-lessthan' }
	use { 'tomasr/molokai' }
	-- use { 'savq/melange' }
	-- use { "mcchrish/zenbones.nvim", requires = "rktjmp/lush.nvim" }
	-- use { 'sainnhe/sonokai' }
	-- use { "lmburns/kimbox" }
	-- use { 'matsuuu/pinkmare' }
	-- use { 'bluz71/vim-moonfly-colors' }
	-- use { 'Yazeed1s/oh-lucy.nvim' }
	-- use { 'jaredgorski/SpaceCamp' }
	-- use { 'wincent/base16-nvim' }
	-- use { 'Shadorain/shadotheme' }
	-- use { 'thedenisnikulin/vim-cyberpunk' }
	-- use { 'ayaz-amin/cyberpunk.nvim' }
	-- use { 'neftaio/vim-cyberpunk' }
	-- use { 'ryanoasis/vim-devicons' }
	-- use { 'logico/typewriter-vim' }

	-- use {
	--     "mcchrish/zenbones.nvim",
	--     -- Optionally install Lush. Allows for more configuration or extending the colorscheme
	--     -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
	--     -- In Vim, compat mode is turned on as Lush only works in Neovim.
	--     requires = "rktjmp/lush.nvim"
	-- }
	-- use { 'dracula/vim' }
	-- use { 'ray-x/aurora' }
	-- use { 'sheerun/vim-polyglot' }
	-- use { 'kristijanhusak/vim-hybrid-material' }
	-- use { 'Mizux/vim-colorschemes' }
	-- use { 'andreasvc/vim-256noir' }
	-- use { 'Badacadabra/vim-archery' }
	-- use { 'jaredgorski/fogbell.vim' }
	-- use { 'yonlu/omni.vim' }
	-- use { 'rebelot/kanagawa.nvim' }
	-- use { 'marko-cerovac/material.nvim' }
	-- use { 'ntk148v/vim-horizon' }
	-- use { 'iandwelker/rose-pine-vim' }
	-- use { 'liuchengxu/space-vim-dark' }
	-- use { 'LunarVim/horizon.nvim' }

	use { 'neovim/nvim-lspconfig' }
	use { 'hrsh7th/nvim-cmp',
		requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-path' },
	}
	use { 'windwp/nvim-autopairs' }
	use { 'machakann/vim-sandwich' }
	use { 'numToStr/Comment.nvim' }

	use { 'junegunn/fzf.vim', requires = { 'junegunn/fzf' }, run = function() vim.fn["fzf#install"]() end }
	-- use { 'gfanto/fzf-lsp.nvim', requires = 'junegunn/fzf.vim' }


	use { 'jdhao/better-escape.vim' }
	use { 'mfussenegger/nvim-dap' }
	-- use { 'theHamsta/nvim-dap-virtual-text' }
	use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }

	use { 'matze/vim-move' }
	use { 'godlygeek/tabular' }
	use { 'lewis6991/gitsigns.nvim' }
	-- use { 'norcalli/nvim-colorizer.lua' }
	-- use { 'eckon/treesitter-current-functions' }
	-- use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', requires = {
		-- 'nvim-treesitter/nvim-treesitter-textobjects', 'nvim-treesitter/nvim-treesitter-context',
		-- 'mizlan/iswap.nvim' } }
	-- use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', requires = {
	-- 'mizlan/iswap.nvim' } }
	-- use { 'toppair/reach.nvim' }
	-- use { 'plasticboy/vim-markdown' }
	-- use { 'github/copilot.vim' }
	-- use { 'liuchengxu/vista.vim' }
	use { 'jghauser/mkdir.nvim' }
	use { 'tpope/vim-fugitive' }
	-- use { "potamides/pantran.nvim" }
	-- use { 'jose-elias-alvarez/null-ls.nvim', requires = { "nvim-lua/plenary.nvim" }, }
	-- use { 'nacro90/numb.nvim' }
	-- use { 'lukas-reineke/indent-blankline.nvim' }
	-- use { 'p00f/clangd_extensions.nvim' }
	-- use { 'rhysd/vim-grammarous' }
	-- use { 'lvimuser/lsp-inlayhints.nvim' }
	use { 'https://git.sr.ht/~sircmpwn/hare.vim' }
	use { 'https://git.sr.ht/~torresjrjr/vim-haredoc' }
	use { 'simrat39/symbols-outline.nvim' }
	use { 'mbbill/undotree' }
	use { 'cdelledonne/vim-cmake' }
	-- use { 'sheerun/vim-polyglot' }
end)
