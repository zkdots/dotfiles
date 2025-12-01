return {
  "mfussenegger/nvim-jdtls",
  config = function()
    local jdtls = require("jdtls")
    -- Mason paths
    local mason = vim.fn.stdpath("data") .. "/mason"
    local lombok = mason .. "/share/jdtls/lombok.jar" -- Adjust if path differs
    local launcher = vim.fn.glob(mason .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
    local config_dir = mason .. "/packages/jdtls/config_linux" -- Change to 'mac' for macOS
    -- Full cmd with Lombok
    local cmd = {
      "java",
      "-javaagent:" .. lombok,
      "-Xbootclasspath/a:" .. lombok,
      "-jar",
      launcher,
      "-configuration",
      config_dir,
      "-data",
      vim.fn.stdpath("cache") .. "/jdtls/workspace",
    }
    -- Capabilities for completion/snippets
    local capabilities = {
      workspace = { configuration = true },
      textDocument = { completion = { snippetSupport = false } },
    }
    -- Java settings for diagnostics/code lenses, with formatting enabled using Google style
    local settings = {
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
          organizeImports = {
            starThreshold = 9999,
            staticThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          hashCodeEquals = {
            useJava7Objects = true,
          },
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
    }
    local on_attach = function(client, bufnr)
      -- Set indentation options for Java
      vim.opt.expandtab = false
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.cmd.set("list")
      vim.api.nvim_command("filetype indent off")
      vim.api.smartindent = false
      -- Disable semantic token highlights
      client.server_capabilities.semanticTokensProvider = nil
      -- Organize imports + format before save (kept as in your config)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          require("jdtls").organize_imports()
          vim.lsp.buf.format({ async = false })
        end,
      })
      -- Refresh code lenses
      vim.lsp.codelens.refresh()
      -- Keymaps for diagnostics and navigation
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    end
    -- Autocmd for multi-project support: start JDTLS on every Java file
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local root_dir = vim.fs.root(0, { "pom.xml", "build.gradle", ".git" })
        jdtls.start_or_attach({
          cmd = cmd,
          root_dir = root_dir,
          capabilities = capabilities,
          settings = settings,
          on_attach = on_attach,
        })
      end,
    })
  end,
}
