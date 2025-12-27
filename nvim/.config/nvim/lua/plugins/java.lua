return {
  -- 1. Import the official LazyVim Java extra (remove this, it is redundant with the import in lazy.lua)
  -- { import = "lazyvim.plugins.extras.lang.java" },
  -- 2. Extend the nvim-jdtls plugin configuration
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- A. Merge your specific 'settings' (Google style, Lombok, etc.)
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          format = {
            enabled = true,
            settings = {
              url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
              profile = "AOSP",
            },
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          saveActions = { organizeImports = true },
          referencesCodeLens = { enabled = true },
          inlayHints = { parameterNames = { enabled = "all" } },
          completion = {
            favoriteStaticMembers = {
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
            importOrder = {
              "com",
              "lombok",
              "org",
              "jakarta",
              "javax",
              "java",
              "",
              "#",
            },
          },
          sources = {
            organizeImports = { starThreshold = 9999, staticThreshold = 9999 },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            hashCodeEquals = { useJava7Objects = true },
            useBlocks = true,
          },
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = os.getenv("JAVA_HOME"),
              },
            },
            updateBuildConfiguration = "interactive",
          },
        },
      })
      -- B. Inject your 'on_attach' logic
      -- LazyVim calls opts.on_attach(args) where args = { buf = bufnr, data = { client_id = id } }
      local original_on_attach = opts.on_attach
      opts.on_attach = function(args)
        -- Run LazyVim's default attachment logic first
        if original_on_attach then
          original_on_attach(args)
        end
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        -- Your Custom Indentation Settings
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.cmd.set("list")
        vim.opt_local.smartindent = false

        -- Disable semantic tokens as requested
        if client then
          client.server_capabilities.semanticTokensProvider = nil
        end
        -- Your Custom Formatting/Imports Autocmd
        -- Note: LazyVim has its own autoformatting, but this ensures your specific logic runs
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            require("jdtls").organize_imports()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end
    end,
  },
}
