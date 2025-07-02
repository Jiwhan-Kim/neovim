return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason.nvim', config = true },
        { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
        require('mason').setup()
        require('mason-lspconfig').setup {
            ensure_installed = { 'lua_ls', 'clangd' },
        }

        local lspconfig = require('lspconfig')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        local on_attach = function(_, bufnr)
            local nmap = function(keys, func, desc)
                if desc then
                    desc = 'LSP: ' .. desc
                end
                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
            nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
            nmap('<leader>f', function()
                vim.lsp.buf.format { async = true }
            end, '[F]ormat buffer')
        end

        require('mason-lspconfig').setup_handlers {
            function(server)
                lspconfig[server].setup {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }
            end,
        }
    end,
}
