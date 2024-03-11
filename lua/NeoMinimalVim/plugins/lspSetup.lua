local lsp = require('lsp-zero')
local cmp = require("cmp")


-- Set recommended LSP preset
lsp.preset("recommended")


-- Ensure installation of multiple language servers
lsp.ensure_installed({
    'tsserver',
    'eslint',
    'rust_analyzer',
    'kotlin_language_server',
    'jdtls',
    'lua_ls',
    'jsonls',
    'html',
    'elixirls',
    'tailwindcss',
    'tflint',
    'pylsp',
    'dockerls',
    'bashls',
    'marksman'
})


-- Set LSP keybindings
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts, { desc = "LSP Goto Reference"})
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts, { desc = "LSP Goto Definition"})
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts, { desc = "LSP Hover"})
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts, { desc = "LSP Workspace Symbol"})
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.setloclist() end, opts, { desc = "LSP Show Diagnostics"})
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts, { desc = "Next Diagnostic"})
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts, { desc = "Previous Diagnostic"})
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts, { desc = "LSP Code Action"})
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts, { desc = "LSP References"})
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts, { desc = "LSP Rename"})
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts, { desc = "LSP Signature Help"})
end)

-- Set cmp select behavior
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.setup({
    on_attach = lsp.on_attach,
    capabilities = lsp.capabilities
})


-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})


local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer',  keyword_length = 3 },
        { name = 'path' },
        { name = 'copilot' }
    },
    mapping = {
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    },
})
