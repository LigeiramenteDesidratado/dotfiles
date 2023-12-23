local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local lua_snip_status_ok, luasnip = pcall(require, "luasnip")
if not lua_snip_status_ok then
	return
end
luasnip.config.setup {}

local kind_icons = {
	Boolean = "",
	Class = "ﴯ",
	Color = "",
	Constant = "",
	Constructor = "",
	Enum = "",
	EnumMember = "",
	Event = "",
	Field = "",
	File = "",
	Folder = "",
	Function = "",
	Interface = "",
	Keyword = "",
	Method = "",
	Module = "",
	Operator = "",
	Property = "ﰠ",
	Reference = "",
	Snippet = "",
	Struct = "ﯟ",
	Text = "",
	TypeParameter = "",
	Unit = "塞",
	Value = "",
	Variable = "",
}

vim.opt.completeopt = { "menu", "menuone", "noselect" }

cmp.setup {

	completion = {
		autocomplete = false
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	-- window = {
	--   completion = cmp.config.window.bordered(),
	--   documentation = cmp.config.window.bordered(),
	-- },
	ghost_text = {
		hl_group = "LspCodeLens",
	},
	sources = cmp.config.sources {
		{ name = "nvim_lsp" },
		{ name = 'luasnip' }, -- For vsnip users.
		{ name = "buffer",     max_item_count = 5, keyword_length = 3 },
		{ name = "treesitter", max_item_count = 5, keyword_length = 3 },
		{ name = "path" },
	},
	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				path = "[Path]",
				ultisnips = "[USnips]",
				buffer = "[Buffer]",
				nvim_lua = "[Lua]",
				treesitter = "[Treesitter]",
			})[entry.source.name]
			vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
			return vim_item
		end,
	},

	mapping = cmp.mapping.preset.insert {
		['<C-Space>'] = cmp.mapping.complete {},
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		["<C-h>"] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		},
		['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<C-l>'] = function()
			if cmp.visible() then
				cmp.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				})
			else
				cmp.complete {}
			end
		end,


		['<C-e>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<C-q>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),

	},
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ "/", "?" }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = "buffer" },
--   },
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "path" },
--   }, {
--     { name = "cmdline" },
--   }),
-- })


local npairs_status_ok, npairs = pcall(require, "nvim-autopairs")
if not npairs_status_ok then
	return
end

npairs.setup {
	disable_filetype = { "vim", "help" },
	check_ts = true,
	ts_config = {
		lua = { "string", "comment" }, -- it will not add a pair on that treesitter node
	},
}

local cmp_autopair_status_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopair_status_ok then
	return
end

cmp.event:on(
	"confirm_done",
	cmp_autopairs.on_confirm_done {
		map_char = { tex = "" },
	}
)
