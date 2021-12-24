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

return require('packer').startup(function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'habamax/vim-colors-lessthan'
  use 'matsuuu/pinkmare'
  use 'bluz71/vim-moonfly-colors'
  use 'savq/melange'
  use 'kristijanhusak/vim-hybrid-material'
  use 'Mizux/vim-colorschemes'
  use { 'neovim/nvim-lspconfig', as = 'lspconfig' }
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'ap/vim-buftabline'
  use 'andymass/vim-matchup'
  use 'windwp/nvim-autopairs'
  use { 'junegunn/fzf.vim', requires = { 'junegunn/fzf' }, run = function() vim.fn["fzf#install"]() end }
  use { 'gfanto/fzf-lsp.nvim', requires = 'junegunn/fzf.vim' }
  use 'jdhao/better-escape.vim' 
  use 'mfussenegger/nvim-dap' 
  use 'machakann/vim-sandwich' 
  use 'theHamsta/nvim-dap-virtual-text'
  use 'matze/vim-move' 
  use  'godlygeek/tabular'
  use  'mhinz/vim-signify'
  use  'winston0410/commented.nvim'
  use { 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap'} }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'mizlan/iswap.nvim' }
  use { 'dracula/vim' }

end)
