local vim = vim
local Plug = vim.fn['plug#']
local cmd = vim.cmd
local opt = vim.opt

vim.api.nvim_set_option('clipboard','unnamedplus') 

vim.call('plug#begin')

Plug('tpope/vim-fugitive')

Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('VonHeikemen/lsp-zero.nvim', { ['branch']  = 'v4.x'})

Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')

Plug('nvim-lua/plenary.nvim')

Plug('EdenEast/nightfox.nvim') 
Plug('nordtheme/vim')

vim.call('plug#end')

vim.cmd('colorscheme nord')

vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<C-h>", "<gv")
vim.keymap.set("v", "<C-l>", ">gv")

opt.number = true 
opt.ignorecase = true
opt.relativenumber = true
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.encoding = 'UTF-8'
opt.fileencodings = 'utf-8', 'utf-8-bom', 'cp1251'
opt.guifont = 'FiraCode Nerd Font Mono:h10'

local lsp_zero = require('lsp-zero')

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

local get_intelephense_license = function ()
    local f = assert(io.open(os.getenv("HOME") .. "/intelephense/license.txt","rb"))
    local content = f:read("*a")
    f:close()
    return string.gsub(content, "%s+", "")
end

require('lspconfig').perlpls.setup({})

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
    
    ['intelephense'] = function()
      require('lspconfig').intelephense.setup({
        on_attach = on_attach, 
	      capabilities = capabilities,
        init_options = {
	        licenceKey = get_intelephense_license(),
	      },
	      settings = {
	        intelephense = {
            runtime = true,
            maxMemory = 8192,
	          files = {
	            maxSize = 50000000
	          }
	       }
	    }   
    })
    end
    ['jdtls'] = function()
        require('lspconfig').jdtls.setup({})
    end,  
  }
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
  mapping = cmp.mapping.preset.insert({
    -- Navigate between completion items
    ['<C-p>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),

    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.vim_snippet_jump_forward(),
    ['<C-b>'] = cmp_action.vim_snippet_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = {"*.php", "*.json"},
  callback = function()
      path = vim.api.nvim_buf_get_name(0)
      cur = vim.fn.getcwd()
      path = path:gsub(cur .. '/', '')
      code = string.format('rsync -R %s HOST', path)
      vim.fn.jobstart(code)
  end
})

require('editorconfig').properties.charset = function(bufnr, val)
  assert(vim.tbl_contains({"utf-8", "utf-8-bom", "latin1", "utf-16be", "utf-16le", "cp1251"}, val), "charset must be one of 'utf-8', 'utf-8-bom', 'latin1', 'utf-16be', or 'utf-16le', 'cp1251'")
  if ((val == "utf-8") or (val == "utf-8-bom")) then
    vim.bo[bufnr]["fileencoding"] = "utf-8"
    vim.bo[bufnr]["bomb"] = (val == "utf-8-bom")
    return nil
  elseif val == 'cp1251' then
    vim.bo[bufnr]["fileencoding"] = val
    cmd("e ++enc=" .. val)
  else
    vim.bo[bufnr]["fileencoding"] = val
    return nil
  end
end
