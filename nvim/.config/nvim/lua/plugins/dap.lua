return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
    "nvim-neotest/nvim-nio",
    "mason-org/mason.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")

    -- Setup DAP UI
    dapui.setup()

    -- Setup virtual text
    dap_virtual_text.setup()

    -- DAP signs
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "🔵", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "🟡", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "", linehl = "", numhl = "" })

    -- Java DAP configuration (jdtls provides this automatically with debug bundles)
    dap.configurations.java = {
      {
        type = "java",
        request = "launch",
        name = "Debug (Launch) - Current File",
        mainClass = "${file}",
      },
      {
        type = "java",
        request = "launch",
        name = "Debug (Launch) - Main Class",
        mainClass = function()
          return vim.fn.input("Main class: ", "", "file")
        end,
      },
    }

    -- Python DAP configuration
    require("dap-python").setup("python")

    -- TypeScript/JavaScript DAP configuration
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    dap.configurations.javascript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }

    dap.configurations.typescript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runtimeExecutable = "node",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }

    dap.configurations.typescriptreact = dap.configurations.typescript

    -- -- DAP UI auto open/close
    -- dap.listeners.after.event_initialized["dapui_config"] = function()
    -- 	dapui.open()
    -- end
    -- dap.listeners.before.event_terminated["dapui_config"] = function()
    -- 	dapui.close()
    -- end
    -- dap.listeners.before.event_exited["dapui_config"] = function()
    -- 	dapui.close()
    -- end

    -- Keymaps
    local opts = { noremap = true, silent = true }
    local keymap = vim.keymap.set

    keymap("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opts)
    keymap("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
    keymap("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
    keymap("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
    keymap("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
    keymap("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
    keymap(
      "n",
      "<Leader>lp",
      "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
      opts
    )
    keymap("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
    keymap("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts)
    keymap("n", "<Leader>du", "<Cmd>lua require'dapui'.toggle()<CR>", opts)
  end,
}
